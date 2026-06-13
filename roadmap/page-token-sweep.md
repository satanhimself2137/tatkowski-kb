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

### 13/06/26 — Claude (Code, Sonnet 4.6) — Phase 1: Canary — medical-interpreting.astro

Token-replaced all hardcoded hex in `apps/ie/src/pages/medical-interpreting.astro` and deleted the "FIX 9: Dark mode text overrides" block (11 lines).

Key changes:
- `.lead` / `.lang-intro`: `#475569` → `var(--text-secondary)`
- `.process-steps li::before`: `#ff6a1a` → `var(--accent)`
- `.block`: `#f8fafc` bg → `var(--surface-alt)`, `#e2e8f0` border → `var(--divider)`
- `.tag`: `#ff6a1a` → `var(--accent)`
- `.faq-item`: `#fff` bg → `var(--card-bg)`, `#e2e8f0` border → `var(--divider)`
- `.faq-item h3`: `#0f172a` → `var(--text)`
- `.cta`: removed `color:#fff` (was causing white-on-white-glass contrast failure in light mode)
- Deleted entire FIX 9 block (9 selectors, all now redundant via tokens)

Build clean · IE 52 pages ✓ · UK 47 ✓ · ES 45 ✓ · PT 38 ✓
Visual verification: light + dark × 1440px + 390px — all sections render correctly
CF deploy `ce2eff4` → Active

**Files touched:**
- `apps/ie/src/pages/medical-interpreting.astro`

**Commits:**
- ce2eff4 — fix(tokens): medical-interpreting — replace hardcoded colours with tokens, drop bolted dark overrides

---

### 13/06/26 — Claude (Code, Sonnet 4.6) — Phase 2a: document-translation (all 4 markets)

Token-replaced all hardcoded hex in `document-translation.astro` across IE/ES/PT/UK. Deleted IE's 53-line bolted dark override block and two smaller redundant overrides (`.dt-trust-item`, `.dt-crosslinks`) present in all 4 files.

Key changes (all 4 files):
- `.dt-crosslinks`: `#f8fafc` bg → `var(--surface-alt)`, `#e2e8f0` border → `var(--divider)`
- `.dt-crosslinks a`: `#ff6a1a` → `var(--accent)`
- `.language-tag`, `.step-number`, `.submit-button`: `background: #ff6a1a` → `var(--accent)` (replace_all)
- `.process-step`: `border-top: 4px solid #ff6a1a` → `var(--accent)`
- `.pricing-header`: `background: #0f172a` → `var(--table-header-bg)`, `color: white` → `var(--table-header-text)`
- `.pricing-row` + mobile `.price-col`: `border-bottom: 1px solid #e2e8f0` → `var(--divider)`
- Form inputs: `border: 2px solid #e5e7eb` → `var(--divider)`, `border-color: #ff6a1a` focus → `var(--accent)`
- `.file-upload-area`: `border: 2px dashed #d1d5db` → `var(--border)`, hover `border-color: #ff6a1a` → `var(--accent)`
- `.upload-note`: `color: #6b7280` → `var(--muted)`
- `.form-group label`: `color: #374151` → `var(--text-secondary)`
- Prior batches (from previous session): `color: #64748b/0f172a/334155` → tokens, `background: white` → `var(--card-bg)`, section backgrounds → `var(--surface-alt)`, `.dt-trust-icon` → `var(--accent)`, `.dt-chip *` → `var(--text) !important`
- IE only: deleted 53-line `/* Dark mode contrast overrides */` block (all selectors now redundant via tokens)
- All 4 files: deleted `[data-theme="dark"] .dt-trust-item` (redundant) + `[data-theme="dark"] .dt-crosslinks` (redundant)
- Left as-is: `.pricing-notes` warning yellow, `.cta-section .cta-button.primary:hover { background: #f8fafc }` (intentional), brand gradients, checkbox crimson `#dc143c`, `.dt-chips-bar` dark override (glass backdrop, no token equivalent)

Build clean · IE 52 ✓ · UK 47 ✓ · ES 45 ✓ · PT 38 ✓
Visual verification: dark + light mode scrolled through services, process, pricing table, quote form, FAQ — all correct
CF deploy `a16c466` → Active (IE/ES/PT/UK all confirmed)

**Files touched:**
- `apps/ie/src/pages/document-translation.astro`
- `apps/es/src/pages/document-translation.astro`
- `apps/pt/src/pages/document-translation.astro`
- `apps/uk/src/pages/document-translation.astro`

