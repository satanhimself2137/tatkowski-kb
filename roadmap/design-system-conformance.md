# ROADMAP — Design-system conformance

**Status:** IN PROGRESS — Prompt 1 token foundation
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

Removed `--accent: #ff6a3d;` override from `global.css` legacy `:root` block (~L1098). Ran encoding-safe PowerShell sweep across `packages/ui/src` and `apps/{ie,uk,es,pt}/src` replacing `#ff6a3d` → `#ff6a1a`, `rgba(255,106,61` → `rgba(255,106,26`, `rgba(255, 106, 61` → `rgba(255, 106, 26`, gradient end-stops `#ff8540`/`#ff8555` → `#ff8c61`. Verified `--shadow-accent` resolves via DS import chain; marked issue #011 resolved. All four market builds clean. Grep gate passed (zero `ff6a3d` outside `design-system/` and `dist/`).

**Files touched:** see commit diff — packages/ui/src/styles/*.css, packages/ui/src/components/*.astro, apps/{ie,uk,es,pt}/src/pages/*.astro

**Commits:**
- *(to be filled after push)*

---

## Done criteria

- [ ] Zero `#ff6a3d` hardcodes outside `design-system/` and `dist/`
- [ ] `--shadow-accent` token resolves in browser (no `var()` fallback gap)
- [ ] All four market builds clean after sweep
- [ ] SmartQuote DS modal refactor (Prompt 2) — fixed overlay, white surface, 2-dot stepper, internal scroll, sticky Pay
- [ ] Page furniture conformance — IE first, then UK/ES/PT
- [ ] `contrast-enforcer.css`, `text-contrast-fixes.css`, `badge-fix.css` retired (all rules subsumed by conformant styles)
- [ ] Drawer refresh against `ui_kits/drawer`

---

## Post-ship summary

*(filled in after Status = SHIPPED)*
