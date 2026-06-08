# ROADMAP — team-log (decisions + ideas KB writes from watcher)

**Status:** IN PROGRESS — Phase 0 (scope locked)
**Owner:** Maciej
**Last update:** 08/06/26 by Claude/Maciej

---

## Scope

Watcher Claude writes durable artefacts (decisions and ideas) back to the KB via the existing `kb.tatkowski.com` Worker, so the team builds an accountability record and stops repeating decisions across rotated weekly chats. Reads of past decisions/ideas use the existing `web_fetch` path with the literal URLs added to `seed.md`.

**In:**
- Two KB files under `team-log/`: `decisions.md`, `ideas.md`. Append-only, one block per entry, newest on top.
- Worker `POST /kb-log?key=...` endpoint — accepts `{type, summary, detail, source_chat_url}`, appends to the right file via GitHub Contents API, commits as `[Claude/Watcher] log:<type> - <summary> - DD/MM/YY`.
- Watcher process: extracts `KB_LOG_START / KB_LOG_END` blocks from Claude's responses, POSTs to Worker, logs result to `watcher.log`.
- Seed updates: (a) two new fetchable URLs added to the canonical list, (b) write rule (when to emit `KB_LOG_*`), (c) read rule (consult log when topic is decision-prone).
- Server-side rate limit on the Worker write path — max 20 writes/hour across all log types (prevents loop misfires flooding the repo).

**Out:**
- Edits / deletes via watcher — append only. Corrections happen via desktop Claude using `kb.ps1`.
- Categorisation beyond `decision | idea` for v1. Tags can come later.
- Surfacing logs to humans via dashboard / email digest for v1.
- KB writes from any non-watcher path. The Worker write endpoint is for the watcher process only; desktop Claude continues using `kb.ps1` / `gh api`.

---

## Decisions

- **08/06/26 — Writes go via the existing Worker, not a separate endpoint.** One auth surface, one rate limit, one place to evolve. Decided by Maciej.
- **08/06/26 — Append-only from watcher path.** No edits or deletes via `POST /kb-log`. Watcher can be wrong; humans fix from desktop side. Decided by Maciej.
- **08/06/26 — Two types only (decision, idea), not three.** Accountability folds into decisions ("we agreed X on Y" is a decision). Avoid bucket sprawl. Decided by Maciej + Claude.
- **08/06/26 — Default-to-silence applies to KB writes.** Watcher Claude defaults to NOT logging — same posture as `WA_SEND`. Bar for emitting `KB_LOG_*` is high: clear, concrete, non-trivial. Decided by Maciej + Claude.
- **08/06/26 — Judgement-based consultation, not fetch-always.** Watcher Claude fetches `decisions.md` / `ideas.md` only when the topic is decision-prone (pricing, T&Cs, comms style, vendor choice, recurring questions). Not on every batch. Decided by Maciej.
- **08/06/26 — No carry-over seed injection on chat rotation.** Files are reachable via the same `web_fetch` path as the rest of the KB. New chats fetch on demand. Decided by Maciej.

---

## Open questions

- [ ] **Write attribution shape.** Worker commit author is fixed (`[Claude/Watcher]`); should the entry body also record `source: <TEAM ONE chat URL>` + `triggered_by: <Maciej | David | Magda>`? Probably yes — accountability needs the human-in-the-loop signal. Default for v1: include both.
- [ ] **Rate-limit storage.** Worker has no persistent storage attached today. Options: (a) Cloudflare KV namespace, (b) in-memory counter per isolate (resets on cold start, loose but cheap). v1 pick: (b) — sufficient given the realistic write rate.

---

## Build log

[Reverse-chronological. Newest entry on top. Agents append on every phase boundary.]

### 08/06/26 — Claude/Maciej — Phase 0: scope locked

Roadmap drafted and indexed. Scope, decisions, build plan locked. Ready for Phase 1 (KB scaffolding).

**Files touched:**
- roadmap/team-log.md (new)
- roadmap/INDEX.md (added entry)

**Commits:**
- [pending]

---

## Build plan

### Phase 1 — KB scaffolding
- Create `team-log/decisions.md` and `team-log/ideas.md` as empty files in the KB with a one-line header explaining the file's purpose.
- Add both URLs to `seed.md` canonical fetchable list.

### Phase 2 — Worker write endpoint
- `POST /kb-log?key=...` in `D:\tatkowski-whatsapp\worker\src\index.ts`.
- Request body: `{type: "decision" | "idea", summary: string, detail: string, source_chat_url?: string, triggered_by?: string}`.
- Worker fetches current file, prepends a new block (newest on top), commits via GitHub Contents API with the same PAT as reads.
- Rate limit via in-memory counter per isolate (max 20 writes/hour).
- Returns 200 with `{commit_sha, file_url}` on success; 4xx on validation failure; 429 on rate limit.

### Phase 3 — Watcher extractor
- `claude-driver.js` extracts `KB_LOG_START / KB_LOG_END` blocks from Claude's chat response (sibling to existing `WA_SEND` extractor).
- Each block POSTed to Worker. Result logged to `watcher.log`.
- Block format (in Claude's reply):
  ```
  KB_LOG_START
  type: decision
  summary: <one line>
  detail: <2-4 lines, Claude's distillation>
  KB_LOG_END
  ```

### Phase 4 — Seed updates
- Add fetchable URLs for `decisions.md` and `ideas.md` to canonical list in `seed.md`.
- Add **write rule** section: when to emit `KB_LOG_*` (clear decision in TEAM ONE / explicit ask to log / non-trivial idea worth parking). Default to silence. Examples + counter-examples.
- Add **read rule** section: consult `decisions.md` / `ideas.md` when topic is decision-prone (pricing, T&Cs, comms style, vendor choice, repeat-asked questions). Not on every batch.

### Phase 5 — End-to-end verification
- Trigger a decision via TEAM ONE ("Claude log this: we use Resend for all transactional email" or similar).
- Verify: block emitted → watcher catches → Worker writes → commit visible in repo → next fetch shows it.
- Trigger an idea capture. Same flow.
- Trigger a non-decision conversation. Verify NO log written (default-to-silence holding).

---

## Done criteria

- [ ] `team-log/decisions.md` and `team-log/ideas.md` exist in KB with headers
- [ ] Worker `POST /kb-log` accepts authed writes, rejects unauthed, rate-limits at 20/hr
- [ ] Watcher extracts `KB_LOG_*` blocks and POSTs them
- [ ] Seed includes both fetchable URLs + write rule + read rule
- [ ] At least one real decision logged end-to-end during TEAM ONE conversation
- [ ] At least one real idea logged end-to-end
- [ ] At least one non-decision exchange verified as NOT logging (default-silence intact)

---

## Post-ship summary

[To be filled when Status = SHIPPED.]
