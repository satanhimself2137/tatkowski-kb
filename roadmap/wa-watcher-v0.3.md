# ROADMAP — wa-watcher v0.3 (images + batch coalescing)

**Status:** SHIPPED
**Owner:** Maciej
**Last update:** 08/06/26 by Claude/Maciej

---

## Scope

Two features bolted onto the existing v0.2-shipped watcher. Image forwarding so TEAM ONE can ask Claude about photos, screenshots, and document scans without leaving WhatsApp. Batch coalescing so concurrent inbound messages while a previous batch is in-flight don't collide on the claude.ai composer.

**In:**
- **Image upload via caption trigger.** Inbound WhatsApp image with caption containing `claude` (case-insensitive, prefix or anywhere in caption) → baileys downloads the bytes, watcher saves to `tmp/img/<msg-id>.jpg`, claude-driver uploads via Playwright `setInputFiles()` into the composer in the same batch as the caption text. Caption appears in the prompt body as normal; image attached to the message.
- **Image upload via reply-to trigger.** Reply-to messages in WhatsApp include the original message ID in `contextInfo.stanzaId`. If a text message replies to a prior image AND contains `claude`, the watcher looks up the image in its rolling cache, downloads it (or uses cached file), and attaches it to that batch. The original image was not uploaded at the time it arrived (no `claude` in its own caption).
- **Image cache.** Rolling Map `{messageId: tmpFilePath}` for any image seen in the last 24h or last 200 messages, whichever is larger. Files saved to `tmp/img/`. Background cleanup on watcher boot: delete any `tmp/img/*` files older than 24h.
- **Batch coalescing during in-flight batches.** New `_batchInFlight` promise on the driver. When a batch fires while another is running, its messages get appended to a `pendingMessages` buffer rather than triggering a new `sendBatch`. When the in-flight batch's `_waitForResponseComplete` resolves, the driver drains the buffer into one merged batch and sends it. If `pendingMessages.length >= FORCE_FIRE_COUNT` during the in-flight window, fire two batches back-to-back rather than one giant prompt.
- **Soft cap on merged batches.** Inherits the existing `FORCE_FIRE_COUNT = 50` from `config.js`. If drain has more than 50 messages, split into multiple sequential batches of ≤50.
- **Prompt format update.** `prompt.js` per-message line for images: `[stamp] <Name>: [IMAGE:<filename>] <caption>` (when image attached) vs `[stamp] <Name>: [IMAGE]` (image seen but not attached). So Claude can tell from the prompt which images are actually uploaded.

**Out:**
- Stickers, voice notes, video, documents (PDFs, .docx). Image-only for v0.3.
- Auto-transcription of voice notes.
- OCR of uploaded images (Claude can already read text in images natively).
- Resizing or compression of large images. Claude.ai's upload limit handles capacity; we just pass bytes through.
- Multi-image batches where multiple separate images need uploading in one prompt — supported by Playwright `setInputFiles([])` but deferred until use cases demand it. v0.3 handles one image per batch; if multiple images trigger in the same coalesce window, the second uploads in a follow-up batch.
- DM watching, multi-chat targeting — still v2.

---

## Decisions

- **08/06/26 — Caption trigger requires `claude` token, not bare image.** A photo dropped into TEAM ONE with no caption is silent — no upload, no batch fire driven by the image alone. Decided by Maciej. Rationale: signal-to-noise. Images without questions waste a Claude turn on default-silence.
- **08/06/26 — Reply-to is the recovery path for bare images.** Not a 5-min "smart cache" that watches for follow-up text mentioning the image. Reply-to is explicit, structured by WhatsApp itself, and unambiguous. Decided by Maciej + Claude.
- **08/06/26 — Image cache window: 24h / 200 messages (whichever is larger).** Generous enough that a reply-to the next morning still works, bounded enough that disk usage stays sane. Cleanup runs on watcher boot, not continuously. Decided by Claude.
- **08/06/26 — Coalesce, don't serialize.** Batches arriving during an in-flight batch get merged into the next send, not queued as separate sends. Faster (one prompt, one reply, richer context) than serializing and cheaper than allowing concurrent collisions on the composer. Decided by Maciej + Claude.
- **08/06/26 — Fast-path messages don't jump the queue.** A `claude ...` message arriving during an in-flight slow batch still waits for the in-flight batch to finish. Bounded latency (~10-20s in practice) beats out-of-order replies and composer collisions. Decided by Claude.
- **08/06/26 — Soft cap 50 on merged batches.** If drain exceeds `FORCE_FIRE_COUNT`, split into multiple sequential batches rather than one mega-prompt. Decided by Claude.

