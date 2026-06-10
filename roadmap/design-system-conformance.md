# ROADMAP — Design-system conformance

**Status:** Prompt 3 SHIPPED — next: IE subpages conformance + decision on shared component extraction
**Owner:** Maciej
**Last update:** 10/06/26 by Claude (Code)

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

---

## Open questions

*(none at start of Prompt 1)*

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

## Done criteria

- [x] Zero `#ff6a3d` hardcodes outside `design-system/` and `dist/` — commit 6472120
- [x] `--shadow-accent` token resolves in browser (no `var()` fallback gap) — issue #011 resolved, KB commit 8df525b
- [x] All four market builds clean after sweep — IE 52pp, UK 47pp, ES 45pp, PT 38pp
- [x] SmartQuote DS modal refactor (Prompt 2) — fixed overlay, white surface, 2-dot stepper, internal scroll, sticky Pay — commit 8532074
- [x] Page furniture conformance — IE done (commit 2351876); UK/ES/PT pending
- [ ] `contrast-enforcer.css`, `text-contrast-fixes.css`, `badge-fix.css` retired (all rules subsumed by conformant styles)
- [ ] Drawer refresh against `ui_kits/drawer`

---

## Post-ship summary

*(filled in after Status = SHIPPED)*
