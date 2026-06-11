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

## #028 [SEO] UK/ES/PT polish-translation + ukrainian-translation pages have no H1 — 6 pages affected -- 11/06/26 -- OPEN
- Logged by: Claude
- Symptom: Six bespoke flagship lander pages render with zero `<h1>` tag. Page content starts directly at H2 ("Why Choose Our [Language] Translation Services?" at ~line 46 in each file). Affected: `apps/uk/src/pages/polish-translation.astro`, `apps/uk/src/pages/ukrainian-translation.astro`, `apps/es/src/pages/polish-translation.astro`, `apps/es/src/pages/ukrainian-translation.astro`, `apps/pt/src/pages/polish-translation.astro`, `apps/pt/src/pages/ukrainian-translation.astro`. IE equivalents are unaffected — both have a proper `<h1>` (line 63 in IE polish; equivalent in IE ukrainian).
- Context: Surfaced during Phase B (LandingPage template) cross-market structural recon (11/06/26). UK/ES/PT polish/ukrainian are tightly cloned from each other (UK/ES/PT polish all ~62KB, identical h2:9 / section:9 structure; UK/ES/PT ukrainian all ~53KB, identical structure). The missing-h1 bug appears to have been cloned along with the base. Real SEO impact — every page should have exactly one H1 carrying the primary keyword. Search engines downrank pages missing one.
- Resolution: (open) — natural fix-window is Phase B migration. When these pages move to the LandingPage template, the template's hero will emit a proper H1 as part of its baseline output, fixing the bug automatically. Decision needed: (a) preserve the bug under strict byte-faithful migration and fix separately later; (b) declare the H1 addition an intentional improvement, document the deliberate post-snapshot delta (h1: 0 → 1), and ship as part of Phase B. Recommendation: (b) — bug fix during migration costs nothing, leaving pages without H1 indefinitely is the worse outcome. SEO gate would need a "deliberate-improvement" allowlist for this delta on the 6 affected pages.
- Recurrence: 1

## #027 [TECH] LangHero flag-pl chip variant unmapped in chipClass — directional-pair pages affected -- 11/06/26 -- OPEN
- Logged by: Claude
- Symptom: `LangHero` accepts a `variant` field on hero chips that maps to a CSS class via `chipClass`. Directional-pair pages (english-to-polish, polish-to-english, english-to-ukrainian, ukrainian-to-english) pass `variant: "flag-pl"` (or equivalent) which is not in the map — chip renders as base style only.
- Context: Surfaced during Phase A pre-migration catalogue (`docs/phase-a-progress.md`). Pre-existing, not introduced by Phase A. Out of scope for Phase A because directional pairs are deferred to a future `DirectionalPairPage` template (4 IE pages). Logged so the variant gap is addressed when that template lands — either extend the chip map or model the variant differently in `DirectionalPairPageData`.
- Resolution: (open) — fix during DirectionalPairPage template build, whenever that workstream lands.
- Recurrence: 1

## #026 [TECH] LangHero quoteEndpoint/quoteTitle props are vestigial — declared but not emitted in markup -- 11/06/26 -- OPEN
- Logged by: Claude
- Symptom: `LangHero` declares `quoteEndpoint` and `quoteTitle` props in its interface, but the rendered markup does not emit them. The SmartQuote button only carries `data-open-smartquote`; no `data-quote-endpoint` or matching attribute reaches the DOM. The 6 migrated IE language pages preserve the values in their data files (authoring intent), but they are not observable in output.
- Context: Surfaced during Phase A LanguagePage template build. The props were carried forward from pre-migration page data to preserve authoring intent. If the intent was to drive a per-page quote endpoint or title override on the SmartQuote modal, the wiring is missing. If they were never functional, they should be removed from the type.
- Resolution: (open) — operator decides: (a) wire them into LangHero markup (likely as `data-quote-endpoint` / `data-quote-title` on the SmartQuote button) and verify behaviour; (b) remove them from `LangHeroData` and the 6 IE data files. No SEO impact either way.
- Recurrence: 1

