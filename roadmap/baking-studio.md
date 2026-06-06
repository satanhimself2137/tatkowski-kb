# ROADMAP — Document-baking studio + in-browser viewer

**Status:** NOT STARTED — Phase 1 ready to start
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
- **06/06/26 — File-count agnostic** — translator may return 1 PDF or 5 PDFs per job. Studio bakes each independently and stores all under the order ref. Decided by Maciej 06/06/26.

---

## Open questions

- [ ] **Whitespace detection: implement, or always scale?** — Detecting ink in top/bottom 20mm bands requires rasterising each page to a small thumbnail and counting non-white pixels (sharp in worker is fine). Alternative: always scale to 85% — simpler, faster, visually near-identical for empty bands. Recommend always-scale for v1, add detection if visual QA flags it. Maciej to confirm.
- [ ] **Logo source for bake worker** — bundled in worker (smaller, single deploy) or fetched from R2 each bake (lets us swap without redeploy). Recommend bundled for v1.
- [ ] **Footer text exact wording** — proposed: `Tatkowski Interpreting & Recruitment Limited · CRO 803790 · tatkowski.com` on left, QR on right. Confirm or adjust.
- [ ] **Manual intake: default starting status** — `quoted` (operator quotes then sends Revolut link) or `paid` (operator marks paid for in-person/cash before baking)? Recommend operator chooses at intake.

---

## Build log

[Empty — Phase 1 prompt pending.]

---

## Phase plan

**Phase 1 — Bake engine (headless API)**
- New endpoint `/api/admin-bake-document` on payment-worker (has pdf-lib + sharp already)
- Accepts: order ref + uploaded PDF file(s) (multipart)
- For each page: scale 85%, overlay header band (logo) + footer band (QR + text)
- QR encodes `https://validate.tatkowski.com/{ref}`
- Output saved to R2 at `orders/{ref}/baked-{originalfilename}.pdf`
- Returns: array of baked file keys
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
