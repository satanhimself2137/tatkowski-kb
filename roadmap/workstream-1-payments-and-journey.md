# ROADMAP — Payments & customer journey

**Status:** IN PROGRESS — Phase 0 (Claude Design pass)
**Owner:** Maciej
**Last update:** 07/06/26 by Claude (T&Cs ES/PT revert shipped)

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

### 07/06/26 — Claude — SmartQuote v3 rebuild: 1/AI/3 stepper + Panel 3 spec alignment (item: SmartQuote flow restructure — SHIPPED)

Stepper rebuilt to three circles `1 / AI / 3` per amendment. AI step is non-clickable (system-controlled). Text "AI" by default, swaps to a checkmark when done.

Panel 2 promoted from a transient `<div class="sqf-loading">` overlay to a real `sqf-panel--ai` with two sub-states: 2a auto-analysis (existing checklist animation) and 2b manual fallback (warning notice + page input + Continue). Manual fallback no longer lives inline inside Panel 3 — relocated entirely to Panel 2 as the amendment required.

Panel 3 rebuilt against `packages/ui/src/design-system/deliverables/SmartQuoteStep2.jsx`. New review header: eyebrow "We analysed your document" + title "Looks good — here's what we'll certify." + Analysed badge top-right. Compressed summary card (Document, Pages, Languages, Handwriting, Total + Turnaround). "Something off? Adjust" disclosure collapsed by default. Customer details (name, email, WhatsApp opt-in toggle). Sticky Pay button.

Removed leftover dispute mechanism (button + panel + confirm + flag) — only routed to re-upload, not WhatsApp; per amendment note, removed since "it doesn't currently do anything useful." Re-upload shortcut at the top of Panel 3 still provides the safety valve.

Same-class crash refs from e76ae80 pre-empted: removed `showReviewPanel`, `updateStep3PriceManual`, and bare references to `step3TotalEl`/`step3BreakdownEl`/`step2AiSummary`/`summaryDocEl`/`summaryPagesEl`/`summaryPriceEl`/`analysisNotice`/`manualFallback`/`manualPageRow`/`manualPagesS3`/`disputeBtn`/`disputePanel`/`disputeNote`/`flagBtn`/`disputeConfirm`/`midDots`. Verified clean init across all three instances (hero, main, drawer) on the IE dev server; all 4 market builds clean.

**Files touched:**
- `packages/ui/src/components/SmartQuoteForm.astro` — stepper HTML+CSS, Panel 2 markup, Panel 3 review-head + summary structure, JS setStep / _updateIndicator / showManualFallback / manualContinueBtn wiring, removal of dead refs (235 insertions, 336 deletions).

**Commits:**
- 13770df — ui(SmartQuote): rebuild against v3 spec — 3-state stepper (1/AI/3), compressed summary + Adjust + sticky Pay, manual fallback relocated to Panel 2

### 07/06/26 — Claude — SmartQuote upload button hot-fix (item: SmartQuote flow — UNBLOCKED)

Root cause: commit e76ae80 removed `reviewContinueBtn`/`panelReview`/`confirmRecapEl` from variable declarations but left three init-time usages in `_sqfInitAll`. In strict-mode ESM (Astro `<script>` without `is:inline` → Vite → ESM), accessing an undeclared variable at runtime throws `ReferenceError`. The crash happened BEFORE `dropzone.addEventListener("click", ...)` was reached, so the browse button (and the entire upload flow) was dead for all three instances (hero, main, drawer) on all four markets. `goToStep3` and `showReviewPanel` were already unreachable dead code — no user-visible regression from their remaining stale refs.

**Files touched:**
- `packages/ui/src/components/SmartQuoteForm.astro` — removed 3 crash sites (13 lines deleted)

**Commits:**
- a8e7003 — fix(SmartQuote): restore upload button file picker broken in e76ae80

### 07/06/26 — Claude — SmartQuote visual polish: stepper ring, AI centering, dark-mode contrast, Panel 3 compact (item: SmartQuote flow restructure — POLISH)

Four CSS/HTML fixes on top of the v3 rebuild:

