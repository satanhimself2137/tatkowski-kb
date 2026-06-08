# ROADMAP — WhatsApp ↔ Claude Watcher

**Status:** NOT STARTED — spec locked 08/06/26
**Owner:** Maciej (build in next dedicated session)
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