## #025 [TECH] FAQ schema set differs from visible FAQ set on language pages — modeled in type, possible parallel on doc-type pages -- 11/06/26 -- INFORMATIONAL
- Logged by: Claude
- Symptom: All 6 migrated IE standard language pages ship 8 questions in their `FAQPage` JSON-LD but render only 6 visible `<details>` accordion items. Pre-existing — Phase A preserves the asymmetry byte-identically. Now modeled explicitly in `LanguagePageData` as separate `faqs` (visible) + `faqSchemaItems` (schema-only superset).
- Context: Surfaced during Phase A SEO gating. Worth checking whether doc-type pages have the same hidden visible/schema mismatch — if so, `DocTypePageData` would benefit from the same split.
- Resolution: INFORMATIONAL — language template models the asymmetry correctly. Optional follow-up: audit doc-type pages for the same pattern when the workstream next touches DocTypePage.
- Recurrence: 1

## #024 [TECH] Phase B language fan-out blocked — UK/ES/PT have zero LanguagePage-archetype pages -- 11/06/26 -- RESOLVED
- Logged by: Claude
- Symptom: Phase B of the DS-conformance workstream was scoped as "fan-out LanguagePage to UK/ES/PT, just data files per market". Phase B fan-out recon (11/06/26) shows UK/ES/PT carry zero pages of the LanguagePage archetype (the "standard language page" shape: LangHero + acceptance + body prose + faq + related + cta, no inline CSS/JS/forms). Each non-IE market only has `polish-translation.astro` (~62KB), `ukrainian-translation.astro` (~53KB), and `european-languages.astro` (~49KB) — all three classified DEFERRED in Phase A as LandingPage candidates (bespoke landers / hub), not LanguagePage. No directional-pair pages exist outside IE. Phase B as scoped is empty work.
- Context: Same archetype-heterogeneity pattern that blocked Phase G Step B (UK/ES/PT doc-type pages lacked acceptance + CTA sections). IE has 6 standard language pages (gen1 rebuilds: russian, romanian, arabic, chinese, lithuanian, portuguese — all migrated 11/06/26) plus 4 bespoke landers (polish, ukrainian, irish, european-languages) plus 4 directional pairs. UK/ES/PT have only the bespoke-lander subset. Source: `Get-ChildItem apps/{ie,uk,es,pt}/src/pages/*translation*.astro` plus `european-languages.astro`, sized and classified against the Phase A archetype catalogue in `docs/phase-a-progress.md`.
- Resolution: RESOLVED 11/06/26 by Maciej — Phase B re-scoped (option A): build `LandingPage` template and migrate polish + ukrainian + european-languages across all 4 markets, plus IE `irish-translation`. Approx 12–13 pages total. See Decisions log in `roadmap/design-system-conformance.md`. Cross-market structural recon queued before agent prompt is written. DirectionalPairPage deferred — IE-only, 4 pages, low ROI relative to LandingPage.
- Recurrence: 1

## #023 [OPS] UK visa pages not classified for migration routing — 8 pages awaiting operator decision -- 11/06/26 -- OPEN
- Logged by: Claude
- Symptom: Phase G fan-out left UK visa-related pages (ilr-translation, asylum-translation, family-visa-translation, spouse-visa-translation, student-visa-translation, skilled-worker-visa-translation, visitor-visa-translation, citizenship-translation — approx 8 pages) un-enumerated and un-migrated. They may be doc-type-shaped (one type of paperwork, route to DocTypePage) or service-detail-shaped (a class of service, route to ServiceDetailPage in Phase D). Cannot be classified by Claude without reading each — operator decision needed because the routing affects information architecture for UK SEO.
- Context: Phase G migrated 10/10 UK doc-type pages cleanly. Visa pages were held back deliberately rather than guessed. Each page should be read and classified: H1 + body structure tells you which template fits. If the page is "translation OF a visa application" → doc-type. If "translation services FOR visa applicants" → service-detail.
- Resolution: (open) — operator triages the 8 visa pages, classifies each, then they migrate in either Phase G follow-up (doc-type extension) or Phase D (service-detail fan-out). Defer-to-Phase-D for service-detail-shaped is the cheaper default if unclear.
- Recurrence: 1

