# ROADMAP — WhatsApp ↔ Claude Watcher

**Status:** PHASE 2 v0.2 SHIPPED — seed hardened (anti-sycophancy + audience awareness + natural-language override), ops UX shipped (PID-file launchers, window hiding via Win32), WA_SEND round-trip verified in production
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

---

## Phase 2 v0.1 build log — 08/06/26 (playwright + auto-bootstrap)

**Architecture pivot:** Original spec called this a "Chrome MCP driver" — that's wrong. Chrome MCP is the user's Claude session's tool, not the watcher's. A 24/7 unattended watcher must drive its own browser. Replaced with **playwright** running its own persistent Chromium profile under `D:\tatkowski-whatsapp\watcher\claude-session\`.

**Files added:**
- `seed.md` — priming message pasted into every new watcher chat. Sets role, default-to-silence rules, when-to-respond criteria, `WA_SEND_START / WA_SEND_END` delimiter format, memory rule (do NOT write memory from watcher batches), WhatsApp tone reminder.
- `claude-driver.js` — playwright wrapper. Methods: `init()`, `ensureLoggedIn()`, `ensureWatcherChat()`, `createNewWatcherChat()`, `sendBatch()`, `extractWaSends()`, `close()`. Persistent context so login survives restart. Currently `headless: false` for visibility during v0.1 iteration; flip to headless once stable.

**Files changed:**
- `package.json` — added `playwright ^1.x`.
- `config.js` — added `PROJECT_URL`, `CLAUDE_SESSION_DIR`, `SEED_PATH`. Slash-command constants `CTRL_PREFIX='/'`, `CTRL_STOP='/watcher stop'`, `CTRL_GO='/watcher go'`, `CTRL_STATUS='/watcher status'`.
- `index.js` — wires `ClaudeDriver` into the lifecycle. Shared state ref passed to driver (was a divergence bug that surfaced on first run — driver mutated its own copy, index didn't see URL updates). Batches queue on a `driverReadyPromise` instead of dropping when driver still booting. Slash-command dispatch: `/watcher stop|go|status|chat <url>|rotate`. Sends `WA_SEND_*` blocks back to TEAM ONE via `sock.sendMessage(cfg.TEAM_ONE_ID, { text })`.

**End-to-end verified:**
- baileys ready in ~3s
- playwright launches Chromium, claude.ai session detected (login skipped on persistent profile)
- watcher navigates to project URL, finds composer, pastes seed, waits for `/chat/<uuid>` URL change
- chat URL persisted to `state.json`
- fast-path trigger `claude test ping` arrived, was paste into watcher chat, reply read (selector `data-test-render-count` matched, 135 chars), Claude correctly chose silence per seed rules
- driver remains live across batches; subsequent batches reuse the same chat

**Slash commands (Maciej UK only):**
- `/watcher stop` — pause
- `/watcher go` — resume
- `/watcher status` — log current state (active flag, last seen, buffer size, chat URL)
- `/watcher chat <https://claude.ai/chat/...>` — bind to an existing chat manually
- `/watcher rotate` — clear bound chat URL, force new chat on next batch

**Account-switch gotcha:** First run picked Maciej's free Google sub-account instead of his Max account. Persistent context now remembers the Max selection after one manual switch. If watcher logs ever show "could not find new-chat composer on project page", account drift is the first thing to check.

**Diagnostic detours:**
- Initial `_readLastAssistantText` returned 0 chars — selector list too narrow. Broadened to six candidates with per-match logging. `data-test-render-count` is the current winner for claude.ai.
- `_renameCurrentChat` v1 was broken: `getByRole('heading').first()` matched something outside the chat title (probably content), keyboard.type fell through into the composer, the new name got sent as a chat message. Disabled in v0.1. Replaced with a `_diagnoseHeader()` call that dumps every clickable element in `<header>` so v0.2 can write a precise selector.

**Phase 2 NOT YET DONE (deferred to v0.2):**
- Proper chat-title rename (currently logs `MANUAL RENAME NEEDED` + header DOM diagnostic; user renames in claude.ai sidebar manually)
- Weekly auto-rotation (Monday 00:00 IE/PT) — `/watcher rotate` works manually
- Headless mode (currently `headless: false` for visual debugging)
- `WA_SEND_*` round-trip not yet verified with a real outbound reply — seed correctly biases toward silence, need a clear "respond" prompt to confirm the forward path

