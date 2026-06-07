# ROADMAP — Payments & customer journey

**Status:** IN PROGRESS — Phase 0 (Claude Design pass)
**Owner:** Maciej
**Last update:** 07/06/26 by Claude

---

## Scope

The end-to-end paid certified-translation customer experience, from SmartQuote upload through delivery. Step 1 (Revolut webhook reliability) shipped 07/06/26. Remaining scope: redesign the post-paid customer journey against current production reality (drawer state bugs, wrong email template wired, multi-market domains), then implement against locked specs.

**In:**
- SmartQuote flow restructure: 2 steps (upload+analysis → review+details+pay) instead of current 3
- Customer-facing emails: paid, delivered, sourcing, delay, action-required, refund — all aligned to refreshed `emails.jsx` spec
- Customer drawer states D1–D7 — state machine bugs fixed, aligned to refreshed `drawer-states.jsx`
- Admin transitions in SalesManager that drive the above (paid→in_progress, in_progress→delivered, →needs_sourcing, →action_required, →refunded)
- Resend sender split: `orders@` / `auth@` / `salesmanager@` / `contact@` on the single verified `tatkowski.com` domain
- Dynamic ETA by page count (1-3 pages = 24h, 4-6 = 36h, 7-10 = 48h, 11+ = manual confirmation)
- T&Cs delivery clause: reasonable endeavours + communication of delays + refund reserved for impossibility, not delay
- Per-market domain support: drawer.tatkowski.{com|co.uk|pt|es} and sales.tatkowski.{com|co.uk|pt|es}
- Marketing copy update across 4 market sites: no "24h guaranteed" claims

**Out:**
- B2B invoicing mode (separate workstream, DEFERRED in INDEX)
- Interpreting intake widget (separate workstream, QUEUED)
- WhatsApp AI intake / Chatwoot (gated, separate workstreams)
- Review-request flow (matrix explicitly excludes from delivery moment)
- Quote-stage email + abandonment recovery (deferred — measure abandonment first)
- Translator network ops / availability management (separate future workstream)
- Multi-language email/drawer localisation (EN-only v1)

---

## Decisions

- **07/06/26 — Step 1 webhook fix shipped without a roadmap file.** Roadmap created retroactively. Going forward, no workstream code without a roadmap file (rule already in operating instructions).
- **07/06/26 — Customer Journey workstream renamed from "Step 2" to a multi-phase roadmap.** Original handoff framed Step 2 as a single "wire finishWebhook" task. Investigation revealed: wrong email template wired, drawer state bugs, multi-market domain assumptions baked in, and SmartQuote flow itself needs restructure. Decided to run a Claude Design pass (Phase 0) before any implementation. Decided by Maciej + Claude.
- **07/06/26 — Stay on Resend free tier, single domain (`tatkowski.com`).** Cashflow reason. Multi-domain verification deferred until intake widget ships and per-market sender becomes operationally valuable. Sender separation achieved via subaddresses (`orders@`, `auth@`, `salesmanager@`) on the single verified domain.
- **07/06/26 — Drop `quotes@` sender.** Abandonment recovery isn't a current flow; manual B2B quotes already work as human emails from `contact@`. Spin up `quotes@` only if/when abandonment recovery becomes a measured workstream.
- **07/06/26 — `Reply-To: contact@tatkowski.com` on transactional customer emails.** Standard pattern; customer replies route to the shared M365 mailbox where humans actually read. No BCC of outgoing sends — the customer's mail client quotes the original inline on reply, which is sufficient context.
- **07/06/26 — Dynamic ETA bands locked.** 1-3 pages = 24h, 4-6 = 36h, 7-10 = 48h, 11+ = manual confirmation. Replaces flat "24h" advertising. All 4 market sites and the design system must update accordingly.
- **07/06/26 — T&Cs delivery clause: refund reserved for impossibility, not delay.** Delays alone do not give rise to refund rights — only inability to deliver at all (no certified translator sourceable for the language pair). Protects against the 24h-and-5-min refund abuse vector. Matches the `EmailSourcing` flow in the existing design system.
- **07/06/26 — SmartQuote restructured to 2 steps.** Step 1: upload + analysis only (no fields). Step 2: combined document review + customer details (name + email; phone only on WhatsApp opt-in) + Pay button. Single mobile viewport, sticky Pay button if needed.
- **07/06/26 — Per-market subdomains for both drawer and SalesManager.** drawer.tatkowski.{com|co.uk|pt|es} for customer portal, sales.tatkowski.{com|co.uk|pt|es} for admin board. Customer-facing email CTA must derive correct drawer domain from order market.

---

## Open questions

