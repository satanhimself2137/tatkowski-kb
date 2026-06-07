# Issues & Gotchas Log

Append-only log of issues, workarounds, and gotchas across all areas -- technical, client, legal, ops, anything non-obvious worth recording so the next person (human or AI) doesn't burn time rediscovering it.

**Newest entries on top.** Resolved entries stay -- the trail is the value.

**Categories** emerge as we go. Use square brackets like `[TECH]`, `[CLIENT]`, `[LEGAL]`, `[OPS]`, `[FIN]`, `[HR]`, `[MKT]`, `[SEO]`. Add new ones freely -- no approval needed.

**Usage** (from anywhere with `gh` auth):

```powershell
# Search before troubleshooting
pwsh tools/issues.ps1 read -Search "wrangler"
pwsh tools/issues.ps1 read -Status open
pwsh tools/issues.ps1 read -Category TECH

# Log a new issue or gotcha
pwsh tools/issues.ps1 log -Category TECH -Title "short symptom-led title" `
  -Symptom "what was observed" -Context "where/when" -By Claude

# Mark resolved
pwsh tools/issues.ps1 resolve -Id 4 -Resolution "what fixed it" -By Maciej

# Bump recurrence counter when the same issue hits again
pwsh tools/issues.ps1 bump -Id 4
```

**Entry format** (auto-written -- don't hand-edit unless fixing typos):

```
## #001 [CATEGORY] Symptom-led title -- DD/MM/YY -- OPEN
- Logged by: Name
- Symptom: what was observed
- Context: where/when/what was happening
- Resolution: (open)
- Recurrence: 1
```

When resolved, the status flips to `RESOLVED` and the Resolution line is filled in. Entries are never deleted.

Separators are ASCII double-hyphen (`--`) by design so the tooling stays encoding-safe across PowerShell versions and shells.

---

<!-- ENTRIES BELOW (newest first) -->

## #011 [TECH] shadow-accent token missing from tokens.css -- 07/06/26 -- OPEN
- Logged by: Claude
- Symptom: DS spec (ui_kits/website/site.css) specifies `box-shadow: var(--shadow-accent)` for `.btn-primary`, but `--shadow-accent` is not defined in `packages/ui/src/styles/tokens.css` or `global.css`. Commit e76ae80 (07/06/26) kept the existing inline rgba shadow rather than reference an undefined var, so the DS spec is not fully applied.
- Context: Surfaced during Commit 2.5 button-gradient fix. Token should be added to tokens.css as part of a dedicated token-cleanup task alongside the known `--accent: #ff6a3d` override bug (~line 1098 of global.css).
- Resolution: (open)
- Recurrence: 1

## #010 [LEGAL] immigration-translation-ireland.astro:177 promises "full refund" for rejections — conflicts with T&Cs §11 -- 07/06/26 -- OPEN
- Logged by: Code
- Symptom: Line 177 of apps/ie/src/pages/immigration-translation-ireland.astro states "acceptance guaranteed for any rejection attributable to our work, or full refund". T&Cs §11 (live as of 07/06/26 across all 4 markets) reserves refund for impossibility — i.e. when we cannot source a qualified certified translator for the language pair. Rejections attributable to our error are addressed by the reissue clause ("we correct and reissue at no charge"), not refund. The marketing line promises an additional remedy that the T&Cs do not.
- Context: Surfaced during the ETA copy audit (todos/eta-copy-audit-20260607.md). Not fixed in the Tier A commit (d5c639c) — needs a marketing+legal copy decision separately. Either tighten the marketing line to "reissue free" only, or amend T&Cs §11 to add a "remedy for our error" path. Pure documentation in this entry; no code change.
- Resolution: (open)
- Recurrence: 1

## #009 [LEGAL] ES/PT terms.astro full localisation pending; PT has factual market bugs -- 07/06/26 -- OPEN
- Logged by: Claude
- Symptom: `apps/es/src/pages/terms.astro` and `apps/pt/src/pages/terms.astro` are entirely in English as of commit c2572b7 (reverted from the Frankenstein state left by 36541d1 where only §3 and §11 were translated). The full files need translation to Castilian Spanish and European Portuguese respectively, with legal review, before either market should be advertised as locally-compliant. Additionally, PT terms.astro carries factual bugs that must be fixed during localisation: §2 references GBP (should be EUR), §12 governs by the laws of England and Wales (should be Portuguese law), and §7 / late-payment clauses likely reference the UK Late Payment of Commercial Debts (Interest) Act 1998 — must be replaced with EU Directive 2011/7/EU.
- Context: PT/ES are not yet active markets (David runs PT B2B outreach but no transacting customers yet). Acceptable to keep English-only T&Cs in the interim, but should be resolved before any paid customer journey is published on those subdomains, and definitely before any GBP/English-law text reaches a Portuguese customer.
- Resolution: (open)
- Recurrence: 1