1. **Stepper ring overlap** — `sqf-step-ring` keyframe max scale reduced from 2.2→1.5. The expanding `::after` ring on the active circle was visually bleeding into adjacent circles at the original scale; 1.5× stays well within the line gap.

2. **"AI" text centering** — `letter-spacing: 0.5px` on `.sqf-step-ai-text` was adding trailing space after the last glyph, shifting "AI" visually rightward inside the circle. Set to `letter-spacing: 0`.

3. **Dark mode contrast** — Added comprehensive `:global([data-theme="dark"]) .sqf-root` child overrides for inputs, labels, summary card, review head, details eyebrow, WA opt-in, phone prefix, pay bar, adjust note, notice variants, and AI manual notice. Root cause: the `prefers-color-scheme: light` media query was resetting these to dark-text values; when OS is dark but site toggle is dark, the `:global` dark theme rule restored the root gradient but NOT the child element palette. Key overrides use `!important` to win against global theme selectors.

4. **Panel 3 compact** — Added `.sqf-panel--review` class to Panel 3 div, with scoped compression: review eyebrow and details eyebrow hidden (`display:none !important`), summary card padding halved, row height reduced, field spacing tightened, pay button height and font reduced. Panel now fits nav-to-viewport without scrolling on mobile and desktop drawer.

**Files touched:**
- `packages/ui/src/components/SmartQuoteForm.astro` — HTML: `sqf-panel--review` class on Panel 3 div. CSS: ring animation, AI text, dark theme overrides block (~35 rules), panel compact block (~15 rules).

**Commits:**
- 74d714a — fix(SmartQuote): stepper ring overlap, AI centering, dark-mode contrast, Panel 3 compact

### 07/06/26 — Claude — Tier A marketing copy fixes shipped (item: Marketing copy update — PARTIAL)

Resolved three categories of T&Cs §3 alignment / data bugs across 4 market sites. Audit context: `todos/eta-copy-audit-20260607.md`.

**Fixes applied:**

1. **Kill "guaranteed" from delivery time** — removed ` guaranteed` from `✓ 24-hour delivery guaranteed` in the Rush Service card across all 4 `european-languages.astro` files. "Same-Day" and "24h" copy is staying — operationally true for short docs, indexed in GSC. Only the literal word "guaranteed" attached to a delivery time was in conflict with T&Cs §3 (reasonable endeavours, no contractual guarantee of timing).

2. **UK price data bug** — `apps/uk/src/pages/ukvi-translation-guide.astro` meta description had stale `£29.99/page`; corrected to locked `£39.99/page`.

3. **48h→24h contradiction** — all 4 `european-languages.astro` files had FAQ answer "Standard delivery is 48 hours for certified translations. Rush service (24 hours) is available for…" — contradicts `certified-translation.astro` (24h standard) and the locked dynamic ETA decision. Rewrote to "Standard certified translation is delivered within 24 hours. Same-day translation is possible for urgent situations (availability-based, [market-price] per page)." Additionally, the Certified Translation card in UK/ES/PT also said "48-hour standard delivery" — aligned to 24-hour. IE was already correct.

**Broader "kill 24h/Same-Day" rewrite rejected:** not in scope. "Same-Day" copy is staying because it is operationally true for short docs and indexed in GSC. The full rewrite (dynamic ETA bands surfaced at quote) is a later workstream task.

**Additional instance noted (not fixed):** ES and PT `european-languages.astro` task spec listed ES pricing as "€49.99 ES standard / €64.99 ES urgent" — these are actually PT prices. Actual ES file: €29.99 standard / €39.99 urgent. Diff applied preserving prices as found in files. The task's pricing reference was transposed.

**Files touched:**
- apps/ie/src/pages/european-languages.astro
- apps/uk/src/pages/european-languages.astro
- apps/es/src/pages/european-languages.astro
- apps/pt/src/pages/european-languages.astro
- apps/uk/src/pages/ukvi-translation-guide.astro

**Commits:**
- d5c639c — marketing: align ETA copy with T&Cs §3 — remove "guaranteed" from delivery, fix UK price data bug, align european-languages 48h→24h

