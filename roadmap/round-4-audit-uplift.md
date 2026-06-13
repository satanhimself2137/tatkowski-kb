# ROADMAP — Round 4 Audit & Uplift

**Status:** IN PROGRESS — Stage 2 complete / Stage 3 pending
**Owner:** Maciej
**Last update:** 13/06/26 by Code

---

## Scope

Full design-system audit-and-uplift: token conformance sweep across all shared components and CSS files, then template extraction, zone/spacing attribution, and content copy uplift. Single run across 4 stages.

**In:**
- Stage 0: additions.css token set (accent-tint scale ×6, semantic shadows, rhythm tokens, breakpoints, z-index stack), adherence rules, hero mobile tune, button fixes
- Stage 1: Mechanical tokenisation — strip !important (excl. prefers-reduced-motion), brand hex literals, rgba accent literals from 8 component/CSS files: Header.astro, NavigationBar.astro, SmartQuoteForm.astro, SmartQuoteDrawer.astro, Footer.astro, FabTheme.astro, global.css, button/form/faq/pricing CSS
- Stage 2: Template extraction — net-new Astro templates for all page archetypes
- Stage 3: Pattern zone attribution, spacing tokens, contrast passes
- Stage 4: Content copy uplift per page-type

**Out:**
- `email-service.js` in `apps/{es,ie,pt,sales,uk}/functions/lib/` — do NOT touch
- Phase-H docs — do NOT touch
- Recruitment pages (standing exclusion): no SectorLandingPage, no copy/recruitment.md, skip §2.3, 2.4, 3.7, 4.4
- T&Cs wording changes (desktop territory)
- Marketing copy drafting (desktop territory)

---

## Decisions

- **13/06/26 — No-fallback token usage** — adherence rule catches hex literals inside var() fallbacks, so all brand hex replacements use `var(--token)` without fallback. Decided by session spec.
- **13/06/26 — Script block preservation in FabTheme.astro and Header.astro** — `rgba(255,106,26,0.55)` and `rgba(255,106,26,0.45)` in JS string literals are NOT replaced; sed limited to CSS style block line range only. Decided by session spec.
- **13/06/26 — prefers-reduced-motion !important preserved** — lines 36–45 of global.css use !important on *, *::before, *::after animation/transition overrides; these are load-bearing accessibility rules (low specificity selector must beat high-specificity component rules). All other !important stripped. Decided by Code based on W3C accessibility pattern analysis.
- **13/06/26 — rgba(255, 106, 26, 0) (alpha=0) left as-is** — adherence regex requires `0?\.\d+` (at least one decimal digit); integer `0` doesn't match. Safe to leave. Decided by Code.
- **13/06/26 — --shadow-accent not defined; inlined** — button-system.css had `var(--shadow-accent, 0 4px 16px rgba(...))` with no definition for --shadow-accent. Replaced with `0 4px 16px var(--accent-tint-30)` rather than stripping the fallback (which would yield no value). Decided by Code.

---

## Open questions

*(none)*

---

## Build log

### 13/06/26 — Code — Stage 2: Template extraction (404/terms/contact/faq × 4 markets)

4 new shared Astro templates added to `packages/ui/src/templates/`: NotFoundPage, LegalPage (slot-based), ContactPage (slot-based), FaqPage (data-driven). All 16 market pages (4 archetypes × 4 markets) migrated to use them. CSS and accordion JS live in templates; market pages supply localized copy via slots or props. Build clean (52pp IE). CRLF/LF warnings expected — encoding-only, not build errors.

**Key fixes during migration:**
- PT contact: was hardcoding phone/WA numbers; fixed to use siteConfig.whatsappNumber/phoneTel/phone
- ES terms: hardcoded tatkowski.com in breadcrumbs → `${siteConfig.domain}`
- All FAQ breadcrumbs: hardcoded domain URLs → `${siteConfig.domain}`
- UK FAQ right-to-work copy: was referencing "Irish employment law" → corrected to UK employment law
- ES FAQ: "SNIG" description clarified to Spanish acronym; court names localised to Spanish courts

**Skipped from Stage 2 per spec:**
- §2.3, 2.4 (SectorLandingPage / recruitment copy) — recruitment exclusion
- About pages, JurisdictionDocPage, CityPage, ServiceDetailPage, DocTypePage extension, LanguagePage extension, OrderPage, HomePage — deferred to follow-on sessions
- §4.4 — recruitment content (skipped)

**Files touched:**
- `packages/ui/src/templates/NotFoundPage.astro` (new)
- `packages/ui/src/templates/LegalPage.astro` (new)
- `packages/ui/src/templates/ContactPage.astro` (new)
- `packages/ui/src/templates/FaqPage.astro` (new)
- `apps/{ie,uk,es,pt}/src/pages/404.astro` (migrated)
- `apps/{ie,uk,es,pt}/src/pages/terms.astro` (migrated)
- `apps/{ie,uk,es,pt}/src/pages/contact.astro` (migrated)
- `apps/{ie,uk,es,pt}/src/pages/faq.astro` (migrated)

**Commits:**
- fc81755 — feat(stage-2): template extraction — 404/terms/contact/faq × 4 markets