## #008 [TECH] SmartQuote → Revolut order-creation: ensure merchant_order_ext_ref always set -- 07/06/26 -- OPEN
- Logged by: Claude
- Symptom: After #005 fix, the payment-worker rejects ORDER_COMPLETED webhooks without a `TIR-` `merchant_order_ext_ref` (they go to operator notification instead of creating an order). If the SmartQuote → Revolut order-creation path ever fails to set the ref on an order, legitimate customer payments will route to "unattributed" alerts instead of paid orders.
- Context: The legacy auto-create branch (which previously masked this) was removed 07/06/26. Need to audit `handleCreateOrder` and the SmartQuote frontend to confirm `merchant_order_data: { reference: orderRef }` is sent on every Revolut order create. Add a regression test if feasible.
- Resolution: (open)
- Recurrence: 1

## #007 [TECH] payment-worker: RESEND_API_KEY not set in production secrets -- 07/06/26 -- OPEN
- Logged by: Claude
- Symptom: `wrangler secret list --name payment-worker` returns only `REVOLUT_SECRET_KEY`, `REVOLUT_WEBHOOK_SECRET`, and the VAPID keys. `RESEND_API_KEY` is missing, so `sendOrderConfirmationEmail` and `sendCustomerConfirmationEmail` silently no-op on every paid order (both guard with `if (!env.RESEND_API_KEY) return;`). Customers receive no payment-confirmation email today.
- Context: Resend setup locked 07/06/26 uses a single verified domain `tatkowski.com` on free tier with subaddress senders (`orders@`, `auth@`, `salesmanager@`). The API key from Resend has not been pushed to the payment-worker. Fix: `wrangler secret put RESEND_API_KEY --name payment-worker` once the live key is in hand.
- Resolution: (open)
- Recurrence: 1

## #006 [TECH] payment-worker ENVIRONMENT var is "development" in production -- 07/06/26 -- OPEN
- Logged by: Claude
- Symptom: `npx wrangler deploy --dry-run` on `workers/payment-worker` shows `Vars: ENVIRONMENT: "development"` despite the worker being the live production handler.
- Context: Cosmetic, no behavioural impact found in current code (no branches on `env.ENVIRONMENT`), but misleading and could bite future code that does branch on it. Set `[vars] ENVIRONMENT = "production"` in `wrangler.toml` and redeploy.
- Resolution: (open)
- Recurrence: 1

## #005 [TECH] Webhook auto-created ghost PAID order from refunded Revolut payment -- 07/06/26 -- RESOLVED
- Logged by: Maciej
- Symptom: TIR-IE-2026-0029 appeared in SalesManager as PAID (€44.99) with "Unknown" name/email/document and no source file. Note: "Auto-created via SmartQuote. Revolut Order ID: 6a24753c-b495-a265-b679-730cce659ac7". Maciej had refunded the underlying €44.99 payment the day before (Jun 6 8:27 PM); SalesManager had no knowledge of the refund.
- Context: Two independent bugs in `workers/payment-worker/src/index.ts handlePaymentWebhook`: (a) legacy auto-create branch fired on any `ORDER_COMPLETED` webhook whose `merchant_order_ext_ref` did not match an existing `TIR-` order, blindly creating a new PAID order from whatever Revolut API returned — including a real but unattributed €44.99 charge with no metadata; (b) handler only listened for `ORDER_COMPLETED`, so the matching `ORDER_REFUNDED` event from Jun 6 went unhandled and SalesManager never saw the refund. Today's retry of the original `ORDER_COMPLETED` (delivery presumably failed yesterday) created the ghost order.
- Resolution: `workers/payment-worker/src/index.ts` rewritten in commit `5af0ab0` (worker version `0f00de9e-a03b-49ad-a3fd-affee0d521a0`): (1) Legacy auto-create path removed entirely — unattributed `ORDER_COMPLETED` events now fire an operator notification instead of creating an order. (2) `ORDER_REFUNDED` handler added: fetches `refunded_amount` from Revolut API, writes `refundedAt` + `refundAmount` to the SM order; flips `status` to `refunded` only on full refund AND prior `paid` status (delivered orders keep their status, gain refund metadata). Notifies operator either way. (3) 500ms retry on TIR- lookup miss to absorb the race where webhook arrives before SM order is written. (4) Refund fallback scans `orders:index` (first 200) by `revolutOrderId` for orders missing TIR- ext_ref on the refund event. New `notifyOperatorPing` helper bypasses notif-prefs for critical alerts (refunds, unattributed payments). TIR-IE-2026-0029 archived by Maciej before deploy. Three follow-on issues flagged: #006 #007 #008.
- Recurrence: 1