### 07/06/26 — Claude — T&Cs ES/PT §3 + §11 reverted to English (item: T&Cs delivery clause — SHIPPED)

Earlier commit `36541d1` left ES and PT terms.astro in a Frankenstein state — only §3 and §11 were translated (to Castilian Spanish and European Portuguese), while every other clause in those two files remained in English. Root cause: the Copilot prompt assumed ES/PT files were already localised and asked Copilot to translate only the new clauses. They weren't. Copilot followed instructions literally. Lesson logged in patterns: **always inspect target files before writing a Copilot prompt — both for content state and for tooling assumptions (npm vs pnpm, scripts available)**.

Replaced ES §3+§11 Spanish text and PT §3+§11 Portuguese text with the verbatim IE/UK English. Verified byte-identical content across all four markets via SHA256 on the normalised UTF-8 content of lines 39 and 63 (BOM/CRLF normalised — PT file carries a UTF-8 BOM, IE uses LF, UK/ES/PT use CRLF; build is unaffected). No structural changes, only paragraph text inside `<p>` tags. Local build verification skipped — commit `36541d1` already proved this identical English text compiles cleanly for IE/UK; ES and PT use the same Astro setup. Cloudflare Pages will verify on push.

Full ES and PT localisation deferred. PT terms.astro has known factual bugs that need legal/copy review before any go-live: §2 references GBP (should be EUR), §12 governs by laws of England and Wales (should be Portugal), and likely UK 1998 Late Payment Act references will need replacement with EU Directive 2011/7/EU. Tracked as issue #009.

**Files touched:**
- apps/es/src/pages/terms.astro (§3 + §11 Spanish → English)
- apps/pt/src/pages/terms.astro (§3 + §11 Portuguese → English)

**Commits:**
- c2572b7 — terms: revert ES/PT §3 + §11 to English (matches IE/UK; full ES/PT localisation deferred)

### 07/06/26 — Claude — T&Cs §3 delivery clause + §11 cancellations shipped (item: T&Cs delivery clause — PARTIAL, see follow-up entry above)

Replaced §3 (Delivery & Turnaround) and §11 (Cancellations & Refunds) across all four market T&Cs pages with locked contractual language aligned to the workstream decision: refund reserved for impossibility (unable to source qualified certified translator), not delay; pro-rata cancellation charge once work commenced; full refund within 1 business day for impossibility. ES and PT clauses translated to Castilian Spanish and European Portuguese respectively. All four apps built clean. Visual check confirmed §3 and §11 render new text on IE (English) and ES (Spanish) live dev servers. No TypeScript errors introduced. Done criterion "T&Cs delivery clause shipped to all 4 market T&Cs pages" is now met.

**Files touched:**
- apps/ie/src/pages/terms.astro
- apps/uk/src/pages/terms.astro
- apps/es/src/pages/terms.astro
- apps/pt/src/pages/terms.astro

**Commits:**
- 36541d1 — terms: align §3 delivery + §11 cancellations across IE/UK/ES/PT

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

### 07/06/26 — Claude — Plan B Commit 2: SmartQuote v3 + shared layout/hero cleanup

Merged Steps 2+2.5+3 into a single "Review+Pay" panel in SmartQuoteForm.astro. Step indicator collapsed from 3-step to 2-step. Added WhatsApp opt-in checkbox with conditional phone field (country prefix auto-set by market prop). Sticky Pay bar. Summary card (doc type, pages, languages, handwriting surcharge, total, ETA). Inline contact validation in pay handler (name + email checked before manual-page fallback). Intake API contact step moved into pay handler click. Light+dark theme support via `@media (prefers-color-scheme)` + `:global([data-theme])` overrides.

BaseLayout: default titles across all 4 markets — removed 🏆 emoji, replaced "Same-Day" with "24h". Meta description updated to remove "Same-day delivery" language.

LangHero: removed `↔` character content from `.lh-pair-arrow` div (card hidden via CSS anyway); removed emoji from WhatsApp and Certified Translation CTA buttons.

CtaCluster: removed emoji from WhatsApp, Email, Phone buttons.