## #022 [TECH] PT doc-type pages were authored without page-level schema — preserved via emit flags -- 11/06/26 -- INFORMATIONAL (no action required)
- Logged by: Claude
- Symptom: 4/4 PT doc-type pages had no page-level `Service` or `FAQPage` JSON-LD before migration. Existing pages relied solely on the global organisation schema from `BaseLayout`. Migration must preserve this (SEO gate is byte-identical against pre-snapshot).
- Context: Surfaced during Phase G Step C fan-out. Resolved by adding `emitServiceSchema` and `emitFaqSchema` boolean opt-outs to `DocTypePageData`, defaulting to true; PT data files set both false. Pages migrate cleanly, post-snapshot matches pre-snapshot (no schema added, no schema lost). Future PT content-uplift might add page-level schema — at that point flip the flags and re-snapshot.
- Resolution: INFORMATIONAL — pattern established, no fix needed. Note for future LanguagePage / GuidePage / ServiceDetailPage templates: schema emission must be opt-out-able at the page level for the same reason markets vary in baseline maturity.
- Recurrence: 1

## #021 [TECH] Per-page schema `@id` slash conventions vary across markets — handled via pageUrlOverride -- 11/06/26 -- INFORMATIONAL (no action required)
- Logged by: Claude
- Symptom: Across the 4 markets, existing page-level schema `@id` values used inconsistent slash conventions (e.g. trailing slash on canonical but not on `@id` base, fragment-then-no-slash vs slash-then-fragment, etc.). A single `pageUrl = ${site.domain}/${slug}/` formula cannot reproduce every page's exact pre-snapshot `@id`.
- Context: Surfaced during Phase G Step C fan-out SEO gating. Resolved by adding `pageUrlOverride` to `DocTypePageData` — per-page string override for the schema `@id` base. Defaults to derived value, only set in data when the existing page's `@id` shape needed exact preservation. Used in handful of fan-out data files.
- Resolution: INFORMATIONAL — pattern works, escape hatch preserved per-page schema byte-identical. Forward principle: derived values are the default; per-page override exists for legacy preservation. New pages going forward should rely on the derived value to keep schema URLs consistent across the system.
- Recurrence: 1

