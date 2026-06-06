# ROADMAP — Document-baking studio + in-browser viewer

**Status:** IN PROGRESS — Phase 1 shipped, smoke test pending
**Owner:** Maciej
**Last update:** 06/06/26 by Claude

---

## Scope

Build the missing operator-side document studio inside SalesManager. Operator opens a paid order, attaches translator's returned PDF(s), the studio bakes brand header + footer + QR into every page (smart-scale to fit), saves to R2, and fires the existing delivery pipeline. Also supports a standalone "manual intake" entry for clients who reach us via WhatsApp / in person — gating piece for WhatsApp AI intake.

**In:**
- Bake-engine API endpoint that takes 1+ PDFs and returns 1+ baked PDFs
- Per-page processing: scale page content to ~85% if ink detected in top 20mm or bottom 20mm bands; overlay otherwise
- Header overlay: company logo (tatkowski_INTERPRETING_AND_REC.png) centered, top 20mm band
- Footer overlay: company strip (CRO no. + domain) on left, QR code (links to `validate.tatkowski.com/{ref}`) on right, bottom 20mm band
- QR code generation in Worker (qrcode npm package, embedded as PNG into pdf-lib)
- DOCX viewer (client-side mammoth.js) — reference-only display for operator if they want to see the source. Bake source is PDF, never DOCX.
- Studio UI in SalesManager: "Bake" action on Paid / In Progress order cards. Modal with source preview (left), upload translator PDFs (right), bake preview, confirm-and-deliver
- Standalone "Manual intake" route: `/intake/manual` — creates order in ORDERS_KV with `source: 'manual'`, generates ref, drops into kanban
- R2 storage: baked output at `orders/{ref}/baked-{originalfilename}.pdf`
- Wire bake completion into existing admin-order-upload delivery pipeline (WA + email triggers stay as-is)

**Out:**
- Certification statement page (translator already adds on their pages)
- Signature embedding (translator already signs on their pages)
- Translation work itself (still Fiverr)
- Multi-language certificate text (English brand frame only for v1)
- Versioning / revisions of baked docs (overwrite is fine)
- Mobile baking UX (desktop-only studio; mobile kanban stays as-is)
- Bulk baking (one order at a time)

---

## Decisions

- **06/06/26 — Bake source is translator's PDF, DOCX is reference-only** — translators always return DOCX + PDF per Maciej's brief; the PDF is what we bake into. Mammoth.js client-side is enough for the DOCX viewer (low-fidelity is acceptable for reference). High fidelity guaranteed because we bake into the ready PDF. Decided by Maciej 06/06/26.
- **06/06/26 — Frame approach: inline header + footer with smart-scale (Option B)** — no extra wrapper pages. Every page gets a 20mm header (logo) + 20mm footer (QR + company strip). If content present in either band, scale page content to ~85% to make room. Decided by Maciej 06/06/26.
- **06/06/26 — Scaling: always anchor scaled content in the content band (20-277mm)** — preserves aspect ratio, centred horizontally, top of scaled content at 20mm. Avoids partial overlaps.
- **06/06/26 — No cert/signature baking** — translator includes Statement of Accuracy + date + signature on their own pages. We do not bake these. Decided by Maciej 06/06/26.
- **06/06/26 — Standalone "manual intake" creates a kanban order with `source: 'manual'`** — flows through normal stages. Same flow will later serve `source: 'whatsapp_ai'`. Decided by Maciej 06/06/26.
- **06/06/26 — Always-scale to 85% on every page, no detection** — simpler, faster, visually near-identical. Quality assessed during test, detection added v1.5 if needed. Decided by Maciej 06/06/26.
- **06/06/26 — Logo bundled in worker** — single deploy unit, no fetch latency. Decided by Maciej 06/06/26.
- **06/06/26 — Footer text per market** — `Tatkowski Interpreting & Recruitment Limited · CRO 803790 · {market-domain}`. Domain swaps by `order.market`: tatkowski.com (IE) / .co.uk (UK) / .es (ES) / .pt (PT). CRO stays Irish across all (one legal entity). No market-specific legal text — translator handles cert language on their own pages. Decided by Maciej 06/06/26.
- **06/06/26 — Drawer multi-domain entry points** — magic-link drawer served on `drawer.tatkowski.com`, `drawer.tatkowski.co.uk`, `drawer.tatkowski.es`, `drawer.tatkowski.pt`. `admin-order-upload.js` picks subdomain by `order.market`. Same Pages project + custom domains, no new deploy. Validation stays single-domain (`validate.tatkowski.com`) — third-party trust anchor. Decided by Maciej 06/06/26.
- **06/06/26 — Drawer stays English-only for v1** — simple universal vocabulary, localisation deferred to v1.x if PT/ES retention drops. Decided by Maciej 06/06/26.
- **06/06/26 — Manual intake: operator chooses starting status** — radio between Quoted (operator generates Revolut link after) and Paid (in-person / cash already collected). Decided by Maciej 06/06/26.