**Commits:**
- a16c466 — fix(tokens): document-translation — replace hardcoded hex with tokens, drop bolted dark overrides (all 4 markets)

---

### 13/06/26 — Claude (Code, Sonnet 4.6) — Phase 2b: apostille-service (all 4 markets)

Token-replaced all hardcoded hex in `apostille-service.astro` across IE/UK/ES/PT. IE and UK had a large dark override block (~70 lines); reduced to 2 kept rules each. ES/PT had no override block.

Key changes (all 4 files):
- `color: #0f172a/334155/475569/64748b` → `var(--text)` / `var(--text-secondary)` / `var(--muted)`
- `background: white` (11 instances each) → `var(--card-bg)`
- `background: #f8fafc` (5 section backgrounds) → `var(--surface-alt)`
- `background: #f1f5f9` (`.process-details span`) → `var(--surface-alt)`
- `border: ... #e2e8f0/#cbd5e1` → `var(--divider)` / `var(--border)` as appropriate
- `.pricing-header` bg → `var(--table-header-bg)`, color → `var(--table-header-text)`
- Dark override blocks reduced to 2 kept rules in IE+UK:
  - `.note-item` warning amber (base uses `#fef3cd` — no token)
  - `.internal-cross-links` inline style override
- ES/PT: no dark override block (none existed)

Build clean · IE 52 ✓ · UK 47 ✓ · ES 45 ✓ · PT 38 ✓
Visual verification: light + dark × 1440 + 390 — all sections correct
CF deploy `16efe02` → Active (all 4 markets confirmed)

**Files touched:**
- `apps/ie/src/pages/apostille-service.astro`
- `apps/es/src/pages/apostille-service.astro`
- `apps/pt/src/pages/apostille-service.astro`
- `apps/uk/src/pages/apostille-service.astro`

**Commits:**
- 16efe02 — fix(tokens): apostille-service — replace hardcoded hex with tokens, trim dark overrides (all 4 markets)

---

### 13/06/26 — Claude (Code, Sonnet 4.6) — Phase 2c: business-interpreting (all 4 markets)

Token-replaced all hardcoded hex in `business-interpreting.astro` across IE/ES/PT/UK. IE was already largely tokenized; only redundant dark override deletions needed. ES/PT/UK had condensed base CSS with hardcoded hex throughout.

Key changes ES/PT/UK:
- `color:#0f172a` → `var(--text)` (h2s, card h3, v-item h4, faq-item h3)
- `background:#fff` → `var(--card-bg)` (.card, .v-item, .booking-form, .field inputs, .faq-item)
- `background:#f1f5f9` → `var(--surface-alt)` (.pill)
- `border:1px solid #e2e8f0` → `var(--divider)` (.pill, .card, .booking-form, .faq-item)
- `border:2px solid #e2e8f0` → `var(--divider)` (.field input)
- `color:#475569` → `var(--text-secondary)` (.booking .sub, .field label)
- `color:#64748b` → `var(--muted)` (.notice)
- Deleted dark override blocks entirely (ES: 10 lines, PT: 10 lines, UK: 8 lines)

Key changes IE:
- Deleted 6 redundant dark overrides: `.card`, `.v-item`, `.booking-form`, `.faq-item`, `.why-item` (all duplicated what `var(--card-bg)` already provides), plus `.why-item h4`, and 9-line text-color block
- Kept 5 legitimate dark overrides: `.hero-list li`, `.btn.ghost`, `.btn.ghost:hover`, `.stat` (all rgba glass with different opacities per mode), `.field input` (semi-transparent deep bg)

Left as-is (intentional): brand gradient buttons (`#ff6a1a`/`#ff8c61`), blue form focus/submit (`#3b82f6`/`#2563eb`)

Build clean · IE 52 ✓ · UK 47 ✓ · ES 45 ✓ · PT 38 ✓
Visual verification: IE light mode 1440px ✓, IE dark mode 1440px ✓ (cards, pills, headings, FAQ all correct)

**Files touched:**
- `apps/ie/src/pages/business-interpreting.astro`
- `apps/es/src/pages/business-interpreting.astro`
- `apps/pt/src/pages/business-interpreting.astro`
- `apps/uk/src/pages/business-interpreting.astro`

**Commits:**
- a6f0a11 — fix(tokens): business-interpreting — replace hardcoded hex with tokens, drop bolted dark overrides (all 4 markets)

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