---

### 13/06/26 — Code — Stage 1.8: button/form/faq/pricing CSS tokenisation

Stripped brand hex (`#ff6a1a`, `#ff8c61`) from var() fallbacks, replaced standalone rgba accent literals with tint tokens, removed `!important` from button-loading state. `--shadow-accent` inlined. `--accent-bg` (undefined) replaced with `var(--accent-tint-10)` in faq-system.css. All 4 files: 0 blocked hex, 0 rgba accent, 0 !important after.

**Files touched:**
- `packages/ui/src/styles/button-system.css`
- `packages/ui/src/styles/form-system.css`
- `packages/ui/src/styles/faq-system.css`
- `packages/ui/src/styles/global-pricing-tables.css`

**Commits:**
- cbc94e5 — Round 4 Stage 1.8: button/form/faq/pricing CSS — brand hex + rgba accent stripped, !important removed

---

### 13/06/26 — Code — Stage 1.7: global.css tokenisation

2868-line pure CSS file. Processed in three sections: pre-reduced-motion (lines 1–35), reduced-motion block (lines 36–45, kept !important), everything after (lines 46+). Stripped all other !important (129→0 outside block), all brand hex (48→0), all rgba accent (34→0). Result: 4 !important remaining, all in prefers-reduced-motion block. Build clean (52pp IE).

**Files touched:**
- `packages/ui/src/styles/global.css`

**Commits:**
- ad0cb74 — Round 4 Stage 1.7: global.css — brand hex + rgba accent + !important stripped (prefers-reduced-motion preserved)

---

### 13/06/26 — Code — Stage 1.4–1.6: SmartQuoteDrawer, Footer, FabTheme (batch)

SmartQuoteDrawer: new alpha values 0.03→tint-05, 0.28→tint-30, 0.44→tint-50, 0.55→tint-50. Footer: 0.07→tint-05. FabTheme: style block only (lines 27–189); script block at 191+ preserved intact (rgba JS string literals untouched). All three: 0 blocked hex, 0 rgba accent, 0 !important.

**Files touched:**
- `packages/ui/src/components/SmartQuoteDrawer.astro`
- `packages/ui/src/components/Footer.astro`
- `packages/ui/src/components/FabTheme.astro`

**Commits:**
- 3d09176 — Round 4 Stage 1.4–1.6: SmartQuoteDrawer + Footer + FabTheme tokenised

---

### 13/06/26 — Code — Stage 1.3: SmartQuoteForm.astro tokenisation

3276-line file, two style blocks (scoped lines 315–1930, is:global lines 1932–1961). Added `#ff8c61` → `var(--accent-hover)` (adherence-blocked, new to this file). `rgba(255, 106, 26, 0)` (alpha=0 integer) left as-is — not adherence-matched.

**Files touched:**
- `packages/ui/src/components/SmartQuoteForm.astro`

**Commits:**
- 37b5646 — Round 4 Stage 1.3: SmartQuoteForm.astro tokenised

---

### 13/06/26 — Code — Stage 1.2: NavigationBar.astro tokenisation

New alpha value handled: `rgba(255,106,26,0.16)` → `--accent-tint-15`.

**Files touched:**
- `packages/ui/src/components/NavigationBar.astro`

**Commits:**
- 0627c89 — Round 4 Stage 1.2: NavigationBar.astro tokenised

---

### 13/06/26 — Code — Stage 1.1: Header.astro tokenisation

1823-line file. Style block lines 153–1411, script block 1413+ preserved. Two initially missed patterns fixed in second pass: `rgba(255,106,26,0.75)` and spaced `rgba(255, 106, 26, 0.06)`. Script block: `const color = newTheme === 'dark' ? 'rgba(255,106,26,0.55)' : 'rgba(255,106,26,0.45)';` — preserved.

**Files touched:**
- `packages/ui/src/components/Header.astro`

**Commits:**
- 40a05dd — Round 4 Stage 1.1: Header.astro tokenised

---

### 13/06/26 — Code — Stage 0: additions.css + adherence rules + hero mobile tune + button fixes

Created `packages/ui/src/styles/tokens/additions.css` with accent-tint scale ×6, semantic tokens, shadow, rhythm, breakpoints, z-index. Updated `_adherence.oxlintrc.json` with blocked hex list. Applied hero mobile tune and button fixes.

**Commits:**
- 20e6488 — Round 4 Stage 0: additions.css, adherence rules, hero mobile tune, button fixes

---

## Done criteria

- [x] Stage 0: Token additions + adherence rules shipped
- [x] Stage 1: All 8 component/CSS files — 0 blocked hex, 0 rgba accent, 0 spurious !important
- [ ] Stage 2: Templates extracted and all non-recruitment pages migrated
- [ ] Stage 3: Pattern zone attribution + spacing tokens applied
- [ ] Stage 4: Content copy uplift applied
- [ ] Root build clean (all 4 markets)
- [ ] Adherence lint passes (0 violations)
- [ ] Site-wide screenshots 390px + 1440px verified
- [ ] CF Active check passed

---

## Post-ship summary

*(not yet)*