**Confirmed still pending from Phase 1:**
- 48h unattended-run stability
- Pino `level: 50` decryption-fail spam (cosmetic)
- Log rotation
- Budget warning

**Phase 3 (routing semantics — judgement quality, multi-chat-targeting, DM watching) not started.**


---

## Phase 2 v0.2 build log — 08/06/26 (seed hardening + ops UX)

**Trigger:** in production use, Claude exhibited two failure modes in TEAM ONE:

1. **Sycophancy under contentless pushback.** Maciej asked "Claude why is it important to keep this capability secret" — Claude gave a strong 5-reason answer (competitive edge, client trust, contractor comfort, leverage, rule of thumb). Maciej replied "or maybe it isn't" — Claude flipped with "fair pushback, honest counter:" and gave the opposite answer with no new fact justifying the reversal. Pure social capitulation.
2. **Group-context blindness.** Asked "biggest competitive risk in PT right now", Claude correctly identified two risks but named David Briceag (Regional Manager PT/ES, present in TEAM ONE) as a SPOF in front of him. Factually correct, socially wrong.

### Seed.md patches

Three new sections added to `seed.md` (after existing "Don't respond to" block):

**1. "Holding a position across speakers".** Group chat = positions are on the record across Maciej, David, Magda. Rules:
- Pushback with new fact/argument → engage, update if it changes the picture, explain *what* changed and *why*
- Pushback with no substance ("hmm", "or maybe not", "really?") → hold, ask what specifically they disagree with
- Honest re-examination revealing weakness → say so, name the weakness, give the better answer (calibration, not sycophancy)
- The forbidden mode: "fair pushback" + flip with no reason

**2. "Who's in the room".** Default behaviour for questions that would name a teammate critically:
- Reframe to structural ("solo regional coverage is a SPOF at this stage" not "David is the SPOF")
- Or split: operational part in TEAM ONE, sensitive part declined with "ping me in your normal Claude, Maciej"
- Don't sanitise to uselessness — keep the substance, change the framing

**3. "Say it straight" override.** Natural-language unlock, not a codeword. Triggers on phrases like:
- "be straight", "say it how it is", "real talk", "no sugar coating", "honestly", "blunt", "don't reframe", "actually say it"

Available to anyone in TEAM ONE. If David or Magda use it on themselves, answer them directly. If Maciej uses it about David or Magda, answer directly (he has the standing). Require the language — don't infer from context.

### Production verification

After re-seed, sent in TEAM ONE: "claude what's our biggest competitive risk in PT right now". Reply (chat `22b54951-…`) covered cert-format acceptance and David-as-SPOF. Counter-pushback "hmm not sure about that" yielded:

> "which part — the certification angle or david as SPOF? 'not sure' doesn't tell me what to re-examine. if you've got a read I'm missing on the PT format acceptance question I want it, otherwise I'm holding."

Anti-sycophancy patch working. The audience-awareness patch landed in chat `ca3d5c74-…` after the David-SPOF mistake; verification of reframing behaviour deferred to next test cycle.

### Ops UX

**Slash-command aliasing.** `/watcher start` and `/watcher resume` now alias to `/watcher go` in `index.js` (originally only `/watcher go` per spec, but `/watcher start` was the natural muscle-memory typo and previously hit `CTRL unknown`).

**PID-file launchers.** Background-process management was opaque — Maciej couldn't easily find or stop the watcher. Two new scripts:

- `start-watcher.ps1` — spawns node with stdout/stderr redirected to `stdout.log`/`stderr.log`, writes PID to `watcher.pid`, then polls for the two playwright-Chromium windows and hides them via Win32 `ShowWindow(SW_HIDE)` as they appear (deadline 45s, exits early after both found)
- `stop-watcher.ps1` — reads `watcher.pid`, `Stop-Process -Force`, removes PID file, verifies dead

**Window hiding.** Two Chromium windows (claude-driver + wa-web-driver) were sitting on Maciej's taskbar. `headless: true` rejected as risk vector — both sessions just stabilised under `headless: false` and headless mode triggers re-login prompts on both claude.ai and WA Web. Win32 `ShowWindow(hWnd, SW_HIDE)` via PowerShell P/Invoke removes the windows from the taskbar entirely without changing playwright config; sessions remain identical to verified-working state.

Two helpers:
- `hide-windows.ps1` — hides all chrome.exe processes whose path matches `*ms-playwright*` (scopes to playwright's bundled Chromium, leaves Maciej's normal Chrome alone)
- `show-windows.ps1` — restores them with `SW_SHOWNORMAL=1` for debugging

