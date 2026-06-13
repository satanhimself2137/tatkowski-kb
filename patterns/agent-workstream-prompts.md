# Agent workstream prompts — what works

How to write prompts for Claude Code / Sonnet agents handling multi-phase
build work across the Tatkowski monorepo. Extracted from the page-token-sweep
workstream (13/06/26) which sustained ~1+ hour of agentic work without drift,
with parallel cross-market edits and per-phase visual verification.

## When this applies

Any workstream that:
- Touches more than one file
- Has a mechanical pattern repeated across many files (especially cross-market mirrors)
- Needs visual verification (UI changes, theming, layout)
- Is large enough that the agent will need to commit + push more than once

Not needed for: single surgical fixes, one-line config changes, copy-paste from spec.

## The principles, in order of importance

### 1. Make the architectural call in the prompt, not the agent

The page-token-sweep prompt locked "tokens, not more overrides" upfront. The
agent didn't burn cycles deciding philosophy. If the prompt leaves the
architectural decision open, expect the agent to either ask, or pick badly,
or oscillate. State it explicitly with a one-line "why".

### 2. READ gates with a hard stop before any code

List the files the agent must read first. Then require a roadmap file to be
written and committed BEFORE any code work begins. The roadmap-first commit
forces planning into a visible artifact and gives a clean rollback point if
the plan is wrong.

### 3. Canary phase — fix one exemplar end-to-end before scaling

Pick the highest-value or most-representative single file. Have the agent
fix it fully — code, visual loop both modes both viewports, build, TS,
commit, deploy gate, real-browser sanity check — before touching anything
else. This forces the agent to discover the real shape of the work and
catch token-map gaps before they multiply across 100+ files.

### 4. Cross-market mirrors: fix once, diff, apply per-actual-selectors

IE/UK/ES/PT pages drift. Never let the agent blind-copy a diff across all 4
markets. Require: fix IE first, then diff IE before-vs-current against each
market sibling to discover what actually exists in each file, then apply
only the replacements that hit real selectors per market.

### 5. Parallel batched edits via `replace_all`

For pattern-driven changes (`#ff6a1a` → `var(--accent)` etc.) the agent
can run `replace_all` across multiple files in one batch tool call. The
token-sweep run did 4 files per batch across 5+ batches in single tool
turns. Explicitly invite this pattern: "Apply Batch N across all 4 files
in parallel."

### 6. Visual loop is mandatory and specific

Spell out: light AND dark, 390 AND 1440, real Chrome PLUS Playwright. The
agent will skip steps if "verify visually" is left vague. Eight screenshots
minimum per shared-component change. Two themes × two viewports per page.

### 7. Verify computed values, not just code

Code can look right and resolve wrong. After a token swap, have the agent
check the live computed value (e.g. `getComputedStyle(...).getPropertyValue('--card-bg')`)
matches expectation. Caught at least one false-positive in the sweep where
the page looked dark but `data-theme` wasn't actually set to light.

### 8. Distinguish redundant overrides from keepers

Once tokens land, most dark-mode overrides become redundant — delete them.
But some are legit: warning ambers, inline-style overrides, hero-specific
rgba glass tints. The prompt should tell the agent to keep these and only
delete overrides that the token replacement made unnecessary. A clean rule:
"If the override now sets the same value the token resolves to, delete it.
If different on purpose, keep it."

### 9. Zero-residual check per phase

Before each commit, the agent runs `git grep` for the anti-pattern being
removed (`git grep -n '#ff6a1a' <scope>`). Catches half-finished sweeps
before they ship. State this as a gate, not a suggestion.

### 10. Deploy gate after every push

Wait 90s, `wrangler pages deployment list --project-name <project>`, confirm
the commit shows `Active`, not `Failure`. If Failure, halt — do not continue
pushing on top of a broken main. This rule exists because of bd5bc94: Round 3 +
Round 4 were silently broken in production for 9 days because no deploy
verification was in the sign-off gate. Apply universally now.

### 11. Commit cadence: per logical unit, not per file

One commit per page family (all 4 markets in one commit), not one per
market. The unit is the logical change, not the file count. Per-file
commits flood git history and force per-file deploy gates that waste time.

### 12. Page counts must hold per commit

IE 52 · UK 47 · ES 45 · PT 38 · sales 5 · drawer 1. If a build drops a
page count, halt — something deleted a route. State the expected counts
in the prompt so the agent has the reference.

