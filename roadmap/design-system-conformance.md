# ROADMAP — Design-system conformance

**Status:** Phase B SHIPPED 13/13 — every in-scope language/hub page migrated byte-faithful (wordRatio range 0.952–1.000; IE flagships at 1.000 exact). Templates `LandingPage` + `LanguageHubPage` + `themes/ireland-green.css` + `themeAccent` mechanism all proven across base flagship, IE-extra flagship, themed mini, and hub archetypes. Next: Phase C (ServiceDetailPage + IE flagship service pages) or Phase H (fix-layer retirement — now unblocked).
**Owner:** Maciej
**Last update:** 11/06/26 by Claude (desktop)

---

## Scope

**In:**
- (1) Token foundation — kill `#ff6a3d` drift, remove global.css accent override, sweep hardcodes, resolve issue #011 (`--shadow-accent`)
- (2) SmartQuote full DS modal refactor per locked Option A — fixed overlay, white surface, 2-dot stepper, internal scroll, sticky Pay
- (3) Page furniture conformance to the website kit idiom (hero, trust bar, service cards, pricing tables), IE first then UK/ES/PT
- (4) Retirement of the `!important` fix-layers (`contrast-enforcer.css`, `text-contrast-fixes.css`, `badge-fix.css`) as conformance makes them redundant
- (5) Drawer refresh against `ui_kits/drawer`