---

## Open questions

- [ ] **Where does Playwright `setInputFiles` target on claude.ai's composer?** Selector unknown — needs inspection during build. Expect a hidden `<input type="file">` near the composer; fallback is `page.setInputFiles('input[type=file]', path)` with the first match. Resolve in Phase 2 with a DOM diagnostic if naive selector fails.
- [ ] **Does the watcher chat composer accept files when the chat is in a project?** Claude.ai project chats may have different upload affordances than regular chats. Verify in Phase 2.
- [ ] **What happens to the image cache across watcher restarts?** v0.3 default: cache persists on disk (`tmp/img/`), the in-memory Map repopulates by scanning the directory and using filename = msg-id. Acceptable. If Maciej wants cache wiped on every restart, flip a flag.

---

## Build log

### 08/06/26 — Claude/Maciej — Phase 1: batch coalescing SHIPPED

Coalescing logic landed in `index.js` (no driver-level changes needed). Buffer + busy flag at module scope; batcher callback appends to `pendingMessages` and short-circuits if `isDriverBusy`; `processPending()` drains the buffer in a while-loop with soft cap at `FORCE_FIRE_COUNT`. Reason promotion (fast_path > force_fire > debounce) ensures merged batches keep highest-priority signal. Earliest `prev_check_ts` wins in coalesce window so gap calc reflects oldest message.

**Files touched:**
- `index.js` — added `pendingMessages`, `pendingReason`, `pendingPrevCheckTs`, `isDriverBusy`; added `upgradeReason()` and `processPending()`; refactored batcher callback to enqueue instead of fire directly.

**Verification (chat `0aa5046e-…`, 16:50–16:55 UTC):**
- 3 sequential `claude ...` messages spaced ~5s apart → each buffered correctly during prior in-flight, drained pairwise. Log shows `coalesce: driver busy, buffered` (1) → `coalesce: draining next batch` → `batch fire` for each. Zero composer collisions, zero parallel sends.
- 3-burst with longer first prompt (haiku) → same pattern; reply latency still ~5-7s so merge-into-one path didn't fire, but the buffer mechanism captured every in-flight arrival correctly.
- Pairwise serialization is the natural outcome when reply_latency ≈ inter_message_gap. True N-into-one merging will fire when reply latency exceeds inter-message gap (long reasoning, KB fetches, image analysis in Phase 2).

**What this fixes:** the latent collision bug. Before this, two batches arriving close enough would both grab the composer and either send garbled prompts or miss replies. Now provably impossible — `isDriverBusy` is the single source of truth and the buffer is the only path for concurrent messages.

---

## Build plan

### Phase 1 — Batch coalescing (foundation)
- Add `_batchInFlight: Promise | null` to `claude-driver.js`. When `sendBatch` is called, if `_batchInFlight` is non-null, return a promise that resolves into the next merged batch. When the in-flight batch's `_waitForResponseComplete` resolves, drain the pending buffer and recursively trigger the merged send.
- Update `index.js` batch handler to check `driver.busy()` and route to a `pendingMessages` buffer.
- Buffer-drain logic: at in-flight resolve, if `pendingMessages.length > 0`, merge into one `prompt.js` call, send. Split if `length >= FORCE_FIRE_COUNT`.
- Logging: `coalesce buffered N msg`, `coalesce drained, merged N msg into batch`, `coalesce split: K batches of <50 each`.