**Root cause of build delay:** smart/curly single quotes (U+2018/U+2019) written instead of ASCII straight quotes in `{market === 'uk' ? '+44' : ...}` Astro template expression on line 259. esbuild rejects them. Also: `</script>` closing tag was accidentally dropped by a Python binary replacement and had to be re-appended. Both issues fixed before commit.

Note: LangHero `eyebrowLang` prop values (e.g. "Polski ↔ English") still contain `↔` — these are passed per-page, not from the shared component. Updating page-level prop values is a separate task.

SmartQuoteDrawer.astro imports SmartQuoteForm directly — v3 changes flow through without separate Drawer edits. Done criterion for "SmartQuote restructured to 2-step flow" is met.

**Files touched:**
- `packages/ui/src/components/SmartQuoteForm.astro`
- `packages/ui/src/layouts/BaseLayout.astro`
- `packages/ui/src/components/LangHero.astro`
- `packages/ui/src/components/CtaCluster.astro`

**Commits:**
- 736bf69 — feat(ui): SmartQuote v3 + shared layout/hero cleanup

---

### 07/06/26 — Claude — Plan B Commit 1: design system relocation + ETA helpers + token wiring

Phase 0 deliverables (matrix.jsx, emails.jsx, drawer-states.jsx, DECISIONS.md) shipped by Claude Design into `docs/Tatkowski Design System/deliverables/` in the previous session. Commit 1 of Plan B moves the entire DS tree to its permanent location in the live package, wires DS tokens into the CSS pipeline, and ports the ETA helper functions to TypeScript.

**Work done:**

1. **DS folder relocation** — `docs/Tatkowski Design System/` moved to `packages/ui/src/design-system/` using PowerShell `Move-Item` (fallback: `git mv` blocked by Windows Permission Denied on directory rename — likely Explorer holding a handle). Git detected renames by content similarity for all previously-tracked files. Obsolete `docs/Tatkowski Design System doc baker/` snapshot and `.zip` removed.

