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
