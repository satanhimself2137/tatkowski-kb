# ROADMAP — wa-watcher v0.4 (document I/O — PDFs in, generated files out)

**Status:** IN PROGRESS — Phase 0 (scope locked)
**Owner:** Maciej
**Last update:** 08/06/26 by Claude/Maciej

---

## Scope

Two complementary extensions to the v0.3 image pipeline. Inbound document support (PDFs/docx/any file) using the same caption-and-reply-to triggers that work for images. Outbound: when the watcher Claude generates a file (PDF translation draft, docx report, xlsx sheet — anything from its file-creation skills), the watcher detects it, downloads the file from the claude.ai UI, and relays it to TEAM ONE via baileys' native document-send.

**In:**
- **Inbound documents.** baileys `documentMessage` → cached to `tmp/doc/<msgId>.<ext>` with the same lifecycle as images (24h TTL, 200-entry cap, repopulate from disk on boot). Trigger rules identical to images: caption containing `claude` → attach to the immediate batch; reply-to text mentioning `claude` → look up cached doc, attach to that batch.
- **Cache split.** Separate `ImageCache` and `DocCache` directories so cleanup and eviction can have different policies if needed later. Both share the same class shape.
- **`setInputFiles` accepts any path.** No code change in `_uploadImages` needed — Playwright handles arbitrary mime types. Method rename to `_uploadFiles` for clarity.
- **Outbound file detection.** After every batch reply, scan the latest assistant turn for file-presentation widgets (claude.ai renders these as file pills with a Download button or `<a download>` link). For each detected file, trigger Playwright `page.waitForEvent('download')` + click → save to `tmp/out/<timestamp>-<filename>`.
- **Outbound delivery.** New `WAWebDriver.sendDocument(chatId, filePath, mimetype, filename)` method using baileys `sock.sendMessage(jid, { document: Buffer, mimetype, fileName })`. Caption optional — defaults to nothing (the WA_SEND text reply already provides context).
- **Auto-relay, not marker-gated.** If watcher Claude produces a file, the watcher sends it back to TEAM ONE automatically. No `WA_FILE_*` marker required. Rationale: Claude's file-creation skills only fire when explicitly asked; the file IS the answer. Adding a marker requires the model to remember an extra rule for no real benefit. The discipline is at the prompt level (don't produce files unless asked), not at the marker level.
- **Order of operations per batch.** Reply complete → extract WA_SEND blocks → extract KB_LOG blocks → detect generated files → send WA_SEND messages first → send each detected file with the next baileys call → POST KB_LOG entries last. So the text reply lands first ("here's your draft translation"), then the file, in the order TEAM ONE expects.

**Out:**
- Sending non-Claude-generated files (e.g. random uploads from disk). Outbound is strictly "what Claude produced in this reply." Anything else goes through the proper SalesManager / Drawer pipeline.
- File-format-specific transforms (compression, re-encoding, format conversion). Whatever Claude generates ships as-is.
- Voice notes, video. Document/image only.
- Multi-recipient routing (always TEAM ONE for v0.4).

---

## Decisions

- **08/06/26 — Auto-relay generated files, no explicit marker.** When Claude produces a file, send it. The presence of the file is the trigger. Adding `WA_FILE_*` blocks would be ceremony with no signal-to-noise gain. Decided by Maciej + Claude.
- **08/06/26 — Documents reuse the image cache pattern, not a unified blob cache.** Two parallel classes (`ImageCache`, `DocCache`) sharing a base shape, separate directories. Future-proofs different TTLs and eviction strategies if usage diverges (e.g. PDFs are big, may want shorter retention). Decided by Claude.
- **08/06/26 — Auto-send order: WA_SEND text first, then file, then KB_LOG.** Mirrors TEAM ONE's expectations — text context arrives, then the deliverable. KB_LOG is invisible to the team so order doesn't matter, but committing it last means the commit log records the artefact only after delivery confirmed. Decided by Claude.
- **08/06/26 — Use Playwright `waitForEvent('download')` for capture, not URL scraping.** Browser-level event captures everything that triggers a download, regardless of UI implementation (button vs link vs blob URL). More resilient to claude.ai UI changes than parsing specific DOM elements. Decided by Claude.

---

## Open questions

