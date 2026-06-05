# Issues & Gotchas Log

Append-only log of issues, workarounds, and gotchas across all areas -- technical, client, legal, ops, anything non-obvious worth recording so the next person (human or AI) doesn't burn time rediscovering it.

**Newest entries on top.** Resolved entries stay -- the trail is the value.

**Categories** emerge as we go. Use square brackets like `[TECH]`, `[CLIENT]`, `[LEGAL]`, `[OPS]`, `[FIN]`, `[HR]`, `[MKT]`, `[SEO]`. Add new ones freely -- no approval needed.

**Usage** (from anywhere with `gh` auth):

```powershell
# Search before troubleshooting
pwsh tools/issues.ps1 read -Search "wrangler"
pwsh tools/issues.ps1 read -Status open
pwsh tools/issues.ps1 read -Category TECH

# Log a new issue or gotcha
pwsh tools/issues.ps1 log -Category TECH -Title "short symptom-led title" `
  -Symptom "what was observed" -Context "where/when" -By Claude

# Mark resolved
pwsh tools/issues.ps1 resolve -Id 4 -Resolution "what fixed it" -By Maciej

# Bump recurrence counter when the same issue hits again
pwsh tools/issues.ps1 bump -Id 4
```

**Entry format** (auto-written -- don't hand-edit unless fixing typos):

```
## #001 [CATEGORY] Symptom-led title -- DD/MM/YY -- OPEN
- Logged by: Name
- Symptom: what was observed
- Context: where/when/what was happening
- Resolution: (open)
- Recurrence: 1
```

When resolved, the status flips to `RESOLVED` and the Resolution line is filled in. Entries are never deleted.

Separators are ASCII double-hyphen (`--`) by design so the tooling stays encoding-safe across PowerShell versions and shells.

---

<!-- ENTRIES BELOW (newest first) -->
