# ROADMAP — ds-application

**Status:** IN PROGRESS — Phase 0 (foundation prep)
**Owner:** Maciej
**Last update:** 12/06/26 by Code

---

## Scope

Apply the Round 3 DS direction (`specs/Hero-DottedPattern-Fix.html` + `Glass-Elevation-System.html`) across all 6 templates × 4 markets + SalesManager. Pattern foundation + E1/E2/E3 surfaces + content bugs (info@ → contact@, #010 refund, blue CTA band) + #039 flag-pl fix. Definition-of-done checklist per template gates the QA pass. Programmatic SEO scale-out is gated on this workstream closing.

**In:**
- Pattern foundation (Hero-DottedPattern-Fix) applied across 6 templates
- E1/E2/E3 glass-elevation surfaces (Glass-Elevation-System) applied across 6 templates
- Content fixes: info@ → contact@ sweep; #010 refund clause alignment with locked T&Cs; blue CTA band copy
- #039 flag-pl rendering fix
- Rollout across IE/UK/ES/PT + SalesManager
- Per-template definition-of-done checklist as QA gate

**Out:**
- Programmatic SEO scale-out (gated on this closing)
- T&Cs wording changes (desktop territory)
- Marketing copy drafting (desktop territory)
- Recruitment pages (standing exclusion)

---

## Decisions

- **12/06/26 — Canonical DS folder is `packages/ui/src/Tatkowski Design System/`** — matches the Claude Design export name so re-export is a drop-in replace. Old hyphenated `design-system/` deleted. Decided by Maciej.
- **12/06/26 — `themes/` lives outside the DS tree at `packages/ui/src/styles/themes/`** — keeps app-owned theme overrides from being clobbered by DS re-exports. Decided by Maciej (option 1 of the migration push-back).

---

## Open questions

- [ ] **Application order across 6 templates** — Pattern-foundation-first across all templates, then E1/E2/E3 pass? Or full template-by-template (pattern + glass + content) before moving on? Latter ships visible pages faster; former gives cleaner diffs.
- [ ] **SalesManager scope** — Same DS pass as public market sites, or trimmed (no hero pattern, glass only on cards)?

---

## Build log

### 12/06/26 22:04 — Code — Round 3 §3.2 UK: align UKVI pages refund language with T&Cs

UK had **5 surfaces** with 'guarantee acceptance' framing conflicting with T&Cs §11. All rewritten per drafts approved 12/06/26, referencing **UKVI Para 39B** (correct UK standard — not blanket IE wording).

1. `data/guide/ukvi-translation-guide.ts:165` — Guide FAQ ("What happens if my translation is rejected?"). Replaced 'We guarantee acceptance…never had a translation rejected' with 'produced to current UKVI Para 39B standards…we revise and reissue at no extra cost' + ETA bands.
2. `data/service-detail/certified-translation.ts:143` — sales overview block. Replaced both 'We guarantee UKVI-accepted quality' and 'We guarantee it' with build-to-standard + revise-at-no-extra-cost framing.
3. `data/service-detail/certified-translation.ts:373` — FAQ tile. Retitled 'Acceptance Guarantee' → 'If UKVI raises a query'; body reframed.
4. `pages/ukvi-certified-translation.astro:35` — JSON-LD FAQ schema. Question 'Do you guarantee UKVI acceptance?' → 'Are your translations accepted by UKVI?'. Answer T&Cs-aligned.
5. `pages/ukvi-certified-translation.astro:146` — visible FAQ. Same question + answer rewrite as #4 (schema + visible in sync).

Verified live on `http://localhost:4322/ukvi-translation-guide/`: old 'guarantee acceptance' and 'never had a translation rejected' absent; 'Para 39B', 'we revise and reissue at no extra cost', and ETA bands all present.

**Commit:** 8d4efed — fix(content): #010 — align UK pages refund language with T&Cs (Round 3 §3.2 UK)

---

### 12/06/26 22:02 — Code — Round 3 §3.2 IE: align ISD page refund language with T&Cs

Two clauses on `immigration-translation-ireland.ts` (lines 123 + 146) conflicted with `apps/ie/src/pages/terms.astro` §11 ('reasonable endeavours + refund for impossibility only, NOT for delay or rejection'). Both rewritten per drafts approved 12/06/26.

- Line 123 (how-to step 5 bullet): `'acceptance guaranteed for any rejection attributable to our work, or full refund'` → `'built to the current ISD standard, with free reissue if ISD asks for a change attributable to our work'`.
- Line 146 (FAQ — 'What happens if ISD rejects the translation?'): dropped 'or provide a full refund'; added explicit ETA bands (24h/36h/48h for 1-3p/4-6p/7-10p, manual confirmation for 11+).

Sweep across UK/ES/PT lands as separate per-market commits — 13 surfaces found with equivalent acceptance-guarantee misalignment (UK: 5, ES: 4 + SNIG bug, PT: 4). PT Portuguese-language 'garantindo' on `traducao-certificada-aima.ts:21` and `traducao-registo-criminal.ts:21` translates to 'ensuring [completeness/compliance]' — not acceptance guarantees — left as-is.

Verified live on `http://localhost:4321/immigration-translation-ireland/`: 'acceptance guaranteed' and 'or full refund' absent; new 'built to the current ISD standard' and 'we revise and reissue at no extra cost — typically within 24 hours…' present in DOM (FAQ answer inside `<details>` accordion).

**Commit:** 21ed879 — fix(content): #010 — align ISD page refund language with T&Cs (Round 3 §3.2 IE)

---

### 12/06/26 21:35 — Code — Round 3 Phase 2 close (§2.1 + §2.2 + §2.3)

Phase 2 delivers the surface-tier system + the legacy hero floor removals direction §4 demanded. The four sub-steps:

**§2.1 — tokens/elevation.css.** Three tier token sets (E1 surface / E2 raised card / E3 overlay) plus per-tier `--e{N}-blur` / `--e3-saturate`. Theme-aware via existing tokens (`--bg`, `--bg-secondary`, `--divider`); dark overrides per spec. Imported in global.css after pattern.css. No behaviour change yet — the class-map swap in §2.2a is where tokens start being consumed. Commit `5dea82c`.

**§2.2a — class-map swap.** Rewrote the `.tk-surface` / `.tk-card` rule bodies in global.css to consume E1/E2 tokens. Added new `.tk-overlay` consuming E3 tokens. ~423 existing `tk-*` uses migrate automatically per the audit's plan (no markup edits). Resolved audit findings: 'blur is theatre on near-opaque surfaces' (E2 drops blur — perf win), 'invisible white border on light surfaces' (theme-aware borders via tokens), 'undefined hierarchy' (E1 < E2 < E3 explicit). Commit `ad003ef`.

**§2.2b + §2.2c — legacy floor removals (direction §4: 'no opaque floor box').** Without this, §1.2's hero scrim was hidden behind the legacy gradients.

- `.lang-hero` (LangHero.astro): dropped linear navy gradient `#0a1628 → #1a2744 → #0f172a`. Text re-pointed to `var(--text)` / `var(--text-secondary)` / `var(--accent-text)`. Chips theme-aware via `color-mix(in srgb, var(--text) 8/15%, transparent)`. Decorative `::before`/`::after` orange radials kept — soft glows, not floors.
- `.hero-split` (LandingPage.astro): `--hero-bg` fallback flipped from navy gradient to `transparent`; themed pages (e.g. IE irish via `themeAccent='ireland-green'`) still get their `--hero-bg` override. h1/lede/badges all theme-aware. Dropped paired `[data-theme="dark"]` overrides that were no longer needed.
- global.css 453-456: removed the `html .lang-hero .hero-title { color: #fff !important }` family of overrides that pinned text white under the old dark-floor assumption.
- `.drawer-centred` (drawer.css): dropped the orange-radial + slate-linear gradient that covered the pattern on the login/OTP screens. Substrate now `transparent` per direction §4c 'Substrate: flat white' — pattern + scrim flow through from the §1.4 body-zone wrapper.

Kept (NOT floors — soft tints, spec-aligned): global.css `.hero { background: radial-gradient(ellipse 60% 50% at 50% 0%, var(--accent-tint), transparent 70%) }` (the accent-tint pulse — mockup §1 explicitly retains it as the `.tint` layer); `.doc-hero` / `.page-hero` (no background to begin with); `.hero.tk-card` dark-mode gradient at global.css 443-446 (doesn't apply to the actual hero classes in the templates as they ship — left alone to keep scope tight).

Verified live in browser on IE /russian-translation light theme: `.lang-hero` background `rgba(0,0,0,0)` (transparent), `.hero-title` color `rgb(15,23,42)` (= `#0f172a` dark slate). Commit `b710cc1`.

**§2.3 — SalesManager surface tier alignment.** Desktop order-detail sliding panel → E3-equivalent: `rgba(15,23,42,.72)` background, `backdrop-filter: blur(14px) saturate(140%)`, `box-shadow: 0 24px 64px -16px rgba(0,0,0,.6)`. The dim backdrop sibling at `rgba(0,0,0,.55)` shows through the panel for the overlay-over-content effect. Mobile stays opaque on `T.surface1` — translucent over the full-screen mobile drawer would just look hazy. Metric cards: NO change. Already E2-equivalent in spirit (opaque `T.surface1`, no blur, hard-dark substrate); wholesale conversion would visually disrupt every card in SM (kanban, dashboard, mobile order cards) — out of §2.3 scope. Hard out-of-scope adherence: 7-line edit limited to `panelStyle` constant at OrderDetail.tsx:468-486. No touches to payment pipeline, order lifecycle, bake stages, status transitions, `useOrders` hook, `onUpdate/onArchive/onDelete` handlers, or any operator logic. Commit `e40f84d`.

**Verification (commit `9c021e4`):** ran the full screenshot sweep + new sales/drawer SPA captures. 92 fresh PNGs in `docs/ds-application-screenshots-2026-06-12/`. 4 expected-absent (UK LangPage not in codebase). MANIFEST.json + README.md updated to phase-aware shape.

**Builds clean throughout all four sub-steps:** IE 52 · UK 47 · ES 45 · PT 38 · sales 5 · drawer 1.

**Files touched in Phase 2 (8):**
- packages/ui/src/styles/tokens/elevation.css (new, 53 lines)
- packages/ui/src/styles/global.css (@import + .tk-* class-map + lang-hero override removal)
- packages/ui/src/components/LangHero.astro (legacy floor + theme-aware text)
- packages/ui/src/templates/LandingPage.astro (hero-split flatten + theme-aware text)
- packages/ui/src/components/OrderDetail.tsx (panelStyle → E3-equivalent)
- apps/drawer/src/styles/drawer.css (drawer-centred flatten)
- tools/ds-application-screenshots-spa.mjs (new — sales/drawer SPA captures)
- docs/ds-application-screenshots-2026-06-12/ (92 PNG + README.md + MANIFEST.json)

**Commits in order:**
- 5dea82c — feat(ds): add tokens/elevation.css with E1/E2/E3 tiers (Round 3 §2.1)
- ad003ef — feat(ds): class-map .tk-surface → E1, .tk-card → E2, add .tk-overlay → E3 (Round 3 §2.2a)
- b710cc1 — feat(ds): remove legacy hero floors + drawer auth-gate flatten (Round 3 §2.2b+c)
- e40f84d — feat(ds): salesmanager surface tier alignment (Round 3 §2.3)
- 9c021e4 — docs(ds): Round 3 Phase 2 verification — 92 fresh screenshots (88 public + 4 SPA)

---

### 12/06/26 21:18 — Code — Round 3 §1.4: Drawer pattern application

Apply the body zone per direction §4c. Drawer is its own SPA (no BaseLayout) so the wiring mirrors §1.3's SalesManager pattern: import `tokens/pattern.css` in the entry, mount `DottedPattern` and add `data-pattern-zone="body"` at the outer wrapper. No observer needed — single zone for the whole app.

`DrawerApp.tsx` had three separate return paths for `loading` / `logged_out` / `logged_in` auth states. Refactored into a single shared wrapper carrying the pattern + zone attribute, with a computed `content` subtree selecting per auth state. The auth state machine (D-series, transitions, hash routing) is unchanged — only the JSX shape around its outputs.

Hard out-of-scope adherence: no edits to magic-link auth, 6-digit code flow, document download, R2 logic, or hash routing. The shared-wrapper refactor is a render-shape change around the auth states.

**Known pre-existing visual (NOT a §1.4 gap):** the login screen's `.drawer-centred` class in `drawer.css` carries an opaque orange-radial + slate-linear gradient background that covers the pattern on the login/OTP screens. That's off-spec per direction §4c ("Substrate: flat white") but predates this workstream. Flattening `.drawer-centred` belongs to a Phase 2 polish on the auth gate, NOT §1.4 scope. Post-login surfaces (`.drawer-main`, which has no background) show the pattern through cleanly.

Verified live on http://localhost:4325/: `data-pattern-zone="body"` on outer wrapper with `--pattern-alpha:1`, `DottedPattern` canvas mounted at 1440×900. Hiding `.drawer-centred` via DevTools confirms the pattern is rendering underneath at full presence — orange dots clearly visible on the flat-white substrate.

Builds clean: drawer 1 page; IE 52 pages (no regression).

**Files touched (3):**
- apps/drawer/src/pages/index.astro (import tokens/pattern.css)
- apps/drawer/src/components/DrawerApp.tsx (DottedPattern mount + render shape)
- .claude/launch.json (drawer preview entry)

**Commits:**
- e80aedd — feat(ds): drawer pattern application (Round 3 §1.4)

---

### 12/06/26 21:10 — Code — Round 3 §1.3: SalesManager pattern application + dimmed focus state

Apply the `admin` zone per direction §4b. SalesManager doesn't use BaseLayout (own SPA), so the wiring is simpler than public sites — only one zone for the whole app, no observer needed.

- `apps/sales/src/pages/index.astro` imports `@tatkowski/ui/styles/tokens/pattern.css` so the admin zone selectors are loaded.
- `AdminApp.tsx` outer wrapper now carries `data-pattern-zone="admin"` always, plus `data-focus` when a data panel has focus.
- pattern.css's selectors set `--pattern-alpha:.6` baseline → `.18` on focus. The fixed `.dotted-pattern-wrapper` inherits via CSS-variable cascade. Hard-dark `--sm-*` navy substrate unchanged per scope rule.

Focus tracked at admin layout level via `useEffect` binding `focusin/focusout` on `<main.sm-main-content>` (the data-panel container — Dashboard/OrderBoard/Clients/Pairs/Users/Guide). Navigation chrome and overlays are siblings of `<main>`, so they don't trigger the dim. `focusout.relatedTarget` gates the false transition so focus moving between children inside `<main>` stays focused.

Hard out-of-scope adherence: no edits to `useOrders`, `updateOrder`, `onUnauthorized` order-state cleanup, `handleLogout`, OrderBoard, OrderDetail, kanban state, KV writes, Revolut webhook, HMAC, or any order lifecycle. New `panelFocused` state + useEffect are pure layout-level additions.

**Known minor deviation (logged for future hygiene pass, NOT a §1.3 gap):** existing `patternDimmed` state (auth-state-driven, feeds DottedPattern.dimmed prop's internal speed×0.4 + per-dot opacity×0.3) left untouched. When logged in + focused, the two dim signals compound: CSS-variable α 0.18 × component internal dim. Not exact spec fidelity but operationally safer than retiring `patternDimmed` mid-edit — its setters at AdminApp.tsx:1234 and :1256 sit inside `useOrders.onUnauthorized` cleanup and inside `handleLogout`. Collapsing the two signals belongs to a future pass that can factor the operator-logic boundary out of this file.

Verified live on http://localhost:4444/ — login screen (no `<main>` so no focus): `data-pattern-zone="admin"` present, root `--pattern-alpha:.6`, wrapper opacity 0.6. Toggling `data-focus` manually: drops to .18 / 0.18 with the .4s ease transition from pattern.css. Builds clean: sales 5 pages; IE 52 pages (no regression).

**Files touched (3):**
- packages/ui/src/components/AdminApp.tsx (state + useEffect + wrapper attrs)
- apps/sales/src/pages/index.astro (import tokens/pattern.css)
- .claude/launch.json (sales preview entry)

**Commits:**
- 6247f77 — feat(ds): salesmanager pattern application + dimmed focus state (Round 3 §1.3)

---

### 12/06/26 20:58 — Code — Round 3 §1.2: zone selectors across 6 templates + revert opacity hack + observer + verification

Every section wrapper across the 6 data-driven templates carries `[data-pattern-zone]`, per the locked mapping table:

| Template | Zones used |
|---|---|
| LangPage | hero · divider (acceptance) · body (doc-content/faq/related) · cta |
| LangHubPage | hero · body (langs/svc-types/faq) · cta (quote/contact/inline-smartquote) |
| LandingPage | hero (centered + split) · body (×11) · cta (×4) · divider (relatedRail) |
| ServiceDetailPage | hero · per-section: body (processTimeline/inclusionList/faq/authority) · cta (smartquote) |
| GuidePage | guide (hero + chapter prose, per §4a exception — ambient not motion) · divider (callouts) · cta (smartquote) |
| DocTypePage | hero · divider (acceptance) · body (doc-content/faq/related) · cta |
| Footer.astro | footer (one assignment, applies to all templates × markets) |
| LangHero.astro | hero (one assignment inside the shared LangPage hero component) |

IntersectionObserver in BaseLayout mirrors the active zone's `--pattern-alpha` / `--pattern-pull` / `--pattern-variant` onto `:root` so the fixed `.dotted-pattern-wrapper` tracks the rhythm. Tie-breaker: **closest-to-viewport-center wins; document order (last declared) on exact tie**. Architecture: IntersectionObserver tracks which zones are at all visible (cheap), rAF-throttled scroll listener recomputes closest-to-center while any zone is on screen.

`1a6e104` light-mode `.dotted-pattern-wrapper { opacity: 0.5 !important }` + its `[data-theme="dark"]` companion both removed from global.css. Pattern returns to full presence in both themes; legibility comes from the hero scrim (already in `tokens/pattern.css` from §1.1) and the forthcoming E1/E2/E3 surfaces (§2). Hero scrim activates anywhere `[data-pattern-zone="hero"]` is attached.

Observer behaviour verified live in Chrome on IE /russian-translation: scroll hero → body → cta → footer transitions root α 1.0 → 1.0 → 0.9 → 0.5 as expected. All 4 markets build clean: IE 52 · UK 47 · ES 45 · PT 38.

84 real-browser screenshots captured via `tools/ds-application-screenshots.mjs` (Playwright, adapted from Phase H — but keeps pattern wrapper visible, opposite intent): 4 markets × 6 templates × 2 themes × 2 viewports for IE, 4 markets × 5 templates × 2 themes × 2 viewports for UK/ES/PT (LangPage is IE-only by codebase design — `grep LanguagePage apps/*/src/pages/*` only hits IE; documented in README so it's not read as a regression).

**Open item carried forward (§2 territory, not §1.2):** the spec's "no opaque floor box" on heroes (direction §4) isn't yet honoured because every template's hero retains its own pre-existing background (e.g. `.lang-hero` navy gradient). The pattern.css scrim `::before` IS present per spec §7, but legacy hero CSS sits on top of it. Cleanup lands with E1/E2/E3 surface application in §2.

**Files touched (12):**
- packages/ui/src/styles/global.css (revert 1a6e104)
- packages/ui/src/components/LangHero.astro (zone=hero)
- packages/ui/src/components/Footer.astro (zone=footer)
- packages/ui/src/templates/LanguagePage.astro (5 zones)
- packages/ui/src/templates/LanguageHubPage.astro (7 zones)
- packages/ui/src/templates/LandingPage.astro (17 zones)
- packages/ui/src/templates/ServiceDetailPage.astro (6 zones)
- packages/ui/src/templates/GuidePage.astro (4 zones)
- packages/ui/src/templates/DocTypePage.astro (5 zones)
- packages/ui/src/layouts/BaseLayout.astro (observer)
- tools/ds-application-screenshots.mjs (new — Playwright sweep)
- docs/ds-application-screenshots-2026-06-12/ (new — 84 PNG, README, MANIFEST.json)

**Commits:**
- 5a93bd7 — feat(ds): zone selectors across 6 templates + revert opacity hack + hero scrim (Round 3 §1.2)
- 161e7f3 — docs(ds): Round 3 §1.2 verification — 84 real-browser screenshots + script

---

### 12/06/26 20:24 — Code — Round 3 §1.1: pattern.css foundation + no-pattern-opacity rule

Laid down the Brand Pattern token file per spec §7 + direction §3. New `packages/ui/src/styles/tokens/pattern.css` carries 8 zone tokens (hero / body / cta / divider / footer / guide / admin / print), is theme-aware via `--bg`, owns the wrapper opacity rule (the only file allowed to), and defines the hero reading scrim as `[data-pattern-zone="hero"]::before` (radial `--bg` feather, replaces the rejected `1a6e104` opacity hack). Print `@media` switches the live canvas for the seeded PNG bake (asset ships with the baking-studio workstream). Imported in `global.css` after `tokens.css` so the app's tokens still win on any shared variable.

`_adherence.oxlintrc.json` gains a `no-pattern-opacity` selector — any string-literal CSS rule outside `tokens/pattern.css` that targets `.dotted-pattern-wrapper` or `#particleField` with an `opacity` declaration warns. The reverted `1a6e104` patch would now fail this rule.

No observable behaviour change yet. Zone attributes aren't attached to template sections until §1.2, and the IntersectionObserver that mirrors the viewport-center zone's `--pattern-alpha` / `--pattern-pull` onto `:root` (required because the live `DottedPattern` wrapper is fixed-global and won't inherit from a section sibling) also ships in §1.2. All 4 markets build clean: IE 52 · UK 47 · ES 45 · PT 38.

**Files touched:**
- packages/ui/src/styles/tokens/pattern.css (new, 87 lines)
- packages/ui/src/styles/global.css (+2 lines, @import)
- packages/ui/src/Tatkowski Design System/_adherence.oxlintrc.json (+4 lines, no-pattern-opacity selector)

**Commits:**
- a2821f7 — feat(ds): add tokens/pattern.css with 8 zone tokens (Round 3 §1.1)

---

### 12/06/26 19:46 — Code — Phase 0: DS path canonicalisation

Renamed the canonical DS folder to `packages/ui/src/Tatkowski Design System/` (matches the Claude Design export name so future re-exports are a drop-in replace) and deleted the stale hyphenated `packages/ui/src/design-system/`. Moved `themes/ireland-green.css` to `packages/ui/src/styles/themes/ireland-green.css` so app-owned theme overrides don't get blown away on DS re-export (IE irish-translation landing still opts in via `themeAccent: "ireland-green"` — visual identity preserved). Updated the two live import sites (`BaseLayout.astro`, `global.css`), the sweep-accent skip-dir, the `landing.ts` doc comment, and CLAUDE.md path references. Historical phase docs left immutable. All 4 markets build clean: IE 52 · UK 47 · ES 45 · PT 38.

**Files touched:**
- packages/ui/src/layouts/BaseLayout.astro (import path)
- packages/ui/src/styles/global.css (@import path)
- packages/ui/src/styles/themes/ireland-green.css (moved here from design-system/themes/)
- packages/ui/src/data/types/landing.ts (comment)
- tools/sweep-accent.ps1 (skip-dir)
- CLAUDE.md (3 path references)
- packages/ui/src/design-system/** (deleted entirely)

**Commits:**
- 4bc2fa8 — chore(ds): canonicalise DS path to 'Tatkowski Design System/', remove stale design-system/

---

## Done criteria

- [x] Canonical DS folder at `packages/ui/src/Tatkowski Design System/`, stale `design-system/` removed
- [ ] Pattern foundation (Hero-DottedPattern-Fix) applied across all 6 templates
- [ ] E1/E2/E3 glass-elevation surfaces applied across all 6 templates
- [ ] info@ → contact@ sweep complete across IE/UK/ES/PT
- [ ] #010 refund clause aligned with locked T&Cs across IE/UK/ES/PT
- [ ] Blue CTA band copy applied across IE/UK/ES/PT
- [ ] #039 flag-pl fix shipped
- [ ] SalesManager DS pass complete (scope per open question)
- [ ] Per-template definition-of-done checklist green for all 6 templates × 4 markets
- [ ] All 4 markets build clean (IE 52 · UK 47 · ES 45 · PT 38) after final pass

---

## Post-ship summary

[Filled in after Status = SHIPPED.]
