# ROADMAP — Page-level token sweep + dark-mode override completion

**Status:** IN PROGRESS — Phase 1
**Owner:** Agent (Code, Sonnet 4.6)
**Last update:** 13/06/26 by Claude (Code)

---

## Scope

**In:**
- Replacing hardcoded hex colours in page-level `<style>` blocks with canonical tokens from `packages/ui/src/styles/tokens.css`
- Deleting bolted-on `[data-theme="dark"]` override blocks that become redundant once tokens are in place
- All `.astro` pages in `apps/*/src/pages/` and shared components in `packages/ui/src/components/` with audit severity ≥ 15
- Phase 1: canary (`medical-interpreting.astro` IE) · Phase 2: cross-market page families · Phase 3: per-market unique high-severity pages · Phase 4: shared components

**Out:**
- `packages/ui/src/components/SmartQuoteForm.astro` (queue #7 SmartQuote v3 rebuild)
- Payment pipeline, operator logic, magic-link auth, Drawer R2, email-service backend
- `global.css` second `:root` accent override (line ~1098, pre-existing live bug)
- `apps/{ie,uk}/src/pages/terms.astro` (pre-existing WIP)
- `apps/*/functions/lib/email-service.js` (pre-existing WIP)
- DS authoring under `packages/ui/src/tatkowski-design-system/` (never touch)
- `apps/ie/src/pages/recruitment.astro` and all other recruitment files (standing rule)

---

## Token map (authoritative, locked 13/06/26)

Derived from `packages/ui/src/styles/tokens.css`. Applies to all page-level style replacements.

| Hardcoded value | Token | Notes |
|---|---|---|
| `#ff6a1a` | `var(--accent)` | Brand orange; `--brand` is an alias |
| `#fff` / `white` on card surfaces | `var(--card-bg)` | Glass-style; dark = `rgba(30,41,59,0.85)`. Use for explicit card/box bg |
| `#ffffff` on alternate surfaces | `var(--surface)` | Solid; dark = `#1e293b`. Less common |
| `#f8fafc` / near-white surface tint | `var(--surface-alt)` | Off-white tint; dark = `#223044`. Use for `.block`, step bg, etc. |
| `#0f172a` foreground text | `var(--text)` | Highest contrast text; dark = `#f1f5f9` |
| `#475569` secondary text | `var(--text-secondary)` | Mid-emphasis; dark = `#cbd5e1` |
| `#64748b` muted text | `var(--muted)` / `var(--text-muted)` | Low-emphasis; dark = `#94a3b8` |
| `#e2e8f0` border / divider lines | `var(--divider)` | Lighter divider; dark = `#334155` |
| `#cbd5e1` border (stronger) | `var(--border)` | Standard border; dark = `#475569` |
| `rgba(0,0,0,0.04)` subtle bg tint | *(no clean token — leave as-is)* | Semi-transparent tints have no token |
| White text on accent button | Keep `#fff` | Always fine on `--accent` orange |

**Tokens that ALREADY exist and do NOT need new dark overrides:**
`--text`, `--text-secondary`, `--muted`, `--card-bg`, `--surface`, `--surface-alt`, `--border`, `--divider`, `--accent` — all flip automatically via `html[data-theme="dark"]` in `tokens.css`.

**Note on audit gap:** The audit tool detects missing EXPLICIT bg/fg declarations. It misses inherited-but-wrong cases such as `color:#fff` on a glass-card CTA section (light mode: white text on white glass = invisible). These require manual review beyond the JSON rankings.

---

## Decisions

- **13/06/26 — Fix philosophy = tokens, not more overrides.** Convert hardcoded values to tokens; dark mode falls out for free. Do NOT add more `[data-theme="dark"]` rules. Decided by Maciej (workstream brief).
- **13/06/26 — Recruitment pages remain out of scope.** Even if audit flags them (severity 20 for `recruitment.astro`), skip per standing rule. Decided by Maciej (CLAUDE.md).

---

## Open questions

*(none at start)*

---

## Build log

### 13/06/26 — Claude (Code, Sonnet 4.6) — Phase 0: READ gates + token map

READ gates completed. Key findings:

- `medical-interpreting.astro` has `.cta { color:#fff; }` causing light-on-light failure: the CTA section uses `tk-card` (translucent white glass in light mode) so white text is invisible. This is NOT in the audit JSON (audit only detects missing EXPLICIT declarations, not inherited-but-wrong values).
- The "FIX 9: Dark mode text overrides" block at lines 227–237 partially addresses dark mode but is incomplete (`.faq-item` background is not overridden).
- `medical-interpreting.astro` severity is below 15 in audit (FIX 9 partially reduced it), but it has a live light-mode failure that the audit missed.
- Audit severity-ranked page list (≥15, excluding out-of-scope): see Phase plan below.
- Token map locked — see table above.

**Files read:**
- `docs/dark-mode-audit-2026-06-13.json`
- `packages/ui/src/styles/tokens.css`
- `packages/ui/src/styles/global.css` (head)
- `apps/ie/src/pages/medical-interpreting.astro`
- `roadmap/_TEMPLATE.md`

**Commits:**
- *(none yet — roadmap-only phase)*

---

## Phase plan + severity ranking

### Phase 1 — Canary (this session)
- `apps/ie/src/pages/medical-interpreting.astro` *(live light-mode failure; not in audit top 15)*

### Phase 2 — Cross-market page families (severity order)
| Page family | Markets | Audit severity |
|---|---|---|
| document-translation | ES(60) PT(60) UK(60) IE(37) | 60/60/60/37 |
| apostille-service | ES(53) PT(53) IE(21) UK(19) | 53/53/21/19 |
| business-interpreting | ES(20) PT(20) UK(18) IE(??) | 20/20/18/?? |
| phone-interpreting | ES(15) PT(??) UK(??) IE(??) | 15/?/?/? |

### Phase 3 — Per-market unique high-severity (severity ≥ 15)
| Page | Market | Severity |
|---|---|---|
| translation-services-dublin | IE | 31 |
| certified-translation | IE | ~30 |
| index | ES/PT/UK | 26 |
| index | IE | 24 |
| admin | IE | 21 |
| interpreting | IE | 18 |
| school-interpreting | IE | 18 |
| interpreting | UK | 17 |
| notifications | sales | 17 |
| *(recruitment — SKIP)* | IE | *(20 — out of scope)* |

### Phase 4 — Shared components (all affect all 4 markets)
| Component | Severity |
|---|---|
| BookInterpreterForm.astro | 18 |
| Footer.astro | 18 |
| SmartQuoteDrawer.astro | 18 |

---

## Done criteria

- [ ] All audit entries with severity ≥ 15 either fixed or explicitly deferred-with-reason
- [ ] IE / UK / ES / PT homepages pass dark-mode contrast at 390 + 1440
- [ ] `apps/ie/src/pages/medical-interpreting.astro` carries no "FIX N" comment block
- [ ] `roadmap/page-token-sweep.md` close-out section written with commits list, pages touched, deferred items, screenshots index
- [ ] `#ff6a1a` count is zero across all touched pages (`git grep` confirms)
- [ ] All commits show `Active` on their respective CF projects

---

## Post-ship summary

*(to be filled in after SHIPPED)*