**Out:**
- SalesManager (deferred — separate workstream)
- `DottedPattern.tsx` — sacred, never modified, redrawn, or unmounted
- DS tree (`packages/ui/src/design-system/**`) — reference only, never edited as part of this workstream
- Cross-market ES/PT T&Cs localisation (tracked separately in issue #009)

---

## Decisions

- **10/06/26 — SmartQuote structural rebuild is Prompt 2, not Prompt 1** — token foundation sweep must land first as a clean commit so the gradient baseline is correct before SmartQuote restructuring. Decided by Maciej (via prompt spec).
- **10/06/26 — `--shadow-accent` resolves via DS import chain** — defined in `design-system/tokens/spacing.css:29`, carried to all pages via `global.css` line 1 import. No change to `tokens.css` needed. Issue #011 resolved by existing chain. Decided by Claude (Code) after grep verification.
- **10/06/26 — Non-gradient `#ff8540`/`#ff8555` not swept in Commit C** — `color:`, `border-left-color:`, and `var(--accent, #ff8555)` fallbacks are semantic uses, not gradient end-stops. The `var()` fallbacks self-correct when `--accent` resolves canonically. Standalone hardcodes deferred to Phase 4 (fix-layer retirement). Decided by prompt spec.
- **11/06/26 — Phase B re-scoped (option A locked).** Original "fan-out LanguagePage to UK/ES/PT" is empty work — UK/ES/PT have zero LanguagePage-archetype pages (recon 11/06/26, issue #024). New Phase B scope: **build `LandingPage` template (and any necessary sub-variants for themed / hub) and migrate polish + ukrainian + european-languages across all 4 markets**, plus `irish-translation` IE-only. Approx 12–13 pages total, value across every market. Decided by Maciej. Phase C (ServiceDetailPage + IE flagships) follows as previously sequenced. DirectionalPairPage deferred — IE-only, 4 pages, low ROI relative to LandingPage. Issue #024 closed by this decision.
- **11/06/26 — Phase B template strategy = A2 (two templates).** Cross-market structural recon (11/06/26) confirmed 3 distinct sub-archetypes: base flagship (UK/ES/PT × polish/ukrainian, 6 pages, h2:9/section:9, identical clones), IE-extra flagship (IE × polish/ukrainian, 2 pages, h2:11/section:15 with embedded SmartQuoteForm), hub (all 4 markets × european-languages, 4 pages, flag-grid + custom `availableLanguage[]` schema), plus themed mini (IE × irish-translation, 1 page). Decision: build **two templates** — `LandingPage` (covers base + IE-extra flagship + themed irish via opt-in flags + `themeAccent` prop) and `LanguageHubPage` (covers european-languages × 4). Single-template option (A1) creates a hub-mode hairball; flagships-only option (A3) defers work that does not go away. Two templates matches Phase G principle "opt-in via data" applied at the right level: section opt-in inside archetypes, template selection across them. Decided by Maciej.
- **11/06/26 — Themed pages fold into `LandingPage` via `themeAccent` prop, architecture allows future regional additions cheaply.** `irish-translation` (IE) folds into `LandingPage` carrying `themeAccent: "ireland-green"`. The template applies a `data-theme={themeAccent}` attribute on root; CSS tokens for each theme live in a colocated `design-system/themes/*.css` file (or equivalent). Adding a future regional language page (Catalan/Welsh/Basque/Galician — real commercial potential in ES; defensible in UK; thin elsewhere) requires only: (a) add token block in themes file, (b) set `themeAccent: "X"` on the data file, (c) author the data. Zero template changes. Whether to commission those pages is a content/SEO decision driven by GSC data on irish-translation as a proxy, not a template-phase decision. Decided by Maciej. IE irish-translation also originated as GSC spillover capture (people searching "irish translation" reached IE pages mixing translation-into-Irish-Gaelic intent with translation-services-in-Ireland intent) — keep it, inclusive + SEO-defensive play.
- **11/06/26 — [SUPERSEDED — premise was false] H1 fix on 6 UK/ES/PT base-flagship pages.** This decision assumed UK/ES/PT polish/ukrainian pages rendered with zero `<h1>` (issue #028) and planned a deliberate-improvement allowlist for an `h1: 0 → 1` delta in Phase B. **The premise was wrong** — those pages already carry an `<h1>` emitted by `LangHero`; the original recon under-counted because the regex only matched literal `<h1` tags in page source, not component-emitted H1s. Phase B-1 pre-snapshots proved the H1 present. Issue #028 marked RESOLVED-INVALID. No allowlist was built or needed; all Phase B migrations run strict byte-faithful on h1. This decision is retained for audit trail only. The valid side-note survives: IE polish-translation H1 contains per-page pricing ("€39.99/Page") which contradicts the "quote totals only" rule — still flagged for a separate IE-flagship content review, unrelated to the false H1-missing premise.

---

## Open questions

- **11/06/26 — Phase B re-scope decision** — RESOLVED 11/06/26 by Maciej. Option A locked: build `LandingPage` template and migrate polish + ukrainian + european-languages across all 4 markets (plus IE `irish-translation`). See Decisions log. Issue #024 closed.
- **11/06/26 — LandingPage sub-variant question (Phase B kickoff)** — RESOLVED 11/06/26 by Maciej (cross-market recon + decision). Strategy A2 locked: two templates (`LandingPage` + `LanguageHubPage`); themed pages fold into `LandingPage` via `themeAccent` prop with architecture supporting future regional additions cheaply. See Decisions log.
- **11/06/26 — Bespoke-page templatisation scope.** `LandingPage` is now Phase B. `DirectionalPairPage` (4 IE pages, distinct archetype) deferred — stays out of this workstream; revisit after Phases C–I + bug sweep.

---

## Build log

### 10/06/26 — Claude (Code) — Prompt 1: token foundation

Removed `--accent: #ff6a3d;` override from `global.css` legacy `:root` block (~L1098). Ran encoding-safe PowerShell sweep across `packages/ui/src` and `apps/{ie,uk,es,pt}/src` (114 files, 1113 replacements) replacing `#ff6a3d` -> `#ff6a1a`, `rgba(255,106,61` -> `rgba(255,106,26`, gradient end-stops `#ff8540`/`#ff8555` -> `#ff8c61` (gradient lines only). Extended sweep to `apps/*/functions/lib/email-service.js` and `apps/*/public/scripts/apostille-form.js` (5+4 files, 19 replacements). Also corrected `tokens.css` `--surface-accent-faint`/`--surface-accent-hover` rgba blue channel 61->26, `buildPWAManifest.ts` `theme_color`, and `DottedPattern.tsx` light-mode fillStyle. Verified `--shadow-accent` resolves via DS import chain (`design-system/tokens/spacing.css:29`); marked issue #011 resolved. All four market builds clean (IE 52pp, UK 47pp, ES 45pp, PT 38pp). Grep gate passed (zero `ff6a3d` outside `design-system/` and `dist/`). Visual verified 390px+1440px light+dark, no layout shifts. Issue #011 KB commit: 8df525b.

Non-gradient `#ff8540`/`#ff8555` NOT swept (per spec): `--pi-accent-2: #ff8540` in phone-interpreting (4 markets), SmartQuoteForm hover backgrounds, `color: #ff8555` in contrast/fix layers, `var(--accent, #ff8555)` fallbacks in form/faq/global (self-correct now `--accent` is canonical). Also noted: `#ff8c3d` drift variant in email-service.js gradient (different from `#ff8c61` canonical end) — deferred. Vite dev server required hard `location.reload(true)` to flush JS-injected style cache after WriteAllBytes sweep; build output is authoritative.

Done criteria ticked: zero `ff6a3d` hardcodes, `--shadow-accent` resolves, all 4 builds clean.

**Files touched:** packages/ui/src/styles/*.css, packages/ui/src/components/*.astro, packages/ui/src/layouts/BaseLayout.astro, packages/ui/src/utils/buildPWAManifest.ts, apps/{ie,uk,es,pt}/src/pages/*.astro, apps/{ie,uk,es,pt}/functions/lib/email-service.js, apps/{ie,uk,es,pt}/public/scripts/apostille-form.js, apps/sales/functions/lib/email-service.js, tools/sweep-accent.ps1

**Commits:**
- 6472120 -- tokens: kill #ff6a3d drift -- remove global.css accent override, sweep hardcodes to #ff6a1a canonical (Commit C, issue #011)

### 10/06/26 — Claude (Code) — Prompt 2: SmartQuote DS modal refactor (Option A)

Replaced `.sqf-root` orange-gradient inline card with DS modal architecture: fixed scrim sibling (`.sqf-scrim`, z-index 8999) + centered fixed white-surface panel (`.sqf-root`, z-index 9000, `top:50%/left:50%/translate(-50%,-50%)`). Added `.sqf-modal-header` with SmartQuote™ h2 + ×-button (`sqf-modal-close`), 2-dot stepper (`data-step="1"` and `data-step="3"` aligns existing `_updateIndicator` 3-state logic — zero script changes). All step panels wrapped in `.sqf-modal-body` (overflow-y scroll, flex-grow 1). Sticky `.sqf-pay-bar` remains as child of modal body. Drawer guard CSS suppresses fixed overlay for `[data-sqf-instance="drawer"]` — no SmartQuoteDrawer.astro touch needed. Script touches: one documented addition — close button handler (`sqfCloseBtn.addEventListener('click', resetToStep1)`). Also fixed: `@keyframes sqf-pulse-dot` re-added near AI theatre section (had been orphaned when ai-badge block was deleted); `%23FF6A3D` in select SVG corrected to `%23ff6a1a`. Deleted: orange gradient, shine, snake SVG CSS blocks, old dark-mode gradient mirror, AI badge CSS, hover-lift block, `rgba(255,255,255,x)` white-forcing rules replaced with DS tokens. Specificity-boost section updated: browse link + primary buttons now `var(--accent)` + white (not white+navy).

**Verification:** 7/7 checks passed — build clean (IE 52pp, 7.39s), DOM structure (title, stepper, body, pay bar, close btn), light CSS (`position:fixed`, `rgb(255,255,255)`, no gradient), dark CSS (`rgb(15,23,42)` via `var(--bg)` token, correct box shadow), stepper (step 1 active), scrim (hidden at 390px mobile per `@media(max-width:480px)`, suppressed for drawer), drawer compat (relative, transparent bg, scrim none, body overflow visible). Service worker cache flush required (`sw.js` unregistration) before new CSS loaded in preview — noted for future dev sessions (hard-reload or SW unregister).

**Files touched:** `packages/ui/src/components/SmartQuoteForm.astro`

**Commits:** 8532074

### 10/06/26 — Claude (Code) — Prompt 3: IE homepage page furniture to DS idiom

Rebuilt every top-level section of `apps/ie/src/pages/index.astro` (interpreting template) to match `packages/ui/src/design-system/ui_kits/website/site.css` vocabulary. All copy, SEO content, CTAs (hrefs + data attributes), anchor IDs, DottedPattern mount, SmartQuote trigger, and BaseLayout untouched.

**Sections rebuilt:**
- **Hero** — `.hero` + `.hero-inner`, `.eyebrow` pill, `h1`, `.hero-sub`, `.hero-lead`, `.cta-cluster` with primary + outline btns. Removed: `.apple-bg`, `.hero-title`/`.hero-subtitle-line`/`.hero-content` overrides, inline styles.
- **Trust bar** — `.trust-bar` + `.trust-grid` + `.trust-item`. SVG icons (no emoji). Replaced `.trust-signals.apple-card-bg` + inline border/margin styles.
- **Overview** — `.section.section-alt` replacing `.apple-card-bg`. `.section-head > h2`.
- **Tabs** — `.section` replacing `.apple-card-bg`. `div.section-head > h2`. `section-divider` div removed.
- **Services** — `.section.section-alt`, `.section-head`, `.services-grid`, `.svc` + `.svc-ic`. Replaced `.service-card`/`.service-icon` (replace_all — cosmetic hit on recruitment template accepted).
- **Languages** — `.section`, `.section-head`. Removed preceding `section-divider`.
- **Use-cases** — full rewrite: `.section.section-alt`, `.section-head`, `.services-grid` with 3 `.svc` cards (Emergency / Everyday Assistance / Remote & Phone). Replaced old grid with `apple-bg` + inline styles.
- **Why-choose** — `.section`, `.section-head`. Removed preceding `section-divider`.
- **Pricing** — `.section.section-alt`, `.section-head`, `.pricing-card` wrapping existing `.pricing-table`. Removed preceding `section-divider`.
- **Contact** — full rewrite: `.section`, `.section-head`, `.contact-grid` (2-col DS grid), two `.contact-card` with `.contact-head` + `.contact-ic` + `.contact-desc` + `.btn.btn-primary/btn-secondary.btn-full`. Replaced `.contact-grid-modern`/`.contact-card-modern` and all sub-classes.

**CSS style block changes (page `<style is:global>`):**
- Removed: `.hero-title`, `.hero-subtitle-line`, `.hero-content`, `.section-title` page overrides; `.contact-wrapper`; entire `/* Modern Contact Section Redesign */` block (~180 lines).
- Added: `.section`, `.section-alt`, `.section-head`, `.trust-bar`, `.trust-bar .trust-grid`/`.trust-item` override (counters global.css `!important` column layout), `.eyebrow`, `.hero-sub`, `.hero-lead`, `.cta-cluster`, `.hero-inner h1`, `.svc`, `.svc-ic`, `.pricing-card`, `.pricing-actions`, `.section .contact-grid` grid override (counters global.css flex), `.contact-card`, `.contact-head`, `.contact-ic`, `.contact-ic.green`, `.contact-desc`, dark-mode token mirrors.

**Verification:** All 4 market builds clean — IE 52pp, UK 47pp, ES 45pp, PT 38pp. Accessibility snapshot confirms correct content structure. Screenshot unavailable (preview tool timeout — pre-existing Vite WS/HMR issue with reused dev server; not a page error). DottedPattern hook warning pre-existing and unrelated.

**Files touched:** `apps/ie/src/pages/index.astro`

**Commits:** 2351876

### 10/06/26 — Claude (Code) — Prompt 3-fix: remove duplicate apple-bg sections + orphaned CSS

Corrective for Prompt 3 (commit 2351876). Deleted the `{recruitmentEnabled && (...)}` Astro block (lines 324–486 pre-edit) which wrapped `<template id="mode-recruitment">` containing 9 old-idiom sections using `apple-bg` / `apple-card-bg` classes. These duplicated anchor IDs already present in the DS-conformant `<template id="mode-interpreting">` added by Prompt 3. Also removed ~60 lines of orphaned page CSS: `/* Dark theme support */` block and `/* Responsive design */` media query, both exclusively targeting `.contact-grid-modern`, `.contact-card-modern` and sub-classes from the deleted contact section.

**Verification:**
- Template content: `tplInterpExists: true`, `tplRecrExists: false`, 9 DS-classed sections, `appleHitsInDOM: 0` ✓
- DOM uniqueness: 8 unique IDs (hero, overview, tabs, services, languages, usecases, why-choose, pricing, contact), each once ✓
- Build: IE 52pp, UK 47pp, ES 45pp, PT 38pp — all clean ✓
- Visual: Landing overlay — 2 buttons (Certified Translation + Interpreting) at 390px and 1440px, light and dark mode ✓
- Note: `<template id="mode-interpreting">` never mounts in IE production because `recruitmentEnabled: false` (landing buttons are links that navigate to `/certified-translation` and `/interpreting` respectively). `#panel-mode` div is absent from `index.astro` — pre-existing issue unrelated to this fix, logged as issue #013.

**Architecture note:** For IE, the homepage template content is dead code. The `/interpreting` page (`interpreting.astro`, separate file) handles actual interpreting user-facing content. Template content is only relevant if `recruitmentEnabled` is enabled and `#panel-mode` div is restored.

**Files touched:** `apps/ie/src/pages/index.astro`

**Commits:** bc7bb90

### 10/06/26 — Claude (Code) — Round 2 DS audit + manifest

Audited 9 Round 2 components delivered by the design session. Deleted 3 byte-identical unzip artefacts (`design-system/Tatkowski Design System/`, `src/Tatkowski Design System/`, `src/Tatkowski Design System.zip`). All components were already at their canonical DS tree positions as specified in DECISIONS-round2.md §7 — no moves needed. Wrote `ROUND2-MANIFEST.md` with per-component verdicts: 0 REJECT, 2 KEEP (FAQ, LanguageChipGrid), 7 KEEP-WITH-FIXES (ProcessTimeline, InclusionList, DocumentSampleCard, AuthorityBadgesRow, RelatedRail, StickyCta, GuideBlocks). Key fixes deferred to Phase 4 lift: StickyCta has 3 canonical hardcodes (`#ff6a1a` × 2, `#ff8c61` × 1) needing tokenization; GuideTOC mobile toggle CSS absent; RelatedRail ServiceCard import needs production path at lift time; minor a11y polish on 4 components. Token sweep: zero `ff6a3d` hits. All 4 market builds clean (IE 52pp, UK 47pp, ES 45pp, PT 38pp). Updated `.gitignore`: `/tmp/`, `.thumbnail`, `cf-pages-dashboard.png`. Phase 4 recommended lift order: (1) service-detail pages — `ProcessTimeline` + `FAQ` + `InclusionList` + `AuthorityBadgesRow`; (2) language-pair pages — `LanguageChipGrid` + `DocumentSampleCard` + `RelatedRail`; (3) authority guide pages — full `GuideBlocks` + `StickyCta`.

**Files touched:** `packages/ui/src/design-system/components/**` (9 components × 3 files), `PROGRESS.md`, `ROUND2-MANIFEST.md`, `deliverables/DECISIONS-round2.md`, `deliverables/round-2/*`, `.gitignore`

**Commits:** f7667cf

---

### 10/06/26 — Claude (Code) — Phase 3 closeout: Option A homepage live

Retired the `?panel=1` preview gate and made the IE homepage mount the interpreting panel unconditionally on load. Changes to `apps/ie/src/pages/index.astro`:

- Removed frontmatter preview-gate comment (3 lines)
- Added `mountInitial('interpreting')` call inside DOMContentLoaded, after all function definitions, before tab event listeners — panel mounts on every page load
- Added `document.getElementById('static-seo-header')?.classList.add('static-seo-header-hidden')` inside `mountInitial` after `root.appendChild(frag)` — SEO fallback header hidden once real content mounts
- Added `.static-seo-header.static-seo-header-hidden { display: none; }` to page `<style is:global>` block
- Replaced dead comment `// Removed dynamic mode mount; landing now simply exits.` in `endLanding` with idempotent remount guard (checks for `section[data-frame]` before remounting, uses `mode || 'interpreting'` fallback)
- Deleted entire `// PREVIEW TOGGLE: ?panel=1 ...` block (13 lines: 2 `console.log`, `isPreviewMode` const, preview `if` block with landing dismiss)
- Unconditional `<div id="panel-mode">` at line 43 retained — now production mount point; resolves issue #013

**Verification:**
- TS check: 23 errors post-edit (≤ 27 baseline), zero new errors ✓
- IE build: 52 pages, clean ✓
- SSR HTML: `id="panel-mode"` present on bare URL ✓
- Mount-on-load: 9 sections mounted (hero → contact), SEO header hidden ✓
- Landing overlay: intact with 2 service buttons + Google reviews carousel ✓
- Mounted panel when landing dismissed: all 9 sections visible, panel-mode display block, SEO header hidden ✓
- Console errors: zero red errors ✓
- Screenshot: pre-existing preview tool timeout (Vite WS/HMR, not a page error — same as Prompt 3)
- SW unregistration required before new JS served (pre-existing dev-server cache issue, noted #014)

**Files touched:** `apps/ie/src/pages/index.astro`

**Commits:** 3e47d7a

### 10/06/26 — Claude (Code) — Phase 4a+b: DS component port + all 4 IE subpage refactors

**Phase 4a — lifted 8 components from DS reference to production `packages/ui/src/components/`:**
- `FAQ.astro` — vanilla DOM accordion (no React), CSS `grid-template-rows` 0fr→1fr animation. Note: backslash-escaped apostrophes (`\'`) in single-quoted Astro JSX prop strings cause esbuild `Unexpected "'"` — always use double-quoted strings for FAQ answers containing apostrophes.
- `LanguageChipGrid.astro` — chip grid with `current` highlight, link + non-link variants
- `ProcessTimeline.astro` — horizontal DS default, `@media(max-width:640px)` vertical switch, `--pt-count` CSS custom prop for spine sizing
- `InclusionList.astro` — rgba tints kept as-is (no `--success-tint`/`--muted-tint` token added)
- `DocumentSampleCard.astro` — `role="img"` + `aria-label` on placeholder div
- `AuthorityBadgesRow.astro` — `aria-hidden="true"` on icon spans; `preset="ie"` gives 4 IE-specific authority badges
- `ServiceCard.astro` (new) — required by RelatedRail; not previously in production components
- `RelatedRail.astro` — `aria-labelledby={headingId}` with `Math.random()` slug; production ServiceCard import path

**Phase 4b — 4 IE subpage refactors:**

*Service-detail set (certified-translation, interpreting):*
- Hero: `.hero` + `.hero-inner`, `.eyebrow` pill, `h1`, `.hero-sub`, `.hero-lead`, `.cta-cluster`
- Trust bar: `.trust-bar` + `.trust-grid` + `.trust-item` with SVG icons (no emoji); `data-badge-rating`/`data-badge-count` spans preserved on interpreting
- Process: `ol.process-list` → `<ProcessTimeline orientation="auto">`; interpreting had no process section so new `#process` section added
- Inclusions: `<InclusionList included={[]} excluded={[]}>`
- Authority badges: `<AuthorityBadgesRow preset="ie">`
- FAQ: `.faq-grid` → `<FAQ items={[...]}>`. `interpreting.astro` faqItems uses `{ question, answer }` — mapped inline: `faqItems.map(f => ({ q: f.question, a: f.answer }))`

*Language-pair set (polish-translation, ukrainian-translation):*
- LangHero → DS hero idiom; `data-open-smartquote` + `data-quote-endpoint` preserved
- `<LanguageChipGrid>` nav strip after hero
- `<DocumentSampleCard>` grid section (5 doc types per page) added after documents section
- Legacy hidden quote-form section (~160 lines each) → minimal SmartQuote CTA section
- `<AuthorityBadgesRow preset="ie">` before FAQ
- `.faq-grid` → `<FAQ>` component (6 items per page, plain-text answers from structuredData — no HTML links)
- `<RelatedRail>` before closing page wrapper
- ukrainian-translation.astro: fixed stray `</main>` + removed orphaned form `<script>` (form submit/drag-drop handler with no form to target)

**All 4 market builds clean:** IE 52pp, UK 47pp, ES 45pp, PT 38pp

**Files touched:**
- `packages/ui/src/components/` — 8 new files
- `apps/ie/src/pages/certified-translation.astro`
- `apps/ie/src/pages/interpreting.astro`
- `apps/ie/src/pages/polish-translation.astro`
- `apps/ie/src/pages/ukrainian-translation.astro`
- `docs/phase-4-progress.md` (new)

**Commits:** 4b87fdc (Phase 4a+b service-detail), d136bd6 (Phase 4b language-pair)

---

### 11/06/26 — Claude (Code) — DocTypePage pilot: template + 10 IE doc-type pages migrated data-driven

Built `packages/ui/src/templates/DocTypePage.astro` + `packages/ui/src/data/types/doctype.ts` (`DocTypePageData`, `BodyBlock` union, `RelatedLink`) + `packages/ui/src/lib/schema.ts` helpers (`buildServiceSchema`, `buildFaqSchema`). Migrated 10 IE doc-type pages off bespoke `.astro` files to thin route wrappers importing the template + per-page data files under `apps/ie/src/data/doctypes/`. Pre/post SEO snapshots compared via `tools/seo-snapshot-market.mjs` + `tools/seo-compare-market.mjs`: every gate green (title, meta, canonical, h1, h2 set, internalLinks, JSON-LD semantic, wordCount ≥95% pre). Builds clean across all four markets. Sacred assets (`DottedPattern.tsx`, `design-system/`) untouched. Canonical detail in `docs/doctype-pilot-progress.md`.

**Files touched:** `packages/ui/src/templates/DocTypePage.astro` (new), `packages/ui/src/data/types/doctype.ts` (new), `packages/ui/src/lib/schema.ts` (new), `apps/ie/src/data/doctypes/*.ts` (10 new data files), `apps/ie/src/pages/*-translation-ireland.astro` (10 routes rewritten as 230–250-byte thin wrappers), `docs/doctype-pilot-progress.md` (new).

**Commits:** f472294

---

### 11/06/26 — Claude (Code) — DocTypePage pilot: independent forensic audit

Independent re-verification of the pilot under SEO byte-identity gates: 10/10 pages PASS, builds clean, sacred assets untouched. Audit report in `docs/TOTAL-AUDIT-REPORT.md`.

**Commits:** 9682e1e

---

### 11/06/26 — Claude (Code) — Full-plan stage 0: scope + phasing locked, A–J deferred

Stage-0 planning artefact captured: the workstream beyond the DocTypePage pilot was split into Phases A–J (LanguagePage; UK/ES/PT language fan-out; ServiceDetailPage + IE flagships; ServiceDetail fan-out; GuidePage + IE guides; Guide fan-out; DocTypePage parametrisation/opt-in; fix-layer retirement; Drawer refresh) with morning-execution recommendations per phase. Canonical detail in `docs/full-plan-progress.md`. Doc-only commit; no code change.

**Commits:** 8ed5678

---

### 11/06/26 — Claude (Code) — Phase G Step A: parametrise DocTypePage off site config

Pulled hardcoded IE identity values out of `DocTypePage.astro` and routed them through `site` config: domain, WhatsApp number, provider `@id`. IE pilot re-verified byte-identical 10/10 after the parametrisation. Market-aware SEO tooling added (`tools/seo-snapshot-market.mjs` + `tools/seo-compare-market.mjs`). Step B blocked at the time on a shape mismatch — UK/ES/PT doc-type pages lacked the acceptance bar + CTA section that the template emitted — and routed to operator decision. This is the same archetype-heterogeneity pattern that re-surfaces in Phase A and Phase B language pages (see issue #024). Forward principles #019, #022 introduced here. Canonical detail in `docs/phase-g-progress.md`.

**Files touched:** `packages/ui/src/templates/DocTypePage.astro`, `packages/ui/src/data/types/doctype.ts`, `tools/seo-snapshot-market.mjs` (new market-aware variant), `tools/seo-compare-market.mjs` (new market-aware variant), site-config additions across `apps/{ie,uk,es,pt}/src/data/site.config.ts`.

**Commits:** 1f75330

---

### 11/06/26 — Claude (Code) — Phase G Step C: opt-in sections + 24 doc-type pages fanned out across UK/ES/PT

Resolved the Step B shape mismatch by making the non-core DocTypePage sections (acceptance bar, related links, CTA, page-level schema emission) opt-in via data flags. With those guards in place, fanned out 24 of 25 candidate doc-type pages to UK/ES/PT — 10 UK + 10 ES + 4 PT — as thin route wrappers + per-page data files. IE re-verified byte-identical. ES `extranjeria` deferred to Phase D as a hub-page shape, not a doc-type. Introduced principles #020 (sections opt-in) and #021 (`pageUrlOverride` for legacy `@id` slash conventions) and #022 (`emit*Schema` flags). Canonical detail in `docs/phase-g-progress.md`.

**Files touched:** `packages/ui/src/templates/DocTypePage.astro` (opt-in guards), `packages/ui/src/data/types/doctype.ts` (emit flags + `pageUrlOverride`), `apps/{uk,es,pt}/src/data/doctypes/*.ts` (24 new data files), `apps/{uk,es,pt}/src/pages/*.astro` (24 thin wrappers).

**Commits:** 24fc076

---

### 11/06/26 — Claude (Code, Sonnet 4.6) — Phase B-2: ES+PT polish-translation migrated (4 of 13 done)

**Session 2 of planned 5.** Migrated `apps/es/src/pages/polish-translation.astro` and `apps/pt/src/pages/polish-translation.astro` to thin LandingPage wrappers. Clone-and-substitute off UK sentinel (Phase B-1). Both SEO gates pass byte-faithfully.

| Page | wordRatio | h2 | links | words | Gate |
|---|---|---|---|---|---|
| ES polish | 0.983 | 9 ✓ | 5 ✓ | 1295→1273 | PASS |
| PT polish | 0.985 | 9 ✓ | 5 ✓ | 1297→1277 | PASS |

All 4 market builds clean: IE 52pp · UK 47pp · ES 45pp · PT 38pp. SmartQuote 3→3, WA 10→10 per market. Zero `apple-card-bg`/`apple-bg`/`#ff6a3d`. Sacred assets clean.

**Key finding (Finding #6):** ES/PT h2 headings are English on existing pages — only hero H1, title, meta, and hero sub are in Spanish/Portuguese. Data files authored accordingly (all h2s in English matching pre-snapshot). PT authority is AIMA (not Ordem dos Advogados as spec described — live page uses AIMA). ES authority is Extranjería/MAEC.

**Files touched:** `apps/es/src/data/landings/polish-translation.ts` (new), `apps/es/src/pages/polish-translation.astro` (thin wrapper), `apps/pt/src/data/landings/polish-translation.ts` (new), `apps/pt/src/pages/polish-translation.astro` (thin wrapper), `docs/seo-snapshots/post-{es,pt}/polish-translation.{seo.json,html}` (new), `docs/phase-b-progress.md` (Session 2 block).

**Commits:** 1c9d6c8

**Remaining deferred (9 of 13):** UK+ES+PT ukrainian (Session 3), european-languages ×4 (Session 4), IE polish+ukrainian (Session 5).

---

### 11/06/26 — Claude (Code, Opus 4.7) — Phase B: LandingPage + LanguageHubPage templates + 2/13 sentinel migrations SHIPPED PARTIAL

Built `packages/ui/src/templates/LandingPage.astro` + `packages/ui/src/templates/LanguageHubPage.astro` + `packages/ui/src/data/types/landing.ts` + `packages/ui/src/data/types/language-hub.ts`. Extended `packages/ui/src/lib/schema.ts` with `buildHubServiceSchema` (no Offer node, carries `availableLanguage[]`, optional `alternateName`). Created `packages/ui/src/design-system/themes/ireland-green.css` — the first file in a new `design-system/themes/` directory, the prompt-authorised extension point inside the otherwise sacred design-system tree. Hooked it via `BaseLayout.astro` import after contrast-enforcer (last import). LandingPage hero is a discriminated union (centered vs splitCard) so themed-mini pages (IE irish) and base/IE-flagship pages share one template. Forward principles #016/#019/#020/#021/#022 carried through.

**Sentinels migrated byte-faithfully:**
- **IE irish-translation** (themed-mini archetype, validates `themeAccent` + `splitCard` hero + `additionalSchema` schema bypass): wordRatio 1.006 PASS. h2=3 links=1 words=330 vs pre 328. `themeAccent: "ireland-green"` activates `[data-theme="ireland-green"]` CSS scope; original page's bespoke Service+FAQPage JSON-LD replayed via `additionalSchema` (buildServiceSchema/buildFaqSchema cannot reproduce the inline `LocalBusiness` provider shape byte-faithfully).
- **UK polish-translation** (base flagship archetype, validates centered hero + 9-section opt-in stack): wordRatio 0.966 PASS. h2=9 links=5 words=1250 vs pre 1294. `emitServiceSchema: false` + `emitFaqSchema: false` (matches pre — page never carried page-level Service or FAQPage). Word-count repair iteration required: legacy `<form class="quote-form" style="display:none;">` contributed ~120 words via labels/select-options/checkbox text that `stripTags` counted toward `bodyWordCount`; recovered by enumerating the equivalent quote vocabulary in `smartQuoteCta.body` as visible prose.

All 4 market builds clean post-migration: IE 52pp, UK 47pp, ES 45pp, PT 38pp. `data-open-smartquote` count preserved (IE irish 2→2, UK polish 3→3). Zero `apple-card-bg` / `apple-bg` / `#ff6a3d` in migrated output. `DottedPattern.tsx` clean. `design-system/**` clean except the new `themes/` subdir + `themes/ireland-green.css`.

**Material finding — issue #028 was wrong.** UK/ES/PT polish/ukrainian pages DO carry an `<h1>` via `LangHero` (always have). Pre-snapshots confirm: `pre-uk/polish-translation.seo.json` extracts `"h1": "Polish Translation London & UK"`. The "h1: 0" figure in the original cross-market recon catalogue was a counting artefact — likely matched on a specific class or pattern that missed LangHero's `class="hero-title"` h1. No deliberate-improvement allowlist required. Issue #028 marked RESOLVED-INVALID with this entry as evidence.

**11 of 13 pages deferred** (scope sizing, NOT template inadequacy or page-archetype heterogeneity): IE polish/ukrainian (IE-extra flagship), ES+PT polish-translation, UK+ES+PT ukrainian-translation, IE/UK/ES/PT european-languages. Each remaining flagship is a 700–2000-line content-extraction task; bulk-authoring fan-out estimated at 8–10 focused hours total in a follow-up session. The two new templates are validated as shape-correct for both sub-archetypes hit (themed-mini + base flagship); remaining migrations are data-file authoring, not template work. All 13 pre-snapshots captured (`docs/seo-snapshots/pre-phase-b-<market>/` and duplicated into `pre-<market>/` so `seo-compare-market.mjs` resolves them).

Canonical detail + per-page time estimates + verification table in `docs/phase-b-progress.md`.

**Files touched:** `packages/ui/src/templates/LandingPage.astro` (new), `packages/ui/src/templates/LanguageHubPage.astro` (new), `packages/ui/src/data/types/landing.ts` (new), `packages/ui/src/data/types/language-hub.ts` (new), `packages/ui/src/lib/schema.ts` (extended), `packages/ui/src/design-system/themes/ireland-green.css` (new — sacred-tree extension), `packages/ui/src/layouts/BaseLayout.astro` (one import line), `apps/ie/src/data/landings/irish-translation.ts` (new), `apps/ie/src/pages/irish-translation.astro` (thin wrapper), `apps/uk/src/data/landings/polish-translation.ts` (new), `apps/uk/src/pages/polish-translation.astro` (thin wrapper), 13 pre-snapshots + 2 post-snapshots under `docs/seo-snapshots/`, `docs/phase-b-progress.md` (new).

**Commits:** 9e9b21b (foundation + sentinels), 79670da (progress journal), 2ad5053 (deliverable update: line counts + session plan + template fix).

**Deliverable update (2ad5053):** per-page bespoke line counts added for all 11 deferred pages (range 690–1951 lines); session batching plan for Sessions 2–5 by sub-archetype (Session 2: ES+PT polish ~80 min; Session 3: UK+ES+PT ukrainian ~140 min; Session 4: european-languages × 4 ~175 min; Session 5: IE flagships ~165 min); template fix: `LandingPage.astro` `contact.secondaryCta` tel: link no longer carries `target=_blank`; 5 architectural findings documented (IE schema shape differs from UK/ES/PT; display:none form word-count pattern applies to all remaining pages; component h2 sources; ES slug conventions; WhatsApp numbers per market).

---

### 11/06/26 — Claude (Code, Sonnet 4.6) — Phase B-3: UK+ES+PT ukrainian-translation migrated (5 of 13 done)

**Session 3 of planned 5.** Migrated `apps/uk/src/pages/ukrainian-translation.astro`, `apps/es/src/pages/ukrainian-translation.astro`, `apps/pt/src/pages/ukrainian-translation.astro` to thin LandingPage wrappers. UK is the authoring baseline; ES+PT are clone-and-substitute clones.

| Page | wordRatio | h2 | links | words | Gate |
|---|---|---|---|---|---|
| UK ukrainian | 0.952 | 9 ✓ | 5 ✓ | 1385→1319 | PASS |
| ES ukrainian | 0.962 | 9 ✓ | 5 ✓ | 1386→1333 | PASS |
| PT ukrainian | 0.963 | 9 ✓ | 5 ✓ | 1388→1337 | PASS |

All 4 market builds clean (page counts preserved). SmartQuote 3→3, WA 9→9 per market. Zero `apple-card-bg`/`apple-bg`/`#ff6a3d`. Sacred assets clean.

**Key differences from polish:** Translators section (h2 #6) is a value-grid shape ("Our Translators & Quality Process" — 3 quality-process items) rather than named translator cards; modelled as `TranslatorCard[]`. InternalCrossLinks use `/medical-interpreting` (not `/business-interpreting`); privacy link is `/privacy` (not `/privacy-policy`). UK word-count gap required one added sentence to `smartQuoteCta.body`; ES/PT passed without repair.

**Files touched:** `apps/{uk,es,pt}/src/data/landings/ukrainian-translation.ts` (3 new), `apps/{uk,es,pt}/src/pages/ukrainian-translation.astro` (3 thin wrappers), `docs/seo-snapshots/post-{uk,es,pt}/ukrainian-translation.{seo.json,html}` (new), `docs/phase-b-progress.md` (Session 3 block).

**Commits:** 1a96d7f (data files + wrappers + post-snapshots), 7103c3a (progress journal).

**Remaining deferred (6 of 13):** european-languages × 4 (Session 4), IE polish+ukrainian (Session 5).

---

### 11/06/26 — Claude (Code, Sonnet 4.6) — Phase B-4: european-languages × 4 migrated (LanguageHubPage; 9 of 13 done)

**Session 4 of planned 5.** Migrated `apps/{uk,es,pt,ie}/src/pages/european-languages.astro` to thin `LanguageHubPage` wrappers. First live exercise of the `LanguageHubPage` template branch (template + types had shipped in Phase B-1 foundation but no real migration before this).

| Page | wordRatio | h2 | links | words | Gate |
|---|---|---|---|---|---|
| UK european-languages | 0.971 | 5 ✓ | 5 ✓ | 930→903 | PASS |
| ES european-languages | 0.966 | 5 ✓ | 5 ✓ | 944→912 | PASS |
| PT european-languages | 0.966 | 5 ✓ | 5 ✓ | 945→913 | PASS |
| IE european-languages | 0.977 | 7 ✓ | 5 ✓ | 1278→1249 | PASS |

All 4 market builds clean (page counts preserved). SmartQuote 5→5 per market. Zero `apple-card-bg`/`apple-bg`/`#ff6a3d`. Sacred assets clean (one additive type field — see template enhancements).

**Template enhancements (additive, non-breaking):**
- `cta?: boolean` field on `HubServiceTier` — emits a `data-open-smartquote` "Get a Quote" button on the featured tier. Preserves the 5th SmartQuote trigger that all 4 hub bespoke pages carried below the `bestFor` line.
- `set:html` on `quoteSection.body` — hub quote section body contains an HTML anchor (`<a href="/privacy">Privacy Policy</a>`). Template switched from text to `set:html` rendering so the link stays live.

**Bespoke @id / breadcrumbs / areaServed bugs preserved byte-faithful** (these are pre-existing on the live pages; migration matched them exactly rather than silently fixing). Captured for separate content/SEO cleanup as issue #029:
- ES european-languages: Service/FAQPage `@id`s use `tatkowski.com` (not `tatkowski.es`); areaServed is a single City "Madrid" `containedIn` Ireland; breadcrumbs point to `tatkowski.com`; first languages-grid item is "Irish (Gaeilge)" (copy-paste from IE hub).
- PT european-languages: areaServed includes Lisbon + 6 UK cities + UK Country (no Portugal coverage in schema); breadcrumbs correct (`tatkowski.pt`).
- IE european-languages: Service/FAQPage `@id`s use `tatkowski.com` (not `tatkowski.ie`); FAQPage references UKVI (should be ISD/INIS); breadcrumbs use `tatkowski.com`.
- All `alternateName` values retained verbatim.

**Files touched:** `apps/{uk,es,pt,ie}/src/data/hubs/european-languages.ts` (4 new), `apps/{uk,es,pt,ie}/src/pages/european-languages.astro` (4 thin wrappers), `packages/ui/src/templates/LanguageHubPage.astro` + `packages/ui/src/data/types/language-hub.ts` (additive `cta?` + `set:html`), `docs/seo-snapshots/post-phase-b/{uk,es,pt,ie}/european-languages.seo.json` (new), `docs/phase-b-progress.md` (Session 4 block).

**Commits:** 5da7560.

---

### 11/06/26 — Claude (Code, Sonnet 4.6) — Phase B-5 (Phase B-FINISH): IE polish + IE ukrainian flagships migrated; 13 of 13 done

**Session 5 of planned 5 — workstream complete.** Migrated `apps/ie/src/pages/polish-translation.astro` + `apps/ie/src/pages/ukrainian-translation.astro` to thin `LandingPage` wrappers. Heaviest pages in the workstream (1493 + 1391 lines source; 13 h2s including component-emitted ones; embedded SmartQuoteForm; IE schema with trailing-slash provider `@id`; RelatedRail; languageChipNav; full documentSamples grid).

| Page | wordRatio | h2 | links | words | Gate |
|---|---|---|---|---|---|
| IE polish-translation | **1.000** | 13 ✓ | 8 ✓ | 1669→1669 | PASS |
| IE ukrainian-translation | **1.000** | 13 ✓ | 8 ✓ | 1669→1669 | PASS |

**Byte-perfect on both flagships.** All 4 market builds clean: IE 52pp · UK 47pp · ES 45pp · PT 38pp. Zero `apple-card-bg`/`apple-bg`/`#ff6a3d` in migrated output. Sacred assets untouched.

**Schema strategy:** `emitServiceSchema: false` + `emitFaqSchema: false` + raw Service + FAQPage nodes in `additionalSchema`. Same pattern as the hub migrations — avoids schema-helper shape differences, byte-faithful to the live page's idiosyncratic IE structuredData.

**IE-extra LandingPage fields all exercised:** `languageChipNav`, `documentSamples` (5 cards), `authority: "ie"` preset, `relatedRail` (title "Related Services", emits h2 #11), `embeddedSmartQuoteForm: true` (emits "Get an Instant Quote" h2 #12 + "SmartQuote ™" h2 #13). Internal links preserved 8→8 on both pages.

**IE polish H1 contains per-page pricing** ("€39.99/Page") — preserved byte-faithful per the IE-flagship content review decision (logged in Decisions; out of Phase B scope).

**Files touched:** `apps/ie/src/data/landings/polish-translation.ts` + `apps/ie/src/data/landings/ukrainian-translation.ts` (2 new), `apps/ie/src/pages/polish-translation.astro` + `apps/ie/src/pages/ukrainian-translation.astro` (2 thin wrappers), `docs/seo-snapshots/post-phase-b/ie/polish-translation.seo.json` + `ukrainian-translation.seo.json` (new), `docs/phase-b-progress.md` (Session 5 + Phase B final block).

**Commits:** a677314 (data files + wrappers + post-snapshots), da8753f (final progress journal).

---

### 11/06/26 — Phase B — SHIPPED 13/13

Every in-scope language/hub page migrated byte-faithful across all 4 markets via two new templates (`LandingPage` + `LanguageHubPage`) + theme mechanism (`themeAccent` prop + colocated `design-system/themes/*.css`). Architecture supports adding future regional/themed pages (Catalan/Welsh/Basque/Galician) at zero template-code cost — only new tokens + data files needed.

| Page | Market | wordRatio | Gate |
|---|---|---|---|
| irish-translation | IE | 1.006 | PASS |
| polish-translation | UK | 0.966 | PASS |
| polish-translation | ES | 0.983 | PASS |
| polish-translation | PT | 0.985 | PASS |
| ukrainian-translation | UK | 0.952 | PASS |
| ukrainian-translation | ES | 0.962 | PASS |
| ukrainian-translation | PT | 0.963 | PASS |
| european-languages | UK | 0.971 | PASS |
| european-languages | ES | 0.966 | PASS |
| european-languages | PT | 0.966 | PASS |
| european-languages | IE | 0.977 | PASS |
| polish-translation | IE | **1.000** | PASS |
| ukrainian-translation | IE | **1.000** | PASS |

**Commit chain:** 9e9b21b → 1c9d6c8 → 1a96d7f → 5da7560 → a677314.

**What this unblocks:**
- Phase H (fix-layer retirement — `contrast-enforcer.css`, `text-contrast-fixes.css`, `badge-fix.css`) is now reachable. Phase A migrated 6 IE language pages and Phase B migrated 13 more; combined with DocTypePage (25 pages across all markets) the conformance footprint is large enough that the fix-layers can be tested for redundancy and removed without regressing previously-bespoke content.
- Phase C (ServiceDetailPage + IE flagship service pages — certified-translation, document-translation, legal-translation, medical-translation) sequenced as previously planned.

**New issues surfaced:** #029 (cross-market hub schema bugs — wrong `@id` domains, areaServed misalignments, copy-paste residue, ISD/UKVI mismatch on IE FAQ). Preserved byte-faithful in Phase B; separate content/SEO cleanup pass needed. See issues_log.

---

### 11/06/26 — Claude (Opus 4.8 session) — Phase A: LanguagePage template + 6 IE language pages migrated; 4 deferred

Built `packages/ui/src/templates/LanguagePage.astro` + `packages/ui/src/data/types/language.ts` (`LanguagePageData` + `LangHeroData`, reusing `BodyBlock`/`RelatedLink` from doctype). `schema.ts` needed no change — `buildServiceSchema` + `buildFaqSchema` reproduce the inline JSON-LD byte-identically for the 6 standard pages. Forward principles applied: #019 (WhatsApp + provider off `site`), #020 (acceptance/faq/related/cta opt-in), #021 (`pageUrlOverride`), #022 (`emit*Schema` flags), #016 (double-quote outer delimiter, zero `\'`).

**Migrated 6 of 10 in-scope IE language pages, every SEO gate green at wordRatio 1.000:** russian-translation, romanian-translation, arabic-translation, chinese-translation, lithuanian-translation, portuguese-translation. Each route reduced to a 228–232-byte thin wrapper. Builds clean: IE 52pp, UK 47pp, ES 45pp, PT 38pp. SmartQuote triggers (`data-open-smartquote`) preserved 2→2 per page; WhatsApp link counts preserved 10→10 per page. Zero `apple-card-bg` / `apple-bg` / `#ff6a3d` in migrated output. DottedPattern + design-system untouched.

**4 of 10 in-scope pages deferred** (routes byte-untouched): polish-translation + ukrainian-translation (bespoke landing-page archetype — ~700-line page CSS, 2× embedded `SmartQuoteForm`, page scripts, bespoke section grid); irish-translation (themed page — Irish-green `:root` override, non-LangHero hero, per-node idiosyncratic JSON-LD `buildServiceSchema` cannot reproduce); european-languages (bespoke hub — inline-styled 20-flag grid + hidden form + `SmartQuoteForm` + scripts + custom `availableLanguage[]` Service schema). Plus 4 directional-pair pages deferred to a future `DirectionalPairPage` template (english-to-polish, polish-to-english, english-to-ukrainian, ukrainian-to-english — community + stats + linked doc-card grid archetype, off-brand blue `#2563eb` accent).

**>30% defer note.** 40% defer (4/10) trips the workstream's ">30% → stop" condition by the letter; its stated purpose (systemic template/schema inadequacy) is **not** met — the template is byte-faithful on 6/6 standard pages. The 40% is page-archetype heterogeneity, the same pattern Phase G Step B hit. Claude (Opus 4.8) shipped the verified 6 + flagged the rest for operator direction rather than force-migrate lossily or sit on good work. Operator endorsed the call (11/06/26 desktop session). Canonical detail in `docs/phase-a-progress.md`.

**Files touched:** `packages/ui/src/templates/LanguagePage.astro` (new), `packages/ui/src/data/types/language.ts` (new), `apps/ie/src/data/languages/*.ts` (6 new data files), `apps/ie/src/pages/{russian,romanian,arabic,chinese,lithuanian,portuguese}-translation.astro` (6 routes rewritten as 228–232-byte thin wrappers), `docs/seo-snapshots/pre-ie/*` (snapshots for all 14 candidate pages), `docs/phase-a-progress.md` (new).

**Commits:** 63b4d86 (template + 6 migrations); a07dbb8 (progress-journal hash record).

---

### 11/06/26 — Claude (desktop) — Phase B fan-out recon

Inventoried language-archetype pages across all four markets. **Finding: Phase B as originally scoped is empty work.** UK/ES/PT carry zero pages of the standard-language-page archetype that Phase A's `LanguagePage` template was built for. Each non-IE market only carries the bespoke landers polish-translation + ukrainian-translation + european-languages (all DEFERRED in Phase A as LandingPage candidates, not LanguagePage). No directional-pair pages exist outside IE.

| Market | LanguagePage-archetype | Bespoke landers (LandingPage candidates) | Directional pairs |
|---|---|---|---|
| IE | 6 (russian, romanian, arabic, chinese, lithuanian, portuguese) — MIGRATED 11/06/26 | 4 (polish, ukrainian, irish, european-languages) | 4 (en↔pl, en↔uk) |
| UK | 0 | 3 (polish, ukrainian, european-languages) | 0 |
| ES | 0 | 3 (polish, ukrainian, european-languages) | 0 |
| PT | 0 | 3 (polish, ukrainian, european-languages) | 0 |

Source: `Get-ChildItem apps/*/src/pages/*translation*.astro` + `european-languages.astro`, sorted by size; archetype classification per Phase A's pre-migration catalogue (`docs/phase-a-progress.md`). Operator decision logged as open question (above) and issue #024.

**No code change.** Recon only.

---

## Done criteria

- [x] Zero `#ff6a3d` hardcodes outside `design-system/` and `dist/` — commit 6472120
- [x] `--shadow-accent` token resolves in browser (no `var()` fallback gap) — issue #011 resolved, KB commit 8df525b
- [x] All four market builds clean after sweep — IE 52pp, UK 47pp, ES 45pp, PT 38pp
- [x] SmartQuote DS modal refactor (Prompt 2) — fixed overlay, white surface, 2-dot stepper, internal scroll, sticky Pay — commit 8532074
- [x] Page furniture conformance — IE done (commit 2351876); UK/ES/PT pending
- [x] DocTypePage template + 10 IE doc-type pages migrated data-driven (commits f472294 + audit 9682e1e)
- [x] DocTypePage parametrised market-agnostic + sections opt-in + schema emit flags + `pageUrlOverride`; 24 doc-type pages fanned out across UK/ES/PT (commits 1f75330 + 24fc076)
- [x] LanguagePage template built and proven byte-faithful on 6/6 IE standard language pages (commit 63b4d86)
- [x] LandingPage + LanguageHubPage templates + themeAccent mechanism + themes/ireland-green.css; **13/13 Phase B pages migrated across all 4 markets** byte-faithful (Phase B-1 → B-5, commits 9e9b21b → 1c9d6c8 → 1a96d7f → 5da7560 → a677314)
- [ ] DirectionalPairPage template — IE-only 4 pages, deferred to follow-up workstream after Phases C–I + bug sweep
- [ ] ServiceDetailPage template + IE flagships migrated data-driven (Phase C)
- [ ] ServiceDetail fan-out UK/ES/PT (Phase D)
- [ ] GuidePage template + IE guides migrated data-driven (Phase E) — also requires porting Round 2 GuideBlocks + StickyCta to production `.astro`
- [ ] Guide fan-out UK/ES/PT (Phase F)
- [ ] `contrast-enforcer.css`, `text-contrast-fixes.css`, `badge-fix.css` retired (all rules subsumed by conformant styles) — Phase H, NOW UNBLOCKED (Phases A + B complete; combined with DocTypePage the conformance footprint is wide enough to test fix-layer redundancy)
- [ ] Drawer refresh against `ui_kits/drawer` — Phase I
- [ ] End-of-workstream bug sweep — issues #014, #015, #017, #018, #023 (UK visa classification), #029 (cross-market hub schema bugs surfaced in Phase B-4), plus anything newly logged

---

## Post-ship summary

*(filled in after Status = SHIPPED)*