## #020 [TECH] DocTypePage template shape was IE-specific — UK/ES/PT have thinner section sets -- 11/06/26 -- RESOLVED
- Logged by: Claude
- Symptom: Phase G fan-out Step B blocked on second structural mismatch (after #019 hardcodes). DocTypePage always renders 6 sections including `.acceptance-bar` and `.cta-section`. Existing doc-type pages: UK + ES have 4 sections (`doc-hero` / `doc-content` / `faq-section` / `related-doc`), PT has ~2 (just `hero` + a content card). No acceptance bar, no dedicated CTA section. Migrating UK/ES/PT as-is into the always-render template would either force authoring acceptance + CTA copy per page per market (content uplift, not migration) or leave empty sections rendering.
- Context: Same root pattern as #019 — pilot was scoped IE-only, so the template encoded IE's content depth as mandatory rather than optional. UK/ES/PT pages are last-generation pages that never received the content uplift IE pages got pre-pilot. This is a template-architecture finding: in a multi-market system where markets sit at different content maturity, sections must be data-driven (render-if-supplied), not mandatory.
- Resolution: RESOLVED — Phase G Step C (commit 24fc076). `acceptance`, `related`, `cta` sections, plus `faqHeading`, `emitServiceSchema`, `emitFaqSchema`, `pageUrlOverride`, all opt-in via `DocTypePageData`. IE re-verified 10/10 byte-identical against pre-snapshots after the change (conditionals don't fire on IE because IE always supplies the fields). 24/25 fan-out pages migrated cleanly across UK/ES/PT on the depth-agnostic template. Forward principle: every shared template treats sections as data-driven render-if-supplied, never mandatory. LanguagePage (Phase A) inherits from day one.
- Recurrence: 1

## #019 [TECH] DocTypePage template was IE-hardcoded (domain + WhatsApp number) -- 11/06/26 -- RESOLVED
- Logged by: Claude
- Symptom: Phase G fan-out Step B initially blocked. Template hardcoded `https://tatkowski.com/${slug}/` for `pageUrl` (drives schema `@id`) at line 18 and `wa.me/353838710861` (IE WhatsApp number) at line 35. Consuming as-is on UK/ES/PT would have failed SEO gate on every page (WhatsApp href change + JSON-LD `@id` domain change → 100% defer rate stop condition).
- Context: Pilot was scoped IE-only, so IE values matched the hardcodes and the pilot's SEO gate passed. No cross-market generalisation step happened during the pilot. Surfaced 11/06/26 the first time Phase G tried to fan out. Same root pattern as #020 (different surface). Pilot's audit didn't catch it — audit only compared IE pre/post, had nothing else to compare against.
- Resolution: RESOLVED — Phase G Step A (commit 1f75330). `pageUrl` now derives from `site.domain`, `waHref` from `site.whatsappNumber`. IE re-verification 10/10 byte-identical against existing pre-snapshots confirmed no drift. Market-aware SEO tooling added (`tools/seo-snapshot-market.mjs`, `tools/seo-compare-market.mjs`). Lesson: every shared template MUST read identity-shaped values (domain, phone, currency, country, locale) off site config from day one. LanguagePage (Phase A) inherits the pattern.
- Recurrence: 1

## #018 [TECH] Header-offset gap above hero on multiple page types (shared-layer pre-existing) -- 11/06/26 -- OPEN
- Logged by: Claude
- Symptom: Narrow strip of page background visible between the fixed header bar and the top of the hero section, leaving a white/light slice on dark theme. Surfaced 11/06/26 during DocTypePage pilot dev-server review (localhost:4321/criminal-record-translation-ireland and others). Same defect visible on production page tatkowski.com/medical-interpreting which was not part of any recent migration — confirms pre-existing shared-layer bug, NOT introduced by the pilot.
- Context: Likely culprits in `packages/ui/src/components/Header.astro`, `packages/ui/src/layouts/BaseLayout.astro`, or `packages/ui/src/styles/global.css` — main padding-top not matching fixed-header height, OR hero margin-top colliding with header transform, OR transparent header without compensating body offset.
- Resolution: (open) — fix in shared layer once, propagates to all pages including migrated doc-types. Verify on (a) DocTypePage migrated pages, (b) existing service-detail pages (certified-translation), (c) interpreting pages (medical-interpreting), (d) homepage Option A panel-mode mounted state. Deferred to end-of-workstream fix pass per agreed plan.
- Recurrence: 1

## #017 [TECH] SmartQuote v3 modal — doubled "SmartQuote™" header in modal shell -- 11/06/26 -- OPEN
- Logged by: Claude
- Symptom: Screenshot 11/06/26 on localhost:4321/medical-records-translation-ireland after triggering SmartQuote shows the modal rendering with TWO stacked "SmartQuote™" header bars (one with the close button, one without), plus the previously-known empty body (#014). The doubled-header symptom is NEW detail vs the original #014 capture; the empty body is the same issue.
- Context: Probably TWO modal containers mounting simultaneously (e.g. SmartQuoteForm AND SmartQuoteDrawer both instantiating the shell) OR a step-1 panel rendering inside a wrong parent so the step-1 header markup appears alongside the modal-shell header. Independent of pilot — confirmed on a freshly-migrated pilot page but the trigger surface is unchanged from pre-pilot, so the migration did not introduce or alter this.
- Resolution: (open) — likely related to #014 root cause; investigate together. Check whether SmartQuoteForm.astro AND SmartQuoteDrawer.astro both mount on doc-type pages (one should win, not both). If so, scope the mount to a single component per page. Deferred to end-of-workstream fix pass.
- Recurrence: 1

## #016 [TECH] Astro build fails on backslash-escaped apostrophe (\') inside single-quoted JSX prop -- 10/06/26 -- OPEN
- Logged by: Claude
- Symptom: Astro build errors with `Unexpected "'" at <line>:<col>` when a single-quoted JSX prop value contains `\'` (e.g. `q: 'What you\'ll need'`). esbuild treats the backslash as literal and the next `'` closes the string. Surfaced in Phase 4 on `apps/ie/src/pages/certified-translation.astro:251:15` inside FAQ items array. Build went from clean → broken on one character change. Diagnosed by bisecting: full FAQ items array → empty → minimal → re-adding & only → re-adding em dash only → re-adding apostrophe.
- Context: Standard pattern in JS/TS but Astro's JSX-expression parsing doesn't honour `\'` inside `'...'` strings. Switching the outer quote to double-quote (`q: "What you'll need"`) or using HTML entity (`&apos;` won't work in expression position) fixes it. Pattern bites whenever you author JS/TS object literals inside `.astro` files with apostrophes in copy.
- Resolution: (open) — convention to adopt: always double-quote any prop value string in `.astro` files that contains an apostrophe. Optional fix-layer task: add an ESLint rule banning `\'` in `.astro` files OR a quick lint script that flags it. Defer to end-of-workstream sweep.
- Recurrence: 1

## #015 [TECH] issues.ps1 throws "Format specifier was invalid" on every `log` action -- 10/06/26 -- OPEN
- Logged by: Claude
- Symptom: `issues.ps1 log -Category X -Title Y ...` fails with `Error formatting a string: Format specifier was invalid..` and the error context points at `{0:D3}`. Reproduced with multiple input variants (colons stripped, simplified text). Blocks all new issue logging via the tool.
- Context: Surfaced 10/06/26 during DS conformance workstream when trying to log issue #014. Format specifier `{0:D3}` is used inside the script to zero-pad the next issue ID — likely the next-ID lookup is returning a non-integer (empty string, or a parse failure on a recent entry's ID), causing the `-f` format to throw. Worked around by editing `issues_log.md` directly via `kb.ps1` read/write cycle.
- Resolution: (open) — next time touched: read the script, locate the `{0:D3}` site, harden the ID parse (default to last-ID + 1, coerce to int, fall back to scan if parse fails).
- Recurrence: 1

## #014 [TECH] SmartQuote v3 modal body appears empty on /certified-translation -- 10/06/26 -- OPEN
- Logged by: Claude
- Symptom: localhost:4322/certified-translation shows v3 modal header (SmartQuote™ title + × close button) and 2-dot stepper rendering correctly, but the modal body middle area appears empty — no step 1 content visible (file upload area, language selectors, browse link). Screenshot captured 10/06/26.
- Context: Phase 2 SmartQuote DS modal refactor shipped 10/06/26 (commit 8532074) with 7/7 verification checks clean. Prompt 2 build log explicitly flagged: "Service worker cache flush required (sw.js unregistration) before new CSS loaded in preview — noted for future dev sessions (hard-reload or SW unregister)." Highly likely stale SW cache. Surfaced while reviewing the ?panel=1 index template preview gate (separate workstream item).
- Resolution: (open) — first pass when revisited at end-of-workstream fix sweep: hard reload + Application > Service Workers > Unregister, retest. If body content reappears, mark resolved as SW cache. If reproduces after SW clear, bisect step 1 render path in `packages/ui/src/components/SmartQuoteForm.astro` (`.sqf-modal-body`, step 1 panel visibility).
- Recurrence: 1

## #013 [TECH] index.astro missing #panel-mode div — mode-interpreting template never mounts -- 10/06/26 -- RESOLVED
- Logged by: Claude
- Symptom: `<template id="mode-interpreting">` in `apps/ie/src/pages/index.astro` is never cloned into the DOM. `mountInitial()` / `switchMode()` both start with `const root = document.getElementById('panel-mode'); if (!root) return;` — but no element with `id="panel-mode"` exists in the Astro markup. The comment `<!-- Root where active mode frames are mounted -->` is present at line ~39 but the actual `<div id="panel-mode" ...>` is absent.
- Context: Surfaced during Prompt 3-fix visual verification (10/06/26). Pre-existing before Prompt 3 (confirmed via `git show HEAD~1`). For IE production, this is currently non-impacting because `recruitmentEnabled: false` in `site.config.ts` — both landing buttons are `<a href>` navigation links (translation → `/certified-translation`, interpreting → `/interpreting`), so no in-page mode switching is attempted. If `recruitmentEnabled` is set to `true` or a use-case requires in-page panel display, mode mounting is silently broken. Also: `aria-controls="panel-mode"` on the recruitment button in LandingOverlay.astro references this non-existent element.
- Resolution: RESOLVED 10/06/26 by Claude — Phase 3 closeout (commit 3e47d7a). Added unconditional `<div id="panel-mode">` at line 43 (done in preview-gate session), then wired up `mountInitial('interpreting')` call on DOMContentLoaded. Panel now mounts on every page load.
- Recurrence: 1

## #012 [TECH] SmartQuote browse button / upload flow dead on all markets after e76ae80 -- 07/06/26 -- RESOLVED
- Logged by: Claude
- Symptom: Clicking "browse" or the drop zone on `/certified-translation` did nothing — no file picker opened. Affected all three instances (hero, main, drawer) on all four markets.
- Context: `packages/ui/src/components/SmartQuoteForm.astro`. Commit e76ae80 removed `reviewContinueBtn`/`panelReview`/`confirmRecapEl` from variable declarations but left three init-time usages. In strict-mode ESM (Astro `<script>` without `is:inline`), accessing an undeclared var throws `ReferenceError`. The crash occurred during `_sqfInitAll` `forEach` callback before `dropzone.addEventListener("click", ...)` was reached, so no click handlers were ever attached. Pattern: removing a variable declaration without grepping all usage sites silently kills unrelated init code in the same callback.
- Resolution: RESOLVED 07/06/26 by Claude — commit a8e7003. Removed the three crash sites: `if (reviewContinueBtn)` init block (~2598), `if (panelReview)` in `resetToStep1()`, `if (confirmRecapEl)` in `proceedManualBtn` handler. Verified: all three instances trigger `fileInput.click()` on dropzone click after clean page load. All four market builds clean.
- Recurrence: 1

## #011 [TECH] shadow-accent token missing from tokens.css -- 07/06/26 -- RESOLVED
- Logged by: Claude
- Symptom: DS spec (ui_kits/website/site.css) specifies `box-shadow: var(--shadow-accent)` for `.btn-primary`, but `--shadow-accent` is not defined in `packages/ui/src/styles/tokens.css` or `global.css`. Commit e76ae80 (07/06/26) kept the existing inline rgba shadow rather than reference an undefined var, so the DS spec is not fully applied.
- Context: Surfaced during Commit 2.5 button-gradient fix. Token should be added to tokens.css as part of a dedicated token-cleanup task alongside the known `--accent: #ff6a3d` override bug (~line 1098 of global.css).
- Resolution: RESOLVED 10/06/26 by Claude -- --shadow-accent resolves via DS import chain: global.css imports design-system/styles.css which imports tokens/spacing.css (L29). No tokens.css change needed.
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