---

## Open questions

[All Phase-1 questions resolved 06/06/26. Re-open if testing surfaces issues.]

---

## Build log

### 06/06/26 — Claude (via Copilot/Sonnet 4.6) — Phase 1: bake engine + drawer multi-domain

Shipped the full Phase 1 bake engine. New `bake.ts` module in `workers/payment-worker/src/` exports `drawerHostFor`, `footerDomainFor`, and `bakeDocument`. The bake function loads a source PDF with pdf-lib, embeds each page as a form XObject scaled to 85% (always-scale, no detection — locked decision), draws 20mm header band (logo centred) and 20mm footer band (company strip + per-market domain + QR code). QR uses `qrcode.create()` vector approach instead of `toBuffer()` because `canvas` native addon is unavailable in Cloudflare Workers; result is vector-clean and correct. Brand orange #ff6a1a accent lines between bands and content. Added `POST /api/admin-bake-document` to payment-worker with KV session auth + ADMIN_TOKEN fallback, multipart input, per-order market lookup, R2 write at `orders/{ref}/baked-{filename}.pdf`. Updated `admin-order-upload.js` with `drawerHostFor()` helper — drawer URL and magic-link URL now pick the correct market subdomain (drawer.tatkowski.co.uk, drawer.tatkowski.es, drawer.tatkowski.pt) instead of hardcoded tatkowski.com. Logo bundled from `apps/ie/public/tatkowski INTERPRETING AND REC.png` (filename has spaces, not underscores — KB spec was wrong but Copilot found it via glob).

Preemptive add: `sales.tatkowski.com` added to ALLOWED_ORIGINS in payment-worker for Phase 2 (UI calls bake endpoint from SalesManager). Fine.

TypeScript: 23 → 21 pre-existing errors after fix. Copilot introduced 2 `instanceof File` errors (same pattern as existing line 205), fixed with `typeof` guard. Zero new errors from Phase 1 work. Pre-existing errors NOT cleaned up (out of Phase 1 scope) — flag for separate cleanup pass.

**Files touched:**
- workers/payment-worker/src/bake.ts (created, 8.4KB)
- workers/payment-worker/src/assets/logo.ts (generated, 166KB base64)
- workers/payment-worker/src/index.ts (CORS + Env + auth helper + bake endpoint + route)
- workers/payment-worker/package.json (pdf-lib, qrcode, @types/qrcode)
- apps/sales/functions/api/admin-order-upload.js (drawerHostFor + URL rewiring)
- scripts/bundle-logo.mjs (created — logo regeneration utility)

**Commits:**
- 4752ee5 — feat(baking): Phase 1 -- bake engine + drawer multi-domain wiring