- [ ] **SmartQuote abandonment rate today** — what % of customers who see a price never click Pay? Affects whether quote-stage email + recovery flow becomes a near-term workstream or stays deferred.
- [ ] **Drawer audit before email rewrite** — does `apps/drawer` currently render anything close to the D1–D7 spec, or is it a simpler model that needs full alignment? Determines scope of drawer phase.
- [ ] **WhatsApp customer mirror** — matrix says "if opted in"; no opt-in mechanism exists today. Either spec the opt-in in this workstream or mark as out-of-scope until intake widget adds it.
- [ ] **Sign-in code email sender** — where is it sent from today? Confirm location (`apps/drawer` or `apps/sales`) and update to `auth@tatkowski.com` as part of the sender-split work.
- [ ] **Per-market routing of internal SalesManager pings** — when an IE order pays vs. a UK order pays, does the team WhatsApp/email differ, or do all four market orders surface in the same internal inbox?

---

## Build log

### 07/06/26 — Claude — Phase 0 kickoff (planning)

Drafted scope, mapped current code reality against design system specs, identified gaps. Confirmed via code reading: customer paid email exists in `finishWebhook` but uses legacy green-gradient template (`sendCustomerConfirmationEmail` at line 1220 of `workers/payment-worker/src/index.ts`), not the calmer `EmailPaid` spec. CTA links to `sales.tatkowski.com/order/...` — probably wrong, should be per-market `drawer.tatkowski.{tld}/o/...`. Resend setup verified: 1 verified domain (`tatkowski.com`), 100% deliverability over last 30 days, well within free tier. Locked decisions on sender split, dynamic ETA, T&Cs framing, SmartQuote restructure, per-market subdomain split for drawer + sales. Drafted Claude Design brief for new chat to produce refreshed `matrix.jsx` / `emails.jsx` / `drawer-states.jsx` + new `DECISIONS.md` in `docs/Tatkowski Design System/deliverables/`. No code touched.

**Files touched (planning only, no commits):**
- (none — pure planning phase)

### 07/06/26 — Claude — Phase 1 (Step 1: Revolut webhook reliability) — SHIPPED

Three bugs in the webhook handler: parser reading event.type/order.id/metadata when Revolut sends event.event/order_id/merchant_order_ext_ref; HMAC signing bare body instead of v1.{ts}.{body}; create-order never sending merchant_order_data.reference. All fixed in commit 76fd238 (worker version 8841a752). wsk_ secret re-synced. Throwaway POST /api/admin/test-order added (6be53c2) for €1 smoke, then removed (cd74c43, deployment 8098c911) after verifying TIR-IE-2026-0028 paid via Revolut card checkout → ORDERS_KV order status flipped to paid at 2026-06-07T07:03:13Z, SalesManager rendered full timeline. issues_log #001 logged RESOLVED.

**Files touched:**
- workers/payment-worker/src/index.ts (webhook parser, HMAC sig, create-order reference, test endpoint added then removed)

**Commits:**
- 76fd238 — webhook parser + HMAC fix
- 6be53c2 — add /api/admin/test-order
- cd74c43 — remove /api/admin/test-order
- 6a46902 — issues_log update

---

## Done criteria

- [ ] Phase 0 — Claude Design pass complete: refreshed `matrix.jsx`, `emails.jsx`, `drawer-states.jsx`, plus new `DECISIONS.md` shipped to `docs/Tatkowski Design System/deliverables/`
- [ ] SmartQuote restructured to 2-step flow (upload+analysis → review+details+pay) across 4 market sites
- [ ] Marketing copy across 4 market sites updated — no "24h guaranteed" claims, dynamic ETA bands surfaced at quote
- [ ] T&Cs delivery clause shipped to all 4 market T&Cs pages
- [ ] Customer paid email matches refreshed `EmailPaid` spec; CTA points to correct per-market drawer domain
- [ ] Customer delivered email matches refreshed `EmailDelivered` spec
- [ ] Sourcing / delay / action-required / refund emails match refreshed specs
- [ ] Drawer states D1–D7 render correctly per refreshed spec — no concurrent "current" + "done" animations, no "delivered" rendering while "in progress" still animates
- [ ] SalesManager manual transitions work and fire exactly the side-effects in the refreshed matrix (no extras, no missing)
- [ ] Resend sender split live: `orders@` (with `Reply-To: contact@`), `auth@`, `salesmanager@` all wired correctly
- [ ] Per-market drawer subdomains live (`drawer.tatkowski.{com|co.uk|pt|es}`)
- [ ] Per-market SalesManager subdomains live (`sales.tatkowski.{com|co.uk|pt|es}`)
- [ ] Smoke test: a real €1-€5 paid order on each of the 4 markets renders correct drawer, correct email template, correct ETA, no state-machine glitches

---

## Post-ship summary

[Pending.]