### 13. Build clean + TS clean before every commit

`npm run build` per affected app. `tsc --noEmit` per affected app. No
exceptions. State both as gates.

### 14. Roadmap append per commit

One line per commit with SHA + selectors changed + page count confirmed.
Keeps the workstream log fresh and gives the next session a clear handoff
point. Append happens after the deploy gate clears, not before.

### 15. Context compaction recovery

When the agent's context window compacts mid-task, file state in its
working memory is stale. The token-sweep run hit this and recovered by
re-reading all 4 affected files before continuing. State the rule: "If
context resets mid-phase, re-read every file you were editing before
applying further edits."

### 16. Stop conditions stated upfront

Halt-and-report conditions the agent will actually respect:
- Page count drops on any app build
- Any CF deploy goes Failure
- Any out-of-scope file is touched accidentally
- Audit suggests a replacement but the visual differs in light mode
- A page needs a colour with no clean existing token

The agent should not try to be heroic past these. State each explicitly.

### 17. Out-of-scope list is explicit, by name

List the files and systems the agent must NOT touch. Generic "don't touch
unrelated code" is too vague. Name the payment pipeline files, the auth
files, the WIP files, the queued-for-rebuild components. The token-sweep
prompt named `SmartQuoteForm.astro` as do-not-touch because it's queued
for v3 rebuild — saved hours of wasted work.

### 18. Universal git rules (Tatkowski ops standard)

- Three separate commands always: `add`, `commit`, `push origin main --ipv4`
- `git add <path>` never `git add -A`
- Push always uses `--ipv4`
- KB writes forbidden by the agent — local log only, desktop syncs

## Prompt skeleton (proven structure)

```
# WORKSTREAM: <name>

Model: <Sonnet 4.6 | Opus 4.7 med>
Why: <one-line model justification>

## Context
<what just shipped, why this matters, the architectural call already made>

## Authoritative inputs
<files/specs the agent must trust, with paths>

## Out of scope — DO NOT TOUCH
<explicit list by filename>

## READ gates — run before any edit
<numbered list of files to read, ending with "STOP and write roadmap, commit alone before code">

## Phase 0 — <prep / token map / audit extension>
<scope, time budget, commit format>

## Phase 1 — Canary
<one exemplar file, full visual loop both modes both viewports, deploy gate>

## Phase 2..N — <scaled work>
<per-family or per-cluster batches, commit cadence, deploy gate per push>

## Universal gates (apply to every commit)
1. Build clean per app affected, page counts hold
2. TypeScript clean per app affected
3. Visual loop both modes both viewports
4. Real-browser sanity check on at least one page
5. 3 separate git commands, --ipv4, targeted `git add`
6. CF deploy verification, halt on Failure
7. Roadmap append per commit
8. KB writes forbidden via agent

## Stop conditions
<explicit halt triggers>

## Definition of done
<measurable end state, including post-conditions like "zero #ff6a1a remaining in touched pages">
```

## Worked example reference

The full page-token-sweep prompt that drove this principle extraction lives
in the chat history dated 13/06/26 (1+ hour clean run, 119 files audited,
Phase 1 canary + Phase 2 cross-market mirrors shipped without drift).
Outcome commits on monorepo `main`: `ce2eff4` (Phase 1 medical-interpreting),
`a16c466` (Phase 2a document-translation × 4), `16efe02` (Phase 2b
apostille-service × 4), and subsequent. Roadmap file:
monorepo `roadmap/page-token-sweep.md` (per-phase build log appended live).

## Anti-patterns that have failed before

- **"Just trust the agent's judgment on N"** where N is the architectural
  decision → expect oscillation. Make the call in the prompt.
- **"Verify visually"** with no specifics → expect one screenshot,
  desktop-only, light-mode only. Spell out both modes both viewports.
- **Single mega-commit at the end** → impossible to roll back, hides
  Failure deploys, blocks downstream work. Commit per logical unit.
- **No deploy gate** → Round 3 + Round 4 silently broken for 9 days
  (bd5bc94 incident). Verify Active per push, every time.
- **Open-ended "fix all instances"** without an audit JSON → the agent
  will miss files or invent scope. Generate the audit first, commit it,
  reference it from the prompt.

## Maintenance

When a workstream prompt produces a clean run, append its commits + a
one-line lesson learned to this file. When a workstream prompt drifts,
diagnose which principle was missing and add it here. Both signals are
valuable — the second more so.
