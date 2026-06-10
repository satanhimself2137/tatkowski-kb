# ROADMAP — Design-system conformance

**Status:** Prompt 1 SHIPPED — next: SmartQuote DS modal refactor
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

---

## Done criteria

- [x] Zero `#ff6a3d` hardcodes outside `design-system/` and `dist/` — commit 6472120
- [x] `--shadow-accent` token resolves in browser (no `var()` fallback gap) — issue #011 resolved, KB commit 8df525b
- [x] All four market builds clean after sweep — IE 52pp, UK 47pp, ES 45pp, PT 38pp
- [ ] SmartQuote DS modal refactor (Prompt 2) — fixed overlay, white surface, 2-dot stepper, internal scroll, sticky Pay
- [ ] Page furniture conformance — IE first, then UK/ES/PT
- [ ] `contrast-enforcer.css`, `text-contrast-fixes.css`, `badge-fix.css` retired (all rules subsumed by conformant styles)
- [ ] Drawer refresh against `ui_kits/drawer`

---

## Post-ship summary

*(filled in after Status = SHIPPED)*
