# ROADMAP — Document-baking studio + in-browser viewer

**Status:** NOT STARTED
**Owner:** Maciej
**Last update:** 06/06/26 by Claude

---

## Scope

Build the missing operator-side document studio inside SalesManager. Operator opens a paid order, sees the source doc, drops in the translator's DOCX/PDF, places QR + logo + signature, generates the final certified PDF, and ships it via the existing delivery pipeline. Also supports a standalone "treat this document" entry not tied to a SmartQuote order — gating piece for WhatsApp AI intake.

**In:**
- In-browser multi-format viewer (PDF, JPG, PNG, DOCX) — source-doc panel + finished-doc preview panel
- Translator-output ingestion: accept DOCX (Vovka/Emerson/Hassan format) + PDF — convert DOCX → PDF in worker
- Logo overlay (tatkowski_INTERPRETING_AND_REC.png) — centred, ~0.3in from top, 24% scale, white-background removed
- Signature overlay (tatkowski_signature_podpis.png, processed per memory spec — 50mm wide, ratio ~3.16, 300dpi)
- QR code generation per order ref → validate.tatkowski.com/{ref}
- Drag-and-drop QR placement editor on the rendered PDF (operator picks empty space)
- pdf-lib pipeline: burn QR + logo + signature into final PDF, save to R2 under `orders/{ref}/`
- Certification statement page (page 2) with embedded signature
- Standalone entry: "Treat this document" route — upload a doc without a SmartQuote order, generate ref, bake, deliver
- Wire upload-finished into OrdersBoard card action (currently endpoint dangling)
- Document type / file naming convention from memory: `Certified Translation - [Source Lang] to [Target Lang] - [Document Type] - [Surname Firstname].pdf`

**Out:**
- Translation itself (still done by translator on Fiverr)
- Multi-language certificate templates (English certification statement only for now)
- Versioning / revisions of baked docs (overwrite is fine for v1)
- Bulk baking (one doc at a time)
- Mobile baking UX — desktop-only studio (mobile-optimised kanban stays, studio modal opens on desktop only)

---

## Decisions

- **06/06/26 — Reuse existing R2 keys and ORDERS_KV schema** — `orders/{ref}/source/` already used by upload-source for SmartQuote orders; baked output goes to `orders/{ref}/{filename}.pdf` (existing pattern in admin-order-upload). No schema changes needed. Decided by Maciej (implicit — keep current architecture).
- **06/06/26 — pdf-lib over PDFKit** — pdf-lib runs in Workers (PDFKit needs Node). Already in payment-worker dependency tree if needed. Decided by Claude during scope.
- **06/06/26 — Studio lives in SalesManager (apps/sales), not a separate app** — single operating cockpit per KB section 16. Baking studio is a modal/route inside SalesManager, accessed from an order card. Decided by Maciej (KB-locked).
- **06/06/26 — Standalone entry first-class, not afterthought** — "Treat this document" route is the WA AI integration point. Must exist by ship time, not deferred. Decided by Maciej (KB section 16 explicit requirement).

---

## Open questions

- [ ] **DOCX rendering: convert to PDF server-side or render in-browser?** — Server-side via mammoth.js → puppeteer-style render in Worker is heavy. Client-side via mammoth + html2pdf is lighter but quality varies. Decision affects how translator DOCX previews in the studio. Maciej to decide based on quality test on a Vovka DOCX sample.
- [ ] **QR placement: free-drag anywhere, or constrained to detected empty regions?** — Free-drag is simpler to build. Constrained needs whitespace detection (LLaVA can already see the doc). Recommend free-drag for v1, smart-snap as v1.5.
- [ ] **Signature: one default signature, or operator picks per job?** — KB has tatkowski_signature_podpis.png as the one. Confirm no per-translator signatures needed.
- [ ] **Page 2 certification statement: hard-coded template, or editable per job?** — Recommend hard-coded with order-ref + date + languages auto-filled. Editable adds error surface.
- [ ] **Standalone "treat this document" entry: which fields are mandatory?** — Source lang, target lang, doc type, client name minimum? Client email/phone optional (WA AI will fill later). Decide before building.

---

## Build log

[Empty — work has not started.]

---

## Done criteria

- [ ] Operator can open a paid order in SalesManager and see source doc rendered in-browser (PDF + image formats)
- [ ] Operator can upload translator DOCX or PDF and see it rendered side-by-side with source
- [ ] QR code for `validate.tatkowski.com/{ref}` generated automatically per order
- [ ] Operator drags QR to empty area on the translated doc, position persists
- [ ] Logo + signature overlaid per KB spec (position, size, transparency)
- [ ] Final baked PDF saved to R2 with correct naming convention
- [ ] Existing delivery pipeline (WA + email via admin-order-upload's downstream) fires correctly on bake-complete
- [ ] Standalone "treat this document" route works without a parent SmartQuote order
- [ ] TypeScript clean
- [ ] Screenshot at 1440px (desktop primary) shows full studio working
- [ ] Tested end-to-end on one real order (e.g. Velnichuk once names confirmed, or a re-bake of Antkiewicz)

---

## Post-ship summary

[To be filled when Status = SHIPPED.]
