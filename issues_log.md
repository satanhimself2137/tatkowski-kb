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

## #004 [TECH] SmartQuote step 2.5 modal has giant empty space on mobile -- 06/06/26 -- OPEN
- Logged by: Maciej
- Symptom: On mobile (iOS Safari confirmed, likely all narrow viewports), the SmartQuote modal step 2.5 (Review — AI result + price, before payment) renders with a large blank vertical gap below the content. Cosmetic but breaks perceived quality at the moment of conversion.
- Context: `packages/ui/src/components/SmartQuoteForm.astro` around line 211. Pre-existing — carried over from earlier SmartQuote work. Surfaced again during Phase 2 baking-studio test on 06/06/26 when placing TIR-IE-2026-0027.
- Resolution: (open)
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

## #001 [TECH] Revolut webhook does not update KV after successful payment -- 06/06/26 -- OPEN
- Logged by: Maciej
- Symptom: Client pays in full via Revolut, payment shows as Completed in Revolut Business dashboard, but the order in `ORDERS_KV` stays at `status: awaiting_payment, paymentStatus: unpaid`. SalesManager shows order as unpaid. Webhook either never fires, never reaches the worker, or fails before the KV write.
- Context: Confirmed on TIR-IE-2026-0027 (€44.99) placed 06/06/26 19:26 — Revolut captured, KV never updated. Same on TIR-IE-2026-0026 (predecessor). Worker handler at `workers/payment-worker/src/index.ts:575` (`handlePaymentWebhook`); only acts on `ORDER_COMPLETED` (line 644) and signature-verifies via `REVOLUT_WEBHOOK_SECRET` (line 585). Three plausible causes: (a) Revolut webhook subscription URL/secret missing or wrong in Revolut Business → Developer settings; (b) signature verification failing silently; (c) Revolut sending an event type other than `ORDER_COMPLETED`. Diagnostic next step: `npx wrangler tail` on the worker and replay/place a fresh payment to capture the inbound request, OR check Revolut Business → Developer → Webhooks → recent deliveries for failed status codes. BLOCKER — every paid order needs manual KV update via SalesManager "mark paid" button until fixed.
- Resolution: (open)
- Recurrence: 1