**Manual steps still required (Maciej):**
- Add custom domains `drawer.tatkowski.co.uk`, `drawer.tatkowski.es`, `drawer.tatkowski.pt` to drawer Cloudflare Pages project + DNS records. Code is in place; domains don't resolve until done.
- Cleanup task (separate): 21 pre-existing TS errors in payment-worker (`instanceof File` pattern lines 204/206/299/317/622-813/1318 + webpush.ts). Not Phase 1's scope but should be picked up.
- Cleanup task: `apps/sales/fix.js` scratch file causes Astro check noise. Delete if not needed.

**Next:** Smoke test bake engine with a real translated PDF (curl command in Phase 1 plan above). Phase 2 studio UI proceeds once smoke test passes.

---

## Phase plan

**Phase 1 — Bake engine (headless API) + drawer multi-domain wiring**
- Add deps to `workers/payment-worker/package.json`: `pdf-lib`, `qrcode`
- Bundle logo PNG into worker (`workers/payment-worker/src/assets/logo.ts` exporting base64 or Uint8Array)
- New endpoint `POST /api/admin-bake-document` on payment-worker
- Accepts: order ref + uploaded PDF file(s) (multipart)
- Reads `order.market` from KV → picks domain for footer
- For each page: scale content to 85% (centred, top-anchored at 20mm), overlay header band (logo) + footer band (CRO + market domain + QR)
- QR encodes `https://validate.tatkowski.com/{ref}` (PNG embed via qrcode → pdf-lib)
- Output saved to R2 at `orders/{ref}/baked-{originalfilename}.pdf`
- Returns: array of baked file keys
- Update `apps/sales/functions/api/admin-order-upload.js`: drawer subdomain picker by `order.market` (helper: `drawerHostFor(market)` → tatkowski.com/.co.uk/.es/.pt)
- Manual operator steps (not Phase 1 code, list for Maciej): Cloudflare Pages → drawer project → add custom domains `drawer.tatkowski.co.uk`, `drawer.tatkowski.es`, `drawer.tatkowski.pt` + DNS records
- Tested via curl with a sample translator PDF + a fake order ref
- No UI yet

**Phase 2 — Studio UI in SalesManager**
- "Bake" button on Paid + In Progress kanban cards
- Modal: source PDF preview (pdf-js or iframe) on left, upload translator PDFs on right, "Bake & Preview" button → renders baked output, "Confirm & Deliver" button
- On confirm: bake-complete event triggers existing admin-order-upload delivery pipeline (set fileKey, mark delivered, fire WA/email)
- Desktop only — modal hidden under 1024px

**Phase 3 — Manual intake route**
- New page `/intake/manual` in SalesManager
- Form: source lang, target lang, doc type, client name, client email or phone, attach source PDF/image
- Creates order in ORDERS_KV with `source: 'manual'`, generated ref following existing convention
- Drops into kanban at operator-chosen starting status

**Phase 4 — DOCX viewer (reference only)**
- Mammoth.js bundled client-side, lazy-loaded
- "View DOCX" link on order card if `sourceDocxFileKey` present
- Renders to HTML in a side panel

---

## Done criteria

- [ ] Bake engine produces a baked PDF from a translator-supplied PDF with header + footer + QR on every page
- [ ] 85% scaling triggers correctly (or always-scale if that's the locked decision)
- [ ] QR scans to `validate.tatkowski.com/{ref}` and resolves correctly
- [ ] Studio UI opens on a real order, previews source, accepts upload, previews bake, confirms delivery
- [ ] Standalone manual intake creates a working order in kanban
- [ ] Existing delivery pipeline (WA + email) fires correctly post-bake
- [ ] DOCX reference viewer works on a Vovka sample DOCX
- [ ] TypeScript clean across apps/sales and workers/payment-worker
- [ ] Screenshots: 1440px studio modal (desktop), end-to-end bake of a real test order
- [ ] Tested end-to-end on one real order (suggest: re-bake of Antkiewicz PL→EN driving licence)

---

## Post-ship summary

[To be filled when Status = SHIPPED.]
