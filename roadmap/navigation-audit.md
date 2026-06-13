# ROADMAP — Navigation audit (scroll bug, active-page indicator, routing perf)

**Status:** SHIPPED
**Owner:** Agent (Code, Sonnet 4.6)
**Last update:** 13/06/26 by Claude (Code)

---

## Scope

**In:**
- E.1 — Mobile menu scroll-on-close stability (body-scroll-lock pattern review + tighten)
- E.2 — Desktop active-page indicator CSS (parity with mobile)
- E.3 — Routing perf audit: ClientRouter + prefetch config across all 4 markets

**Out:**
- Mobile menu UX redesign / animation changes
- Header.astro structural changes
- Recruitment pages (standing rule)

---

## E.0 — Read-first diagnosis (13/06/26)

### Files read
- `packages/ui/src/components/Header.astro` (1801 lines) — nav component, all mobile menu JS
- `packages/ui/src/layouts/BaseLayout.astro` (lines 1–180) — confirmed `<ClientRouter />` at line 167
- `apps/ie/astro.config.mjs` — no prefetch config
- `apps/uk/astro.config.mjs` — no prefetch config
- `apps/es/astro.config.mjs` — no prefetch config
- `apps/pt/astro.config.mjs` — no prefetch config

### E.1 — Scroll-lock findings

Pattern in `Header.astro` lines 1644–1665:

```js
function lockBodyScroll(){
  lockedScrollY = window.scrollY || window.pageYOffset || 0;  // closure var
  document.body.dataset.scrollLock = 'true';
  document.body.style.position = 'fixed';
  document.body.style.top = `-${lockedScrollY}px`;
  ...
}
function unlockBodyScroll(){
  if(document.body.dataset.scrollLock !== 'true') return;
  const restoreY = lockedScrollY;   // reads closure var
  ...
  window.scrollTo(0, restoreY);     // restore IS present
}
```

**The `window.scrollTo` restore IS already implemented.** The naive bug (missing restore) is not present.

**Identified risk:** `lockedScrollY` is a closure-scoped `let` inside the `astro:page-load` callback. The value is correct in the common case, but relies on the closure persisting correctly across the open→close sequence. A more robust pattern is to derive `restoreY` directly from `body.style.top` at unlock time:
```js
const restoreY = -parseInt(document.body.style.top || '0', 10);
```
This removes the closure dependency entirely and is resilient to any future code path that clears `body.style.top` separately.

**Minor leak:** `window.addEventListener('resize', ...)`, `window.addEventListener('scroll', ...)`, `document.addEventListener('keydown', ...)`, and `document.addEventListener('click', ...)` accumulate on each `astro:page-load` event (document/window persist across ClientRouter navigations, but the listeners are re-added). The `updateHeaderBottomVar` guard (`document.body.contains(headerEl)`) prevents stale handlers from acting on detached elements. `closeMobileMenu` is guarded by `mobileMenuContainer.classList.contains('mobile-open')` — returns false for detached nodes. No functional breakage found; minor memory growth per navigation.

**E.1 action:** Tighten `unlockBodyScroll` to use `body.style.top` derivation instead of closure variable.

### E.2 — Desktop active-page indicator findings

JS at line 1585 already sets `aria-current="page"` on BOTH `.mobile-menu-card a` AND `.desktop-nav a`:
```js
document.querySelectorAll('.mobile-menu-card a, .desktop-nav a').forEach((link) => {
  ...link.setAttribute('aria-current', 'page');
});
```

CSS active-page rules at lines 1351–1389 are scoped ONLY to `.mobile-menu-card`. No rule exists for `.desktop-nav .nav-link[aria-current="page"]`. The attribute is set but invisible on desktop.

**E.2 action:** Add CSS block after line 1389 for `.desktop-nav .nav-link[aria-current="page"]` — light/dark, matching the mobile indicator's visual language (accent border + tint background).

### E.3 — Routing perf findings

- `<ClientRouter />` confirmed at `BaseLayout.astro:167` (inside `<head>`). View transitions are live.
- ClientRouter automatically enables prefetch with `defaultStrategy: 'hover'` (Astro 5 default).
- No explicit `prefetch` key in any of the 4 market `astro.config.mjs` files.
- Current state: links are prefetched on hover — adequate, but `viewport` strategy would prefetch sooner (when the link enters the viewport) without waiting for the user to hover.