- [ ] **Claude.ai file presentation DOM — what does the file pill actually look like?** Need diagnostic during build (similar to attach-button diagnostic in v0.3). Working hypothesis: a file-card element with a download button. If it's a blob-URL pattern, click triggers download natively; if it's an HTTP download link, also fine. The `waitForEvent('download')` approach is selector-agnostic but we still need to know WHAT to click.
- [ ] **What if a reply contains a code block but no actual file?** Code blocks render inline, never trigger a download — so the file-detection should naturally skip them. Verify in Phase 2.
- [ ] **File size limits.** WhatsApp document limit is ~100MB per file. Claude.ai file outputs are typically small (<10MB for translation drafts). Add a size check before send; if over limit, log + skip with a WA_SEND warning to the team.
- [ ] **Multiple files in one reply?** If Claude produces 3 files in one response, send all 3 (sequential `sendMessage` calls). Order = order they appear in the reply DOM.

---

## Build plan

### Phase 1 — Doc cache + inbound PDFs
- Create `doc-cache.js` mirroring `image-cache.js` (separate `tmp/doc/` directory, same Map/save/get pattern).
- `index.js` message handler: detect `type === 'document'`, download via `downloadMediaMessage`, cache. Track separately from images.
- Reply-to / caption trigger logic extended: image cache OR doc cache lookup. Whichever finds the referenced msgId wins.
- `prompt.js`: render `[DOC:filename attached]` vs `[DOC not attached - caption did not mention claude]`.

### Phase 2 — Outbound file detection from claude.ai reply
- `claude-driver.js`: new method `_extractGeneratedFiles()` called inside `_waitForResponseComplete` after the reply settles.
  - Scope to the last assistant message container only (avoid picking up old files from earlier in the chat).
  - Find file-pill elements (selector chain TBD via diagnostic): try `a[download]`, `button[aria-label*="download" i]`, `[data-testid*="file" i]`.
  - For each, set up `page.waitForEvent('download')` and click. Save downloaded file via `download.saveAs(targetPath)`.
  - Return array of `{path, mimetype, filename}`.
- Log every detected file. Diagnostic dump on miss.

### Phase 3 — baileys document send
- `wa-web-driver.js` is for sends-via-WA-Web. baileys document send works on the baileys `sock` directly, not through WA Web. Add `sendDocument` to a new module or directly on the baileys sock reference in index.js.
- Path: `sock.sendMessage(cfg.TEAM_ONE_ID, { document: fs.readFileSync(path), mimetype, fileName: name })`.
- This bypasses WA Web (cleaner, faster) — same pattern baileys uses for any media.

### Phase 4 — Wire it into the batch pipeline
- `index.js` `processPending()`: after reply received, get sends + logs + **files** from driver. Send WA_SEND text, then each file via baileys, then KB_LOG.
- Log: `outbound file detected`, `outbound file sent { chars: bytes, mime, filename }`.

### Phase 5 — Seed update
- Add section explaining: "When you generate a file (PDF, docx, xlsx, etc.) using your skills, the watcher will automatically relay it to TEAM ONE alongside your WA_SEND text. Use this for translation drafts (for review, not certified delivery), summaries, exports. Don't apologise about producing files — just produce them when asked."
- Reinforce: "Files you create are drafts for human review unless the request explicitly maps to a real product workflow. Maciej knows the difference; don't gatekeep."

### Phase 6 — Verification
- **PDF input positive:** send a PDF with caption "claude what's in this document". Expect upload + Claude reads it + WA_SEND reply.
- **Reply-to PDF positive:** send a PDF bare, then reply-to with "claude summarise". Expect cached doc attached, reply returned.
- **Outbound file positive:** "claude translate this short Ukrainian text into English and put it in a docx". Expect WA_SEND text + docx file delivered to TEAM ONE.
- **Outbound file size guard:** synthetic — manually attempt to generate >100MB. Expect graceful warn + skip.
- **Mixed reply:** "claude write me a short translation note and put it in a pdf". Expect WA_SEND text first, then PDF, then any KB_LOG.

---

## Done criteria

- [ ] PDF with `claude` caption uploads to composer and gets answered
- [ ] PDF reply-to trigger works (same as image reply-to)
- [ ] Doc cache survives watcher restart, files repopulate
- [ ] Generated files from claude.ai detected in latest assistant turn
- [ ] Detected files downloaded to local disk via Playwright
- [ ] Detected files sent to TEAM ONE via baileys
- [ ] Order: WA_SEND → file → KB_LOG, verified in log
- [ ] Multiple files in one reply all sent (when relevant)
- [ ] Oversized file (>100MB) logged + skipped + team warned
- [ ] No regression on text-only or image-only paths

---

## Post-ship summary

[To be filled when Status = SHIPPED.]
