# Tatkowski KB - Master Copy

Master copy of `tatkowski_knowledge_base.md`. **The repo is the only source of truth. No local clone** (clones rot and get deleted). Everything goes through `gh api` over Desktop Commander, wrapped by the helper script `tools/kb.ps1`.

## Per-session flow (any team member)

Requirements per machine: GitHub CLI (`gh`) authed + Desktop Commander. Nothing else, nothing kept on disk.

**1. Bootstrap the helper** (only setup - refetch anytime if it's missing):
```powershell
$b64=(gh api "repos/satanhimself2137/tatkowski-kb/contents/tools/kb.ps1?ref=main" --jq ".content")-replace "\s",""; [IO.File]::WriteAllBytes("$env:TEMP\kb.ps1",[Convert]::FromBase64String($b64))
```

**2. Read at session start:**
```powershell
& "$env:TEMP\kb.ps1" read
```
Pulls the KB to `%TEMP%\kb_work.md`.

**3. Edit** `%TEMP%\kb_work.md` with targeted string replacements. Never regenerate the whole file from scratch.

**4. Write back:**
```powershell
& "$env:TEMP\kb.ps1" write -By David -Message "what changed"
```
David uses `-By David`, Maciej `-By Maciej`. Commits auto-tag as `[Claude/<name>] - <message> - DD/MM/YY`.

## Safety built into the helper
- **Stale-guard:** refuses to overwrite if the repo changed since your read (use `-Force` only to deliberately override). Prevents silently clobbering a teammate's edit.
- **Self-timeout:** every `gh` call self-aborts after 20s, and interactive prompts are disabled - so a hung network/auth call can never wedge Desktop Commander.

## Rules
- **One logical operation per command.** Never chain multiple `gh` calls with `;` - if one hangs it takes down the whole bridge. The helper exists so you don't hand-roll `gh` chains.
- After significant updates, replace the project-file attachment in the Claude project so mobile sessions stay in sync.

---

## KB layout (what's where)

Maintained manually — update when structure changes.

**Root files:**
- `tatkowski_knowledge_base.md` — main long-form KB (the canonical document)
- `ai_comms.md` — agent communication patterns and conventions
- `ai_notes.md` — operational notes for AI agents
- `issues_log.md` — running log of issues encountered and resolved
- `README.md` — this file

**Directories:**
- `gsc/` — Google Search Console data dumps and historical pulls
- `gsc-tools/` — GSC puller source code (mirrored from `D:\tatkowski-gsc\`)
- `interpreters/` — interpreter directory and rates
- `magda/` — Magda-specific docs (`playbook.md`, `ie-prospects.md`)
- `patterns/` — recurring patterns, templates, and conventions
- `roadmap/` — workstream roadmaps. **Start at `roadmap/INDEX.md`** for the full list with status. Individual files: `_TEMPLATE.md`, plus one file per active/queued/shipped workstream.
- `todos/` — per-person todo files. Currently: `todos/magda.md`. Other team members' actions sit inline in `tatkowski_knowledge_base.md` (PENDING ITEMS table) or in their owning roadmap files.
- `tools/` — helper scripts. Currently: `kb.ps1`.

**For discovery:**
- "What workstreams are active?" → `roadmap/INDEX.md`
- "What's the current state of X?" → fetch the relevant `roadmap/<name>.md`
- "What do we know about Y?" → search `tatkowski_knowledge_base.md` (semantic) or fetch directly
- "What are X's outstanding actions?" → `todos/X.md` if it exists, else the main KB PENDING ITEMS table