`start-watcher.ps1` calls hide inline via the same P/Invoke so a clean boot leaves nothing on the taskbar.

### Bugs surfaced and fixed during the pass

- **`active_flag: false` persisted across restart.** Prior session used `/watcher stop`; state.json kept `active_flag: false`; subsequent reboots logged every inbound as "msg dropped (paused)". Fixed manually by editing state.json; the alias for `/watcher start` prevents future recurrence.
- **Chromium profile lock collisions.** Multiple node processes spawning during recovery attempts each tried `launchPersistentContext` on the same `claude-session/` dir → "Opening in existing browser session" errors and `code 440` baileys session-conflict closes. Resolved by killing all watcher node processes before restart. PID-file launcher now makes this trackable.

### Open from prior phases (unchanged)

- Proper chat-title rename (still falls back to `MANUAL RENAME NEEDED` log + header DOM diagnostic dump; selector `button[aria*="rename chat"]` looks tractable from the diagnostic, deferred to v0.3)
- Weekly auto-rotation Monday 00:00 IE/PT (manual `/watcher rotate` works)
- 48h unattended-run stability
- Pino `level: 50` decryption-fail console spam
- Log rotation
- Budget warning


---

## Phase 2 v0.2 addendum — 08/06/26 (dashboard + live KB read)

Two additions shipped after the initial v0.2 commit, same session.

### Dashboard GUI

Small PowerShell + WinForms control panel at `D:\tatkowski-whatsapp\watcher\watcher-dashboard.ps1`. Buttons: Start, Stop, Show windows, Hide windows, Tail log (opens streaming log in a new console window), Open watcher chat (routes via `rundll32 url.dll,FileProtocolHandler` so it hits the system default browser, not the running Chromium), Refresh status. Status panel auto-refreshes every 5s and shows: watcher PID + alive/dead, active/PAUSED flag, last-seen-message timestamp, current chat URL tail, count of playwright-chromium processes.

Companion files:
- `watcher-dashboard.vbs` — silent launcher via `wscript` so no PowerShell console flashes (passes `-Sta` for WinForms threading)
- `install-shortcut.ps1` — one-shot Start Menu shortcut installer (Win → "Tatkowski" → right-click → Pin to taskbar)
- `kill-dashboard.ps1` — kills any running dashboard PS process (used during the wait-bug fix)

### Bugs surfaced and fixed during the dashboard build

- **Em-dash encoding.** Strings with `—` got mangled to `?` sequences on write through DC's cp1252-default path, breaking PowerShell parse. Rewrote all dashboard strings ASCII-only.
- **UI hang on `-Wait`.** First version used `Start-Process ... -Wait` inside button click handlers, which blocked the WinForms UI thread until the called script returned. Form locked up after the first click. Fixed by switching to fire-and-forget `Start-Process` (no `-Wait`) and scheduling a one-shot `Timer` for the post-action status refresh (30s after Start, 3s after Stop).
- **Off-screen window restore.** The `--window-position=-32000,-32000` Chromium launch arg added as defence-in-depth alongside `SW_HIDE` meant `SW_SHOWNORMAL` on restore only flipped the visibility flag — window remained at -32000,-32000 (invisible). Removed the arg from `claude-driver.js`, and bulletproofed `show-windows.ps1` with `SetWindowPos` to (100,100) + (160,160) on restore so the window is always brought back into view regardless of launch position.
- **about:blank tab proliferation.** While the dashboard was hung, clicks queued on "Open watcher chat" each fired `Start-Process <url>` after un-hang, which Windows routed to the running playwright Chromium → new about:blank tabs. Rerouted to `rundll32` system-default-browser path; the existing Chromium is now never the URL target.

### Live KB read via web_fetch

The watcher Claude now has a documented path to read fresh KB content directly from GitHub raw URLs, without waiting for project content sync to re-index:

```
https://raw.githubusercontent.com/satanhimself2137/tatkowski-kb/main/<path>
```

Seed updated with the pattern + worked examples (main KB, roadmap INDEX, specific workstream files, magda playbook, todos). Strategy clause added: prefer `project_knowledge_search` for fuzzy semantic queries; use `web_fetch` on raw URL for verbatim current contents (especially right after a known commit). KB write remains handoff-only — desktop Claude owns `kb.ps1`/`gh api`.