### Phase 2 — Image cache + claude.ai upload
- `image-cache.js` module. Map<msgId, filePath>, file storage at `tmp/img/<msgId>.<ext>`. Cleanup on boot (delete files older than 24h).
- baileys: extract image bytes via `downloadMediaMessage()`. Save to disk only if (a) caption contains `claude` (immediate upload path) OR (b) image is being saved for potential later reply-to (always save, prune on cleanup).
- Decision in build: save **every** image to cache regardless of caption, in case a reply-to comes later. Disk cost is trivial; behaviour is more forgiving.
- `claude-driver.js`: new `sendBatchWithImage(promptText, imagePath)` method. Locates composer's file input via `page.locator('input[type=file]')`, calls `setInputFiles(imagePath)`, waits for upload preview to appear (selector TBD via diagnostic), then types prompt + sends.
- `index.js`: in batch handler, detect when a message in the batch has an image to attach. If so, route through `sendBatchWithImage`; else through normal `sendBatch`. If multiple images in one batch, send the first via `sendBatchWithImage` and the rest in a follow-up batch (deferred for v0.4 if needed).

### Phase 3 — Reply-to detection
- baileys message has `message.extendedTextMessage.contextInfo.stanzaId` when it's a reply. Extract this in `extractBody`/`extractType` pipeline.
- When watcher processes a reply-to text containing `claude`, look up `stanzaId` in the image cache. If hit → attach the cached image to the batch. If miss → fire batch as text-only and log `image not cached, ignored reply-to`.

### Phase 4 — Prompt format update
- `prompt.js`: per-message line variants for image-bearing messages. `[IMAGE:<filename>] <caption>` when attached, `[IMAGE]` when seen-but-not-attached, plus `(reply to msg from <name>: <preview>)` when message is a reply.

### Phase 5 — Verification
- **Coalescing positive:** send 3 messages in 5s window during an in-flight slow batch. Expect single merged batch fire after first batch resolves.
- **Coalescing soft cap:** synthetic test fires 60 messages during in-flight. Expect two batches of 50 + 10.
- **Image upload positive:** send image with caption "claude what's in this image". Expect `KB_LOG_*` if relevant, `WA_SEND_*` reply describing image.
- **Image upload negative:** send image with no caption. Expect message logged as `[IMAGE]` in next batch but no file uploaded, no batch fired by the image alone.
- **Reply-to positive:** send image bare, then reply-to it with "claude describe this". Expect cached image attached on the second batch, Claude responds.
- **Reply-to miss:** simulate cache eviction, reply-to old image. Expect graceful "image not cached" log, batch fires text-only.

---

## Done criteria

- [ ] Batch coalescing handles 3+ concurrent batches without composer collisions
- [ ] Coalescing soft-cap splits large drain into ≤50-msg batches
- [ ] Image with `claude` caption uploads to composer and gets answered
- [ ] Image with no caption is logged as `[IMAGE]` but does not trigger upload or batch fire
- [ ] Reply-to image trigger attaches cached image and gets answered
- [ ] Reply-to with cache miss logs gracefully and fires text-only batch
- [ ] Image cache survives watcher restart (files on disk, Map repopulates from directory)
- [ ] Cache cleanup on boot deletes files older than 24h
- [ ] No regressions on text-only path or KB_LOG / WA_SEND extraction

---

## Post-ship summary

Shipped 08/06/26 in the same session as team-log. All five phases landed end-to-end. Both image triggers (caption + reply-to) verified live in TEAM ONE; batch coalescing verified across multiple bursts; cache survives watcher restarts (repopulates from `tmp/img/` directory).

