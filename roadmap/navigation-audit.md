# ROADMAP — Navigation audit (scroll bug, active-page indicator, routing perf)

**Status:** IN PROGRESS — E.0 diagnosis complete
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

### 13/06/26 — Claude (Code, Sonnet 4.6) — E.0: Read-first diagnosis

Completed full read-first pass of Header.astro, BaseLayout.astro, and all 4 astro.config.mjs files. Diagnosis documented above.

**Files read:**
- `packages/ui/src/components/Header.astro`
- `packages/ui/src/layouts/BaseLayout.astro`
- `apps/{ie,uk,es,pt}/astro.config.mjs`

---

## Done criteria

- [ ] E.1 — `unlockBodyScroll` uses `body.style.top`-derived `restoreY` (or confirmed not needed after live test)
- [ ] E.2 — `.desktop-nav .nav-link[aria-current="page"]` CSS added, tested at 1440px light + dark
- [ ] E.3 — `prefetch: { prefetchAll: true, defaultStrategy: 'viewport' }` in all 4 market configs
- [ ] Build green on all 4 markets after E.2 + E.3 changes
- [ ] `roadmap/navigation-audit.md` close-out section written

---

## Post-ship summary

_To be filled after SHIPPED._