End-to-end verified: watcher fetched commit `8da912d9` (this file, pre-addendum) immediately after the seed update and read back the Phase 2 v0.2 build log accurately.

### Watcher chat URLs from this session

For continuity if past-chat-search needs them later:
- `e5a3827e-…` — pre-anti-sycophancy patch, where Claude folded on "or maybe it isn't"
- `22b54951-…` — first patched chat, anti-sycophancy verified, audience-awareness mistake (David as SPOF in TEAM ONE) surfaced
- `ca3d5c74-…` — first audience-aware chat
- `d5481790-…` — interim, replaced after toolkit seed correction
- `f181ec96-…` — toolkit-corrected, no-GitHub-MCP framing
- `86d46f6a-…` — current, includes live KB raw-read pattern

### Open items unchanged

- Proper chat-title rename (header DOM diagnostic has the selector candidate `button[aria*="rename chat"]` — tractable for v0.3)
- Weekly auto-rotation Monday 00:00 IE/PT (manual `/watcher rotate` works)
- 48h unattended-run stability
- Pino `level: 50` decryption-fail console spam
- Log rotation
- Budget warning


---

## Phase 2 v0.2 addendum 2 — 08/06/26 (Cloudflare Worker KB proxy + auth)

Replaces the raw.githubusercontent.com KB-read pattern. Worker fronts the KB with a shared-secret auth gate and authenticated upstream fetches.

### What shipped

- **Worker code at** `D:\tatkowski-whatsapp\worker\` (TypeScript, deployed via `wrangler deploy` as Worker `kb`)
  - `wrangler.toml` — `name = "kb"`, vars `GITHUB_OWNER`, `GITHUB_REPO`, `DEFAULT_REF=main`
  - `src/index.ts` — auth check (`?key=…` or `Authorization: Bearer …`) → GitHub Contents API call with `Accept: application/vnd.github.raw` + `Authorization: Bearer <GITHUB_TOKEN>` → up to 3 retries on 5xx/429 with 250/500/750ms backoff
  - `package.json`, `tsconfig.json`, `.gitignore` — wrangler 4.x + @cloudflare/workers-types
- **Secrets on the Worker** (set via `wrangler secret put`, never in repo):
  - `GITHUB_TOKEN` — classic PAT, `repo` scope. Lifts upstream limit from 60/hr to 5000/hr and future-proofs flipping the KB repo private.
  - `ACCESS_KEY` — `tat-kb-9472`. Shared secret required on every inbound request.
- **Routes:** existing `kb.tatkowski.com` route + 1 other route, preserved across redeploy.

### URL shape

- Raw file: `https://kb.tatkowski.com/kb/<path>?key=tat-kb-9472`
- Health: `https://kb.tatkowski.com/health` (no auth)
- Alt auth: `Authorization: Bearer tat-kb-9472` header instead of `?key=`
- Optional `&ref=<branch-or-sha>` to read a non-main ref

### Verification

- `/health` → 200 `ok`
- `/kb/README.md` without key → 401 `unauthorized`
- `/kb/README.md?key=tat-kb-9472` → 200, README content matches main
- `/kb/README.md` with `Authorization: Bearer tat-kb-9472` → 200, same content
- Bad key (`Bearer ghp_…` accidentally pasted) → 401, confirming key-vs-PAT separation works

### Seed updated

`D:\tatkowski-whatsapp\watcher\seed.md` patched:
- All KB URLs swapped from `raw.githubusercontent.com/satanhimself2137/tatkowski-kb/main/<path>` to `https://kb.tatkowski.com/kb/<path>?key=tat-kb-9472`
- Auth-required line added; 404/401 fallback rule explicit (401 = fix URL, don't fall back to memory)

### Operational implications

- Rate limit no longer 60/hr anonymous; 5000/hr authenticated via the Worker's PAT
- If/when the KB repo flips private, only the Worker secret needs swapping — no client-side change
- One PAT was leaked to chat during setup (visible in conversation logs) and rotated immediately; new PAT installed via `wrangler secret put GITHUB_TOKEN`

### Open from prior phases (unchanged)

- Proper chat-title rename (header DOM diagnostic has selector candidate `button[aria*="rename chat"]`)
- Weekly auto-rotation Monday 00:00 IE/PT (manual `/watcher rotate` works)
- 48h unattended-run stability
- Pino `level: 50` decryption-fail console spam
- Log rotation
- Budget warning
