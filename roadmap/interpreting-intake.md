# ROADMAP — Interpreting intake widget

**Status:** NOT STARTED — queued behind baking studio
**Owner:** Maciej
**Last update:** 06/06/26 by Claude

---

## Scope

Build the SmartQuote equivalent for the lead product. Currently interpreting enquiries arrive as freeform WhatsApp messages or B2B emails and depend on manual reply. This widget gives a structured intake — public-facing form on the four market sites + internal "log a B2B lead" form inside SalesManager. Output: a structured interpreting order in ORDERS_KV that flows through the same Quoted → Paid → In Progress → Delivered kanban.

**In:**
- Public widget (apps/ie, uk, es, pt) on /book-interpreter/ or equivalent route per market — already exists as a route, fix and complete it
- Fields: language pair, service type (in-person/phone/video), date + time, duration estimate, location (if in-person), client name, client email, client phone (+WA checkbox), client type (B2C / B2B), B2B-only: company name, PO ref optional
- Quote logic: individual per job (per KB section 3 pricing principle) — operator quotes manually after intake, no auto-quote (interpreter cost varies too much)
- Internal SalesManager "log a B2B lead" form — same fields, plus an interpreter-assignment dropdown from the contact pool (Olga, Marius, Dominykas, Diana, etc.)
- Order ref convention: `TIR-{market}-INT-YYYY-{seq}` (mirrors translation `TIR-{market}-YYYY-{seq}` pattern)
- Kanban integration: interpreting orders appear in OrdersBoard with a visual flag (different colour or icon) so they don't get confused with translation jobs
- B2C: Revolut payment link generated and sent after operator quotes
- B2B: invoice flag set on order, deferred to B2B invoicing workstream — for now operator handles invoicing manually
- Confirmation email to client on intake submission

**Out:**
- Auto-quoting (deferred — too much cost variance)
- Auto-assignment to interpreters (manual for now; pool too small)
- Calendar integration (deferred — operator manually checks Olga's WA)
- Recurring/standing-order support (out for v1)
- Interpreter-side acceptance flow (operator messages them on WA as today)

---

## Decisions

- **06/06/26 — Manual quote, not auto-quote** — interpreter cost varies per language/distance/duration/contractor; auto-quote would either be wrong or have to be conservative enough to lose deals. Operator quotes after intake. Decided by Maciej.
- **06/06/26 — Build before Chatwoot** — interpreting is lead product + growth engine; intake is the conversion lever. Chatwoot is plumbing for WA AI, not blocking for intake widget itself. Decided by Maciej 06/06/26 (after discussion).
- **06/06/26 — Same OrdersBoard, visual flag** — don't fork the kanban. Interpreting orders flow through same stages with a marker. Decided by Claude during scope (Maciej to confirm).

---

## Open questions

- [ ] **B2C interpreting payment timing: deposit on booking, or pay-after-job?** — Currently translation = pay-upfront. Interpreting bookings might lose B2C clients if asked to pay days before. Options: (a) pay-on-confirmation (standard), (b) 50% deposit + balance day-of, (c) full pay-after. Maciej to decide.
- [ ] **B2B PO collection: required or optional?** — Some B2B clients (Fyffes) have POs, some don't. Default to optional with a "we can issue without PO" note?
- [ ] **Location field for in-person: free text or Google Places autocomplete?** — Autocomplete is nicer but adds JS weight. Free text is fine if operator vets it.
- [ ] **/book-interpreter/ current state across 4 markets** — needs audit before scope locks. Is it the same component on all 4 sites, or four separate? (Affects build effort.)
- [ ] **Localisation: does PT/ES intake form ship localised or in English?** — Per KB, PT/ES localised service pages are an open issue. Intake form should match the wider localisation push.

---

## Build log

[Empty — work has not started.]

---

## Done criteria

- [ ] Public intake form live on all 4 market sites
- [ ] Internal "log B2B lead" form live in SalesManager
- [ ] Orders flow into ORDERS_KV with proper ref convention
- [ ] Interpreting orders visible and distinguishable in OrdersBoard
- [ ] Confirmation email fires on submission
- [ ] B2C: operator can generate + send Revolut quote from inside the order
- [ ] B2B: invoice-flagged order routes through correct path
- [ ] TypeScript clean
- [ ] Screenshots at 390px + 1440px for all 4 markets
- [ ] One end-to-end live test (probably a David-routed PT enquiry or a Maciej-routed IE one)

---

## Post-ship summary

[To be filled when Status = SHIPPED.]