2. **Token pipeline wired** — `@import url('../design-system/styles.css')` added as the first line of `packages/ui/src/styles/global.css`. DS tokens load first; live `tokens.css` loads second and wins on any shared variable (no conflicts; DS adds new tokens `--accent-tint`, `--success`, `--warning`, `--danger`, `--info`, `--whatsapp`, `--focus-ring` that live tokens.css doesn't define).

3. **ETA helpers ported** — `packages/ui/src/utils/eta.ts` created with `etaBandForPages(pages)` and `formatExpectedReady(paidAt, pages, locale?)` TypeScript exports, faithfully porting the canonical implementations from `deliverables/emails.jsx`.

4. **CLAUDE.md updated** — Design system section appended: token pipeline diagram, known `--accent` inconsistency in global.css, ETA helper import path, and note that DS files are reference-only (not for direct production import).

5. **Build verification** — `npm run build:ie` passes (52 pages, 0 errors). IE/UK `terms.astro` WIP remained unstaged throughout.

**Known inconsistency reported inline (existing, not introduced):** `global.css` has a second `:root` block (~line 1098) setting `--accent: #ff6a3d`, overriding the correct `#ff6a1a` from `tokens.css`. Pre-existing live bug, not a DS conflict. Needs a dedicated fix.

**Files touched:**
- `packages/ui/src/design-system/` (entire tree — new)
- `packages/ui/src/utils/eta.ts` (new)
- `packages/ui/src/styles/global.css` (1 line added)
- `CLAUDE.md` (design system section appended)
- `docs/Tatkowski Design System/` (removed — relocated)
- `docs/Tatkowski Design System doc baker/` (removed — obsolete snapshot)
- `docs/Tatkowski Design System doc baker.zip` (removed)

**Commits:**
- f6af76b — design-system: relocate docs/Tatkowski Design System -> packages/ui/src/design-system + wire tokens, port ETA helpers, update CLAUDE.md

### 07/06/26 — Claude — Commit 2.5: SmartQuote overflow fix + v3 visual rebuild (header, hero, buttons)

**Bug fix — SmartQuote drawer overflows viewport on desktop + mobile (Review+Pay step):**

Root cause: `.sqf-root` had `overflow: hidden` which effectively made its flex `min-height: auto` resolve to 0, allowing content to clip rather than scroll. Fixed by mirroring the mobile flex-containment chain to desktop: form-wrap → sqf-root → active panel is now the scroll container (not the wrapper). Removed dead JS refs to `panelReview`, `panel3`, `reviewContinueBtn`, `confirmRecapEl` (all returned null in v3 HTML — leftover from 3-step structure). Pay bar: `bottom: env(safe-area-inset-bottom, 0)` for iOS safe area. `setStep()` loop trimmed from 3-panel to 2-panel.

**Structural rebuild — packages/ui only (no per-market pages touched):**

1. **Header** — `position: fixed` → `position: sticky; top: 0`, `background: color-mix(in srgb, var(--bg) 88%, transparent)`, `backdrop-filter: blur(12px)`, `border-bottom: 1px solid var(--divider)`, `--header-height: 72px` (was 80px). z-index kept at 100 (mobile menu at 55, SmartQuote shell at 50 — reducing to DS spec's 50 would break stacking). Dark-mode `:global` override removed (color-mix auto-adapts via `--bg`). Removed `padding-top: var(--header-offset, 80px)` from `<main>` in BaseLayout — sticky header is in document flow, no offset needed.
2. **Hero shell** — `.hero` now uses `padding: var(--space-xxl, 6rem) 0 var(--space-xl, 4rem)` and `background: radial-gradient(ellipse 60% 50% at 50% 0%, var(--accent-tint, #fff1ec), transparent 70%)`. `.hero-inner { max-width: 860px; margin: 0 auto; }` added. Removed duplicate hero media query. DottedPattern untouched.
3. **Buttons** — `.btn-primary` gradient start corrected from `#ff6a3d` → `#ff6a1a` (canonical brand orange matching `--brand` token). Box-shadow rgba values updated to match.
4. **Footer** — assessed against DS spec (`ui_kits/website/index.html`). DS spec has a minimal template (logo + tagline + legal text only). Current footer is a SUPERSET with nav columns and review badge — production additions that cannot be removed without SEO/UX regression. Classified as restyle drift, NOT rebuild. No changes made — flagged to Maciej inline.
5. **localStorage key** — `'theme'` → `'tk-theme'` across FabTheme.astro, Header.astro (mobile toggle), NavigationBar.astro, BaseLayout.astro inline init script. One-time UX break for existing theme persistence — acceptable.

**Build verification:** all 4 markets clean — IE 52pp, UK 47pp, ES 45pp, PT 38pp. Screenshots: 1440px light/dark + 390px light/dark, all clean.

**Files touched:**
- `packages/ui/src/components/SmartQuoteDrawer.astro`
- `packages/ui/src/components/SmartQuoteForm.astro`
- `packages/ui/src/components/Header.astro`
- `packages/ui/src/components/FabTheme.astro`
- `packages/ui/src/components/NavigationBar.astro`
- `packages/ui/src/layouts/BaseLayout.astro`
- `packages/ui/src/styles/button-system.css`
- `packages/ui/src/styles/global.css`
- `.claude/launch.json` (new — preview server config)

**Commits:**
- e76ae80 — ui: finish v3 visual rebuild (sticky header + theme toggle, hero shell, button gradients, footer) + fix SmartQuote modal overflow

---

## Done criteria

- [x] Phase 0 — Claude Design pass complete: refreshed `matrix.jsx`, `emails.jsx`, `drawer-states.jsx`, plus new `DECISIONS.md` shipped to `packages/ui/src/design-system/deliverables/` (formerly `docs/Tatkowski Design System/deliverables/` — relocated in f6af76b)
- [x] SmartQuote restructured to 2-step flow (upload+analysis → review+details+pay) across 4 market sites
- [ ] Marketing copy across 4 market sites updated — no "24h guaranteed" claims, dynamic ETA bands surfaced at quote
- [x] T&Cs delivery clause shipped to all 4 market T&Cs pages (English, §3 + §11; ES/PT full localisation deferred — see issues_log #009)
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
