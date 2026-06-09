# Team Log — Decisions

Append-only log of concrete decisions made in TEAM ONE WhatsApp or during Claude conversations. Written automatically by the watcher when a clear decision is reached; can also be written manually from desktop Claude via `kb.ps1`.

**Format:** each entry is a block, newest on top. Watcher Claude prepends new entries — never edits existing ones. Corrections happen via desktop Claude.

**What counts as a decision:**
- A choice made between concrete options ("we use Resend for transactional email, not SES")
- A commitment ("Magda runs IE B2B outreach Mon/Wed/Fri")
- A rule or constraint ("never quote per-page rates upfront on multi-document enquiries")
- An agreement on process ("send invoices 2 business days after assignment, not before")

**What does NOT count:**
- Discussions without a conclusion
- "Maybe we should…" / "we could…" — those go in `ideas.md`
- Restating existing decisions
- Banter, jokes, agreement-bursts

---

## Entry format

```
### YYYY-MM-DD HH:MM UTC — <one-line summary>

**Decided by:** <Maciej | David | Magda | Team>
**Source:** <TEAM ONE WhatsApp | direct chat URL>
**Detail:** <2–4 lines, Claude's distillation of what was decided and the rationale. Not a verbatim paste.>
```

---

<!-- entries below, newest on top -->

### 2026-06-09 18:39 UTC — kb-write replace todos/magda.md

**Source:** https://claude.ai/chat/6764f851-b210-45ee-bf2a-dc301875f100
**Detail:** 09/06 update - strategy pivot logged (lawyers deprioritised → employers + hospitals), prospect roster built (18), template approved, 2 direct emails ready to send — commit: 547482d

### 2026-06-09 18:39 UTC — kb-write replace magda/ie-prospects.md

**Source:** https://claude.ai/chat/6764f851-b210-45ee-bf2a-dc301875f100
**Detail:** Initial IE B2B roster (09/06) - 17 employer prospects identified after strategy pivot from lawyers to big employers + hospitals. 2 direct emails ready, rest need LinkedIn lookup. — commit: 55496ae

### 2026-06-09 14:11 UTC — kb-write create test-full-access.md

**Detail:** verify allowlist removed — commit: 587102d

### 2026-06-09 — WA watcher v0.5 SHIPPED

**Decided by:** Maciej + Agent (Sonnet 4.6)
**Source:** Build session (6-phase autonomous run)
**Detail:** v0.5 shipped. Six phases: (1) reply-to text fix — quoted body + author inlined in prompt, ID-suffix line gone; (2) `/watcher help` command; (3) chat auto-rename on `WATCHER_TITLE:` marker (PUT `/chat_conversations/{uuid}`, confirmed after 5 diagnostic passes); (4) retrospective rename script (`scripts/rename-old-chats.js`, dry-run default, `--apply` commits); (5) model/effort/thinking controls — `/watcher model <name> [effort] [thinking-on|off]`, model via DOM picker, effort/thinking via API PUT settings → 202; (6) seed.md updated + `COMMANDS.md` operator reference written. Model change via API blocked (400), can only be set via DOM at conversation creation.

### 2026-06-08 23:00 UTC — WA watcher v0.4 SHIPPED

**Decided by:** Maciej + Claude
**Source:** Build session in TEAM ONE / desktop Claude
**Detail:** v0.4 closed out. Inbound documents (PDF/docx/xlsx) via format-agnostic `setInputFiles`. Outbound files from claude.ai → TEAM ONE via WA Web clipboard-paste (`Set-Clipboard -Path` → Playwright Ctrl+V). Five outbound approaches tried before clipboard-paste landed; baileys-as-companion silently drops media, default WA Web file input is `accept="image/*"` only, + menu filechooser never fires, synthetic DragEvent fails the `isTrusted` check. KB_WRITE endpoint live on Worker (`d83f286c`) with server-side allowlist. `_waitForIdle` concurrency guard added — fixes stale-reply read on back-to-back batches. `extractGeneratedFiles` regex hardened (`/^\d{10,}-/` + `.crdownload` exclusion). v0.5 next: chat renaming (retrospective + forward), model/effort/thinking selection from WhatsApp, `/help`, reply-to text fix (quoted body inlined into prompt, currently only opaque ID prefix).

### 2026-06-08 21:17 UTC — kb-write append magda/ie-prospects.md

**Source:** https://claude.ai/chat/99abe138-b6cc-4912-9ca0-1005cb4d3107
**Detail:** smoke test of KB_WRITE capability — commit: 77694d5

### 2026-06-08 16:25 UTC — Phase 5 end-to-end test of the team-log write pipeline

**Decided by:** Maciej
**Source:** https://claude.ai/chat/0aa5046e-836b-4033-accd-e67931bea62a
**Detail:** Maciej triggered a live end-to-end test of the TEAM ONE watcher's KB_LOG write pipeline (watcher → Worker → team-log/decisions.md). Logging this entry verifies the full path works: fast_path trigger detection, block extraction, Worker POST, and append to decisions.md.

### 2026-06-08 16:02 UTC — Phase 5 end-to-end test of the team-log write pipeline (run 2)

**Decided by:** Maciej
**Source:** https://claude.ai/chat/f2f6e248-f956-4fd2-900e-b78842eec7a7
**Detail:** Test entry from the watcher to verify KB_LOG block extraction, Worker POST, and append to team-log/decisions.md. Pipeline is append-only from here — I can't edit a prior test entry, only add a new one. If you need an edit test, that has to go through desktop Claude with direct repo access.

### 2026-06-08 15:51 UTC — Worker write path smoke test

**Decided by:** Maciej
**Detail:** Verifying POST /kb-log appends correctly to team-log/decisions.md from PowerShell.