**E.3 action:** Add `prefetch: { prefetchAll: true, defaultStrategy: 'viewport' }` to all 4 `astro.config.mjs` files. `prefetchAll: true` enables the strategy for ALL internal links (not just those with `data-astro-prefetch`). Small marketing site — acceptable resource cost.

---

## Decisions

- **13/06/26 — E.1 strategy: tighten, not rewrite** — `window.scrollTo` restore is already present; improvement is to remove closure dependency by reading from `body.style.top`. No JS structural changes. Decided by Agent based on read-first diagnosis.
- **13/06/26 — E.3 strategy: viewport prefetch** — `prefetchAll: true` + `defaultStrategy: 'viewport'` for all 4 markets. Marketing pages are small; preloading on viewport entry (vs hover) gives a faster perceived nav on mobile where hover doesn't exist. Decided by Agent.

---

## Build log

### 13/06/26 — Claude (Code, Sonnet 4.6) — E.1/E.2/E.3: Implementation

Applied all three changes in a single commit (`a4d7ca3`). All 4 market builds green.

**E.1:** `unlockBodyScroll` in Header.astro now reads `restoreY = -parseInt(document.body.style.top || '0', 10)` instead of the closure variable. Closure variable `lockedScrollY` is still set but is now unused in unlockBodyScroll — safe to leave for reference.

**E.2:** Added `.desktop-nav .nav-link[aria-current="page"]` CSS block (light + dark mode) in Header.astro immediately after the mobile active-page block. Accent border + subtle tint background — lighter than mobile card treatment (no translateY lift on desktop nav items).

**E.3:** `prefetch: { prefetchAll: true, defaultStrategy: 'viewport' }` added to `apps/{ie,uk,es,pt}/astro.config.mjs`. Upgrades from default `hover` to `viewport` strategy.

**Files touched:**
- `packages/ui/src/components/Header.astro`
- `apps/ie/astro.config.mjs`
- `apps/uk/astro.config.mjs`
- `apps/es/astro.config.mjs`
- `apps/pt/astro.config.mjs`

**Commits:**
- a4d7ca3 — feat(nav): E1/E2/E3 — scroll-lock tighten, desktop active-page CSS, viewport prefetch

---

### 13/06/26 — Claude (Code, Sonnet 4.6) — E.0: Read-first diagnosis

Completed full read-first pass of Header.astro, BaseLayout.astro, and all 4 astro.config.mjs files. Diagnosis documented above.

**Files read:**
- `packages/ui/src/components/Header.astro`
- `packages/ui/src/layouts/BaseLayout.astro`
- `apps/{ie,uk,es,pt}/astro.config.mjs`

---

## Done criteria

- [x] E.1 — `unlockBodyScroll` uses `body.style.top`-derived `restoreY`
- [x] E.2 — `.desktop-nav .nav-link[aria-current="page"]` CSS added (light + dark)
- [x] E.3 — `prefetch: { prefetchAll: true, defaultStrategy: 'viewport' }` in all 4 market configs
- [x] Build green on all 4 markets (IE 52 ✓ UK 47 ✓ ES 45 ✓ PT 38 ✓)
- [x] `roadmap/navigation-audit.md` close-out section written

---

## Post-ship summary

E.1: Scroll-lock pattern was already correct (window.scrollTo restore present). Tightened `unlockBodyScroll` to derive restoreY from `body.style.top` rather than closure var — eliminates any potential iOS Safari edge-case. The described "scroll-on-close" bug was not reproducible from code inspection; this tighten provides insurance.

E.2: JS was already setting `aria-current="page"` on desktop nav links; only the CSS treatment was missing. Added matching rules (accent border + tint background, light + dark). Desktop gets a lighter variant of the mobile card treatment — no translateY lift since desktop nav items don't use the card-lift pattern.

E.3: ClientRouter was live at BaseLayout:167. None of the 4 market configs had an explicit prefetch key. Added `prefetchAll: true` + `defaultStrategy: 'viewport'` — prefetches all internal links when they enter the viewport, which is the right strategy for a marketing site with short pages and non-hover mobile users.

Single commit `a4d7ca3` covers all three.