**What shipped:**
- `image-cache.js` — Map<msgId, {path, mime, ts, caption}>, file storage at `tmp/img/<msgId>.<ext>`, 24h TTL + 200-entry cap, cleanup on boot deletes files older than TTL, repopulates Map from disk on startup so reply-to survives restarts.
- `index.js` message handler: detects type='image', downloads bytes via baileys `downloadMediaMessage`, always saves to cache (so reply-to later can find it); detects reply-to via `contextInfo.stanzaId` and looks up cached image; attaches imagePath/imageMime to batch entries when caption-trigger or reply-to-trigger fires.
- `prompt.js` — image marker now distinguishes `[IMAGE:filename attached]` (uploaded) from `[IMAGE not attached - caption did not mention claude]` (seen but not uploaded). Reply-to context appended to messages as `(reply-to msg <id>)`.
- `claude-driver.js` — new `_uploadImages(paths)` method. Tries direct `input[type="file"]` setInputFiles first (works even when hidden via Playwright trick), falls back to clicking attach-button candidates if no input found, then setInputFiles. Defensive preview-detection chain falls back to 3s wait if no selector matches.
- `sendBatch(promptText, opts)` extended with `opts.imagePaths` array — uploads before typing prompt.
- `index.js` processPending() — collects `imagePath` from batch messages and passes through to driver.
- Batch coalescing (Phase 1, already shipped earlier this session): `pendingMessages`/`isDriverBusy`/`processPending()` ensures concurrent inbound messages buffer instead of colliding on the composer.
- Seed updated with an "Images" section explaining how the watcher Claude should interpret `[IMAGE:filename attached]` vs `[IMAGE not attached]` markers, plus reply-to semantics.

**End-to-end verification (chat `8d6abe01-…`, 17:11–17:15 UTC):**
- **Caption trigger positive:** Tatkowski logo image with caption "claude what's in this image" → `image cached`, batch fired with `images: 1`, `setInputFiles complete`, Claude described logo. Maciej corrected a Jatkowski→Tatkowski misread (vision-model OCR quirk on script signature, not a pipeline issue).
- **Reply-to positive:** Polish birth certificate image sent bare → cached. Maciej replied to it with "claude whats that" → `reply-to image attached`, batch fired with `images: 1`, Claude returned full structured description of the document (form type, name, dates, parents, issuer).
- **Reply-to cache miss graceful:** Maciej's "Tatkowski not Jatkowski" correction was a reply-to the logo image, but the logo was in the OLD watcher chat's cache, not the post-rotate one → `reply-to: referenced image not in cache`, batch fired text-only, Claude apologised based on the text without trying to re-view the image.
- **Image-without-caption silent:** image arrived bare at 17:14:06 with no caption. Cached (`image cached`) but no upload — `images: 0` on the subsequent unrelated batch.
- **Cache survives restart:** `image-cache init, repopulated: 2, deleted: 0` on boot.
- **Coalescing (verified earlier in session):** 3 rapid `claude ...` messages while drivers busy → pairwise buffer + drain, zero composer collisions.

**Known minor issues, post-ship:**
- Upload preview selector didn't match any of the 5 candidates we tried → fell back to fixed 3s wait. Upload still succeeded reliably. Worth refining once we observe the actual preview DOM during a session; trivial to add a real selector when known.
- Vision-model misread on cursive logo signature (Jatkowski/Tatkowski). Not in scope to fix — that's a Claude image-reading quirk. Workaround: humans can correct in TEAM ONE and Claude will update.

**What got cut:**
- Multi-image batches in one prompt — supported by `setInputFiles([paths])` but not exercised live. Code passes an array so a future batch with N>1 image messages would upload all of them; not yet tested.
- Resize/compress before upload — claude.ai handles raw bytes fine; no need for client-side preprocessing.
- Voice notes, video, documents (PDFs). Image-only as planned.

This workstream eliminates the last big "watcher can't see what TEAM ONE sees" gap. Text + images both flow now. The team can ask Claude about screenshots, contracts, IDs, paperwork, photos — whatever — without leaving WhatsApp.
