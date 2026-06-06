**Workstream:** baking-studio
**Status:** IN PROGRESS — keyline design shipped and approved on paper test; awaiting wiring into prod order flow (admin upload → bake → drawer download)

---

## Scope

Phase 1: Headless bake engine in `workers/payment-worker` (pdf-lib + fontkit + QR).
- `/api/admin-bake-document` endpoint — admin uploads translated PDF, worker brands every page, saves to R2
- Multi-domain drawer URLs in `apps/sales/functions/api/admin-order-upload.js`
- No git branching; all work on main; no prod traffic until Maciej approves visual output

Phase 2: Wire into production order flow — admin upload triggers bake, baked PDF surfaced in drawer for client download.

---

## Decisions

- pdf-lib + vector primitives only (drawSvgPath / drawLine / drawText / drawImage / drawCircle)
- Roboto Regular + Roboto Mono via @pdf-lib/fontkit, WOFF latin-400-normal subset from @fontsource
- QR: qrcode.create() (pure-JS, no canvas) — Workers-compatible
- Logo: full-colour PNG lockup embedded as base64 constant
- Font format: WOFF (latin subset, ~21KB + ~16KB) — TTF downloads from GitHub were HTML, not binary
- Fit-scale: portrait capped at MAX_SCALE=0.85; landscape auto-shrinks
- Colour split: NAVY (#0f172a slate-900) for body type; KEYLINE_NAVY (#1e293b slate-800) for thin keylines — slate-900 reads as black at 1.25pt, slate-800 reads as dark navy at the same weight
- Pricing / scope / auth: never touched

---

## Open questions

_(none)_

---

## Build log

### 06/06/26 ~18:00 — Agent — keyline tweaks finalised, prod deploy cd9b9030

Finalised line/dot values after paper test: keyline 1.25pt KEYLINE_NAVY (#1e293b slate-800), dot 3pt BRAND_ORANGE. Previous deploy (b1fc1f90) used 1.5pt NAVY and 2pt dot — too heavy on print. Added KEYLINE_NAVY constant separate from NAVY: slate-900 reads black at 1.25pt hairline; slate-800 retains visible navy hue at that weight. Final worker version: cd9b9030.

**Files touched:**
- workers/payment-worker/src/bake.ts (KEYLINE_PT 1.5→1.25, DOT_R_PT 2→3, added KEYLINE_NAVY)

**Commits:**
- cd9b9030 — bake.ts: finalise keyline weight (1.25pt slate-800) + dot size (3pt orange)

---

### 06/06/26 ~17:30 — Agent — keyline-only design (option C) initial deploy b1fc1f90

Replaced inset-card navy-fill geometry with two thin navy keylines + orange dot.
Top: colour logo (13mm) centred above a 1.5pt navy keyline, SIDE_INSET=15mm from sides, BRAND_ORANGE filled circle (r=2pt) at keyline centre.
Bottom: matching keyline above footer content. Footer: company text (NAVY) left, stacked validate URL + order ref (BAND_URL/BAND_REF, RobotoMono) centred, QR + "Scan to Verify" (NAVY) right.
Added `validateHostFor()` helper for market-specific validation subdomains (validate.tatkowski.{com,co.uk,es,pt}).
QR now encodes full market URL: `https://${validateHostFor(opts.market)}/${opts.ref}`.
WOFF fonts (Roboto + RobotoMono, latin-400 from @fontsource) confirmed working — fonts.ts regenerated from woff files (29KB + 21KB base64).
TS: 21 pre-existing errors, zero in bake.ts.
Initial deploy: Version b1fc1f90, gzip 958 KiB. Smoke bakes BC2 + CDM HTTP 200.

**Files touched:**
- workers/payment-worker/src/bake.ts
- workers/payment-worker/src/assets/fonts.ts (regenerated from WOFF)
- scripts/bundle-fonts.mjs (updated to read .woff)
- apps/ie/public/fonts/Roboto-Regular.woff (new, @fontsource latin-400)
- apps/ie/public/fonts/RobotoMono-Regular.woff (new, @fontsource latin-400)

**Commits:**
- 2c03d4a — bake.ts: keyline-only design (option C) — two navy keylines + orange dot, stacked URL+ref footer, validateHostFor helper, WOFF fonts

---

### 06/06/26 ~16:15 — Agent — inset card design (option B) — superseded

Navy inset-card panels (12mm inset, all-4-corner rounding, 6pt radius, orange inner-edge stroke).
Header: single card 20mm tall, logo centred.
Footer: two separate cards — left (company text + ref), right (QR + label), PANEL_GAP=12mm between.
Smoke bakes passed (HTTP 200, Version 909c8c61).
Superseded by Maciej request for keyline-only (option C) same session — not committed as final.

---

### 06/06/26 ~09:00 — Agent — Phase 1 bake engine + WOFF font fix

Initial Phase 1 commit (4752ee5): bake engine, logo.ts, /api/admin-bake-document endpoint, drawer multi-domain in admin-order-upload.js.
Font issue: GitHub TTF downloads were HTML (curl served preview pages). Fixed by switching to @fontsource WOFF latin-400 subset — fonts.ts regenerated (50KB base64 total vs 800KB corrupt HTML before).
Band geometry iterated through: flush-edge inner-rounded tab → inset card → keyline-only.

---

## Lessons learned

### R2 cache trap — same key returns stale bytes

Re-baking to the same R2 key returns stale bytes despite successful `put` and new deploy version. Three deploys with different code produced byte-identical PDFs. Spotted only after ~10 wasted cycles. Convention: smoke-test source filenames carry a version suffix (`_vHHMM.pdf`) so the R2 key is unique per iteration. Never reuse a filename across iterations within a session.

### GitHub raw URL trap — HTML disguised as binary

`https://github.com/.../raw/.../file.ttf` serves an HTML preview page, not the binary. The HTML was ~307KB (plausible size) and lacked an `fvar` table (so the variable-font check passed), but the magic bytes were `0A 0A 0A 0A` (HTML newlines), not `00 01 00 00` (TTF). pdf-lib `embedFont` is lazy so the failure surfaced only at runtime as "Unknown font format". Fix: switched to `@fontsource/roboto` + `@fontsource/roboto-mono` npm packages — ship real binary WOFF in node_modules. Convention: when fetching binary assets, validate magic bytes before bundling. For fonts: `00 01 00 00` (TTF), `74 72 75 65` (true), `4F 54 54 4F` (OTTO), `77 4F 46 46` (wOFF), `77 4F 46 32` (wOF2). Only safe GitHub URL pattern for binaries is `raw.githubusercontent.com/...`, not `github.com/.../raw/...`.