# ROADMAP — WhatsApp ↔ Claude Watcher

**Status:** PHASE 1 COMPLETE — receiver loop working end-to-end (baileys, attribution OK)
**Owner:** Maciej
**Last update:** 08/06/26 by Claude/Maciej

---

## Scope

Local-machine watcher that bridges TEAM ONE WhatsApp group ↔ a rotating claude.ai chat in this project. Watcher detects new inbound messages, batches them with full meta, pipes them into the claude.ai chat as a structured prompt; Claude decides whether to respond and (when yes) sends back to WhatsApp via the existing direct-require send pattern.

**In:**
- Watcher Node process at `D:\tatkowski-whatsapp\watcher\` with its own persisted `whatsapp-web.js` session (separate from Maciej's normal WA Web tab)
- Polling: 1s idle tick, 15s live debounce after last message, force-fire at 50 messages in one burst, fast-path triggers for lone "?" messages and messages starting with `claude` / `claude,`
- Loop guard: `fromMe === true` → skip (Maciej is the only one who texts in TEAM ONE from the Irish business WhatsApp; he reaches the group from his UK number `223630424305904@lid`)
- Per-message prompt format with real-time UTC header, gap-since-last-check, per-message timestamp + named author + raw body; non-text messages marked `[VIDEO]` / `[VOICE]` / `[IMAGE]` / `[DOC]` with no transcription attempt
- Identity map (LID → name) for prompt readability:
  - `226710469509153@lid` → David Briceag
  - `205583089152227@lid` → Magda (Madzia)
  - `223630424305904@lid` → Maciej (UK)
  - Anything else → `Unknown (<lid>)`
- Chrome MCP driver: paste the prompt into the claude.ai composer in the target watcher chat, click send, wait for response complete, fire any Claude-generated reply back to WhatsApp via the standing direct-require pattern at `D:\tatkowski-whatsapp\bridge\quick-send.js`
- Weekly-rotating watcher chat in this project, named `[OPS] – TEAM ONE Watcher – week-of-DD-MM-YY`, rotated Monday 00:00 local (IE/PT TZ). Continuity across rotations via KB + past-chats search.
- Stop / resume signals from Maciej's UK number in TEAM ONE: `WATCHER:STOP` pauses, `WATCHER:GO` resumes
- State at `state.json`: `last_seen_ts`, `active_flag`, `current_watcher_chat_url`
- Full audit at `watcher.log`: every inbound batch, outbound prompt, Claude decision (responded / silent), any reply sent back to WhatsApp
- Model: `claude-opus-4-7`, medium reasoning. Default-to-silence judgement set in the watcher chat's system context (see "Response judgement" below)
- Budget warning: log line if 24h estimated spend exceeds $5 (sanity check, not a hard cap)

**Out (v1):**
- Direct-message watching (David DM, Magda DM) — TEAM ONE only for v1; expand after judgement threshold is proven
- Voice/video transcription
- Cross-group routing (each Claude reply goes to the same chat the inbound message came from)
- Auto-rotation of weekly chat (manual handoff in v1; auto-rotation can land in v2)
- Mobile / non-desktop operation (watcher runs only when Maciej's laptop is on and connected)

---

## Decisions

- **08/06/26 — Architecture locked.** Headless watcher is the wrong shape because it would be a separate Claude with no access to live chat history. Driving a claude.ai tab via Chrome MCP keeps the same Claude (this project, this memory, all tools — past-chat search, email read, KB read/write, web search) in the loop. Watcher is plumbing; Claude does the deciding.
- **08/06/26 — Adaptive polling locked.** Idle 1s tick (local cost is free), live debounce 15s for organic conversation, force-fire at 50 messages in one burst, fast-path triggers for explicit "claude" prefix and lone questions. Trade-off: 15s felt latency on one-off questions is acceptable because the trigger word fast-path bypasses it.
- **08/06/26 — Scope limited to TEAM ONE for v1.** DM watching deferred to v2 after the judgement threshold proves itself in the lower-stakes group context.
- **08/06/26 — Model: Opus 4.7 medium reasoning.** Sonnet would work but Opus handles the judgement edges (silence vs respond, tone calibration, pulling from KB) more reliably. Cost stays trivial on pure-text — estimated $5–15/week even on chatty weeks.

---

## Open questions

- [ ] **Chrome MCP composer driver — selector resilience.** The DOM-level paste-and-send for claude.ai is fragile across UI updates. Need defensive code: retry on selector miss, fall back to keyboard-shortcut send, log every send attempt. Resolve during build by writing a `chrome-driver.js` with explicit selector strategies and a test mode.
- [ ] **Auto-rotation of weekly chat.** v1 = manual handoff Monday morning. v2 = watcher detects rotation date, opens new chat via `tabs_create_mcp`, posts a continuity header, updates `state.json`. Land later.
- [ ] **Handling Claude's own outbound replies in the next poll.** When Claude sends via the bridge, `fromMe` flips to `true` on the next read, so the loop guard already filters it out — but verify this end-to-end during build, not in spec.

---

## Build plan

### Phase 1 — WhatsApp side
1. `whatsapp-web.js` standalone session at `wa-session/`. QR-scan once. Verify session persists across restarts.
2. Identity map + LID → name resolver.
3. Listener using `MsgCollection.on('add', ...)` equivalent (whatsapp-web.js's `message` event) for TEAM ONE only.
4. Debounce + force-fire + fast-path logic. Unit test with synthetic message streams.
5. State persistence to `state.json`.

### Phase 2 — Chrome driver
1. `chrome-driver.js` — find the active claude.ai watcher tab via `tabs_context_mcp`, paste prompt into composer, click send, wait for response.
2. Wait-for-response strategy: poll the message DOM for the "stop generating" button to disappear AND the last assistant message to stabilise for 2s.
3. Extract Claude's response text from the DOM (if Claude decided to respond with a WhatsApp message, the watcher needs to forward it).
4. Defensive selectors + retry + fallback to keyboard shortcut.

### Phase 3 — Routing + system prompt
1. The watcher chat's first message sets the system context for Claude: identity, rules, default-to-silence, when-to-respond criteria, the standing direct-require send pattern.
2. Watcher injects the structured prompt format (UTC header + per-message meta).
3. Claude decides → either replies inline in the watcher chat (silence noted) or generates a message body wrapped in a `WA_SEND:` directive that the watcher extracts and forwards to TEAM ONE via the direct-require pattern.

### Phase 4 — Controls + observability
1. Stop / resume signals (`WATCHER:STOP` / `WATCHER:GO` from Maciej's UK number).
2. `watcher.log` full audit trail with rotation.
3. Budget warning when 24h estimated spend exceeds $5.
4. Health check: every hour, log heartbeat + last-seen-message-ts.

---

## Response judgement (lives in the watcher chat's system context)

The watcher chat's system prompt sets a high bar so cost and noise stay low:

**Default: silence.** Log the burst, do nothing.

**Respond when:**
- Direct question to Claude (explicit prefix or unambiguous "@Claude / claude ..." phrasing)
- Concrete next-step where Claude can remove friction (e.g. "I'll look for immigration lawyers" → bridge to "open your Claude and say 'Lisbon batch 1'")
- Factual gap Claude can fill from KB (pricing, process, identity, history)
- Frustration that warrants reframing toward the playbook (rare, judgement call)

**Don't respond to:**
- Agreement-bursts ("yes bro", "true true", "let's go")
- Internal team banter or venting unrelated to the operation
- Anything where adding a third voice would feel like over-engagement
- Anything Maciej is already actively responding to in real time — Claude defers

---

## Done criteria (v1)

- [ ] Watcher runs unattended for 48 hours without crashing or losing session
- [ ] At least 5 real-world response decisions logged, with retrospective check that the judgement was right (Maciej reviews log)
- [ ] Stop / resume signals confirmed working
- [ ] Weekly chat rotation tested at least once (manual handoff)
- [ ] Budget warning fires on a forced-busy day
- [ ] No instances of Claude responding to its own messages

---

## Post-ship summary

[To be filled when v1 ships.]

---

## Phase 1 build log — 08/06/26

Scaffold at `D:\tatkowski-whatsapp\watcher\` (whatsapp-web.js 1.34.7, qrcode-terminal):
- `config.js` — paths, identity map, TEAM_ONE_ID, MACIEJ_UK_LID, timing constants
- `logger.js` — JSON-line append-only to `watcher.log` + console mirror
- `state.js` — load/save `state.json` (last_seen_ts, active_flag, current_watcher_chat_url)
- `identity.js` — LID → name resolver per spec
- `batcher.js` — debounce / force-fire-at-50 / fast-path triggers (`claude` / `claude,` prefix + lone `?`). Unit tests 12/12 pass via `test-batcher.js`
- `prompt.js` — structured prompt builder: UTC header, fire reason, gap-since-last-check, per-msg `[stamp] Name: body` lines with `[VIDEO]/[VOICE]/[IMAGE]/[DOC]` markers, no transcription attempt
- `index.js` — `Client` with `LocalAuth({ dataPath: wa-session/ })`, headless puppeteer, TEAM ONE filter, `fromMe` loop guard, `WATCHER:STOP`/`WATCHER:GO` from Maciej UK LID only, heartbeat (1h), graceful SIGINT/SIGTERM with batcher flush

Phase 1 deviation from spec: the roadmap mentions "1s idle tick" — whatsapp-web.js is event-driven, so no polling loop needed. The semantic outcome (fire on inbound activity) is preserved via the `message` event handler. Heartbeat covers liveness.

Phase 1 NOT YET DONE:
- QR scan (must be done by Maciej in a foreground terminal — DC can't drive interactive QR display): `cd D:\tatkowski-whatsapp\watcher; node index.js`. Scan once with WhatsApp → Linked Devices. Session persists under `wa-session/`. Kill with Ctrl+C, restart, verify no QR re-prompt.
- 48h unattended run

Phase 2 (Chrome driver) and Phase 3 (routing + system prompt) not started.

---

## Phase 1 v0.2 build log — 08/06/26 (baileys pivot)

**whatsapp-web.js abandoned.** First boot reached `ready` after ~5min sync, every subsequent boot stalled at `authenticated` indefinitely. Verified not a process/zombie/conflict issue. Library injects scripts into WA Web and waits for internal WhatsApp objects to appear; WA's web app changes break this regularly. Wrong tool for unattended operation. Removed.

**Pivoted to `@whiskeysockets/baileys@6.7.16`.** Direct WebSocket protocol — no puppeteer, no Chromium, no WA Web modals. Install 91 packages in 13s vs 195 packages + Chromium in 50s. `client ready` in ~10–20s reliably.

**Files changed:**
- `package.json` — swapped deps
- `index.js` — full rewrite around `makeWASocket`, `useMultiFileAuthState`, `messages.upsert`, auto-reconnect on non-loggedOut closes
- `config.js` — added `MACIEJ_UK_PN: 447752154028@s.whatsapp.net` (phone-number form); identity map covers both LID and PN
- `batcher.js`, `prompt.js`, `state.js`, `identity.js`, `logger.js`, `test-batcher.js` — unchanged. 12/12 tests still pass.

**Diagnostic detours that wasted time:**
- Suspected zombie node processes — wasn't it
- Suspected pinned-WA-Web-tab conflict — wasn't it
- Suspected Advanced Chat Privacy on TEAM ONE — wasn't it (left toggled off anyway, no functional reason to keep it on for a team group)

**Actual attribution bug:** baileys emits two events per inbound LID-group message:
1. Encrypted variant with full attribution on `msg.key.participant` + `msg.key.participantPn`, but `decrypt fails` ("No session found to decrypt message"). Filtered out as `type==='unknown' && !body`.
2. Body-bearing variant arrives ~5–10s later with `msg.key.participant === undefined`, but **attribution sits on `msg.participant`** (top-level, not under `.key`). Fixed extraction to fall through `msg.key.participant || msg.participant || msg.key.participantPn`.

After fix: `Maciej (UK): lol elo elo 320` arrives clean. Verified end-to-end.

**Known leftover noise (non-blocking, defer):**
- Baileys decryption-fail errors printed to console (level 50) on every inbound — pino logger at `warn` level surfaces them; can silence by passing a stricter logger or filtering pino transport. Cosmetic.
- `executeInitQueries Timed Out` warning on connect — group metadata init handshake doesn't always complete. Doesn't affect message delivery. Investigate if it ever blocks anything in Phase 2.
- 1s idle tick from spec not implemented — baileys is event-driven, no polling needed.

**Phase 1 NOT YET DONE:**
- 48h unattended-run stability test
- Stop / resume signals (`WATCHER:STOP` / `WATCHER:GO`) end-to-end test
- Log file rotation
- Budget warning

**Phase 2 (Chrome driver) and Phase 3 (routing + system prompt) not started.**