## #004 [TECH] SmartQuote step 2.5 modal has giant empty space on mobile -- 06/06/26 -- RESOLVED
- Logged by: Maciej
- Symptom: On mobile (iOS Safari confirmed, likely all narrow viewports), the SmartQuote modal step 2.5 (Review — AI result + price, before payment) renders with a large blank vertical gap below the content. Cosmetic but breaks perceived quality at the moment of conversion.
- Context: `packages/ui/src/components/SmartQuoteForm.astro` around line 211. Pre-existing — carried over from earlier SmartQuote work. Surfaced again during Phase 2 baking-studio test on 06/06/26 when placing TIR-IE-2026-0027.
- Resolution: RESOLVED 07/06/26 by Claude -- Fixed in commit e76ae80 (07/06/26). Root cause: .sqf-root had overflow:hidden causing flex min-height:auto to resolve to 0, allowing content to clip instead of scroll. Fixed by mirroring mobile flex-containment chain to desktop — panel is now the scroll container. Dead JS refs to panelReview/panel3/reviewContinueBtn removed. iOS pay bar: bottom: env(safe-area-inset-bottom, 0). Max-height: 100dvh cap on shell.
- Recurrence: 1

## #003 [TECH] SalesManager notifications page fails on mobile -- service worker redirect rejected -- 06/06/26 -- OPEN
- Logged by: Maciej
- Symptom: On mobile (iOS Safari AND Android Chrome), opening notification history in SalesManager fails with: `Safari can't open the page. The error was: "Response served by service worker has redirections."` Same on Android. Page never loads.
- Context: SalesManager PWA at `sales.tatkowski.com/notifications`. The service worker is intercepting the request and returning a redirect (likely auth bounce to /login), which mobile browsers refuse to follow for SW-served responses. Per spec: SW-cached or SW-generated responses cannot include redirect status codes. Likely fix: bypass SW for auth-protected pages, or have SW serve a non-redirect response (e.g. 401 JSON with client-side login handoff).
- Resolution: (open)
- Recurrence: 1

## #002 [TECH] Revolut checkout window cannot be reopened once closed -- 06/06/26 -- OPEN
- Logged by: Maciej
- Symptom: When client closes the Revolut payment popup (intentionally or accidentally) before completing payment, there is no way back to the same checkout session. SalesManager shows the order as `awaiting_payment` but no Pay button anywhere lets the client resume — they would have to start over.
- Context: Surfaced during TIR-IE-2026-0027 test on 06/06/26. Likely fix: store the Revolut hosted checkout URL on the order at creation (`order.checkoutUrl`), expose a "Resume payment" link in (a) the quoted-stage email and (b) the SalesManager order detail panel until the order moves past `awaiting_payment`.
- Resolution: (open)
- Recurrence: 1

## #001 [TECH] Revolut webhook does not update KV after successful payment -- 06/06/26 -- RESOLVED
- Logged by: Maciej
- Symptom: Client pays in full via Revolut, payment shows as Completed in Revolut Business dashboard, but the order in `ORDERS_KV` stays at `status: awaiting_payment, paymentStatus: unpaid`. SalesManager shows order as unpaid. Webhook either never fires, never reaches the worker, or fails before the KV write.
- Context: Confirmed on TIR-IE-2026-0027 (€44.99) placed 06/06/26 19:26 — Revolut captured, KV never updated. Same on TIR-IE-2026-0026 (predecessor). Worker handler at `workers/payment-worker/src/index.ts:575` (`handlePaymentWebhook`); only acts on `ORDER_COMPLETED` (line 644) and signature-verifies via `REVOLUT_WEBHOOK_SECRET` (line 585). Three plausible causes: (a) Revolut webhook subscription URL/secret missing or wrong in Revolut Business → Developer settings; (b) signature verification failing silently; (c) Revolut sending an event type other than `ORDER_COMPLETED`. Diagnostic next step: `npx wrangler tail` on the worker and replay/place a fresh payment to capture the inbound request, OR check Revolut Business → Developer → Webhooks → recent deliveries for failed status codes. BLOCKER — every paid order needs manual KV update via SalesManager "mark paid" button until fixed.
- Resolution: Two independent bugs in `workers/payment-worker/src/index.ts handlePaymentWebhook`: (a) parser read `event.type` / `event.order.id` / `event.order.metadata.*` but Revolut Merchant API webhooks deliver `event.event` / `event.order_id` / `event.merchant_order_ext_ref`, so `event.type !== "ORDER_COMPLETED"` was always true and the handler returned 200 OK without touching KV; (b) signature verification HMAC-signed the bare body instead of Revolut's canonical `v1.{timestamp}.{rawBody}` payload, so once the secret was set every webhook 401'd. Also: `handleCreateOrder` never sent `merchant_order_data: { reference: orderRef }`, the field Revolut echoes back as `merchant_order_ext_ref` — without it the parser had nothing to match. All three shipped in commit `76fd238` (worker version `8841a752`). Signing secret `wsk_` re-synced via `wrangler secret put REVOLUT_WEBHOOK_SECRET` from the value retrieved via `GET https://merchant.revolut.com/api/1.0/webhooks/{id}`. Webhook subscription itself was correct all along. Verified end-to-end with €1 test order TIR-IE-2026-0028 (commit `6be53c2`, worker version `32f592fc`): paid via Revolut card checkout → `order:TIR-IE-2026-0028` flipped to `status: paid, paymentStatus: paid` in `ORDERS_KV`, SalesManager renders the order on the Paid lane with full timeline. Throwaway `/api/admin/test-order` endpoint pending deletion.
- Recurrence: 1
