# ETA / 24h / guarantee copy audit — 07/06/26

## Summary

- **Total pattern matches (raw, excluding recruitment files):** ~780 lines across all files
- **Recruitment files excluded:** 20 (5 per market: `construction-recruitment.astro`, `hospitality-recruitment.astro`, `logistics-recruitment.astro`, `office-recruitment.astro`, `recruitment.astro`)
- **DELIVERY-PROMISE (rewrite target):** ~245 content lines (title tags, meta descriptions, body copy, component defaults making flat turnaround claims)
- **ACCEPTANCE-GUARANTEE (leave alone):** 47 lines (ISD/UKVI/AIMA/SNIG/authority acceptance, apostille completion)
- **STRUCTURED-DATA subset:** ~70 lines (delivery claims inside JSON-LD schema — SEO-sensitive)
- **META-TAG subset:** ~85 lines (delivery claims in `const title =` / `const description =` — SEO-sensitive)
- **OTHER:** ~55 lines (recruitment replacement guarantee in non-recruitment pages, confidentiality guarantee, revision guarantee — none of these are turnaround claims)
- **Outside scope / false positives filtered:** ~430 lines (JS code `immediately`/`instantly`, CSS animation `instant`, interpreting booking availability, cancellation notice windows in T&Cs, admin-internal copy in `AdminApp.tsx`, `Aberto 24 horas` in PT contact page)

> **Note:** Many lines contain multiple pattern matches. The ~780 raw figure is line count; the classified figures above count editorial decisions (one per content block). The IE market has the highest density by far — IE alone accounts for roughly 40% of delivery-promise content.

---

## By market

### IE (`apps/ie/src/**`)
- **DELIVERY-PROMISE:** ~120 (highest density — almost every language/document page has 24h in title, meta, body, and FAQ schema)
- **ACCEPTANCE-GUARANTEE:** 15
- **STRUCTURED-DATA subset:** ~35 (language pages use inline JSON-LD FAQPage schema with 24h answers)
- **META-TAG subset:** ~40 (every language page has `const title = "... 24h"` and `const description = "... 24h delivery"`)

### UK (`apps/uk/src/**`)
- **DELIVERY-PROMISE:** ~80 (same-day dominates over 24h; `certified-translation.astro` and guide pages are dense)
- **ACCEPTANCE-GUARANTEE:** 14
- **STRUCTURED-DATA subset:** ~20
- **META-TAG subset:** ~25

### ES (`apps/es/src/**`)
- **DELIVERY-PROMISE:** ~25 (sparser — no individual language pages, document-specific pages fewer; `certified-translation.astro`, `european-languages.astro`, and shared document pages carry most)
- **ACCEPTANCE-GUARANTEE:** 9
- **STRUCTURED-DATA subset:** ~8
- **META-TAG subset:** ~5

### PT (`apps/pt/src/**`)
- **DELIVERY-PROMISE:** ~27 (comparable to ES; `certified-translation.astro` alone has 25 total matches)
- **ACCEPTANCE-GUARANTEE:** 9
- **STRUCTURED-DATA subset:** ~8
- **META-TAG subset:** ~5

### packages/ui (`packages/ui/src/**`)
- **DELIVERY-PROMISE:** 8 (highest-impact per line — these affect all 4 markets simultaneously)
  - `BaseLayout.astro:57` — default IE/UK title template includes `| Same-Day |`
  - `BaseLayout.astro:60` — default IE title template includes `| Same-Day |`
  - `BaseLayout.astro:62` — default description `"… Same-day delivery. Get a quote in 15 minutes."`
  - `BaseLayout.astro:375` — JSON-LD `"description": "Same-day urgent translation with fast delivery."` (STRUCTURED-DATA)
  - `LangHero.astro:61` — default prop `turnaround = 'Same-day'` (renders as visible badge on language pages)
  - `SmartQuoteDrawer.astro:60` — `<li>Certified translators · same-day delivery</li>` (visible text in drawer)
  - `SmartQuoteForm.astro:346` — `"You'll receive a confirmation by email within 24 hours."` (shown on form submit confirmation)
  - `SmartQuoteForm.astro:2675` — `if (totalPages <= 3) return 'Within 24 hours';` (ETA calculation shown to customer — **note: already matches locked 1-3 page = 24h band; this line may be fine**)
- **ACCEPTANCE-GUARANTEE:** 0
- **STRUCTURED-DATA subset:** 1 (`BaseLayout.astro:375`)
- **META-TAG subset:** 2 (`BaseLayout.astro:57` and `:60` — title templates)

---

## Full match list

### DELIVERY-PROMISE

#### packages/ui — affects all markets simultaneously

`packages/ui/src/layouts/BaseLayout.astro:57` — `site.locale === 'en-GB' ? \`🏆 Certified Translation London | Same-Day | All Languages | UKVI Accepted | ${site.name}\`` *(META-TAG + DELIVERY-PROMISE)*

`packages/ui/src/layouts/BaseLayout.astro:60` — `` `🏆 Certified Translation Dublin | Same-Day | All Languages | ISD Accepted | ${site.name}` `` *(META-TAG + DELIVERY-PROMISE)*

`packages/ui/src/layouts/BaseLayout.astro:62` — `const description = _descriptionProp ?? "Expert certified translation services. Same-day delivery. Get a quote in 15 minutes.";` *(META-TAG + DELIVERY-PROMISE — this is the fallback description for any page that does not pass its own description prop)*

`packages/ui/src/layouts/BaseLayout.astro:375` — `"description": "Same-day urgent translation with fast delivery."` *(STRUCTURED-DATA + DELIVERY-PROMISE — inside JSON-LD service schema)*

`packages/ui/src/components/LangHero.astro:61` — `turnaround = 'Same-day',` *(DELIVERY-PROMISE — default prop value rendered as visible turnaround badge on every language page using LangHero; individual pages can override but many do not)*

`packages/ui/src/components/SmartQuoteDrawer.astro:60` — `<li>Certified translators · same-day delivery</li>` *(DELIVERY-PROMISE — visible text inside the SmartQuote drawer shown to every customer on all 4 markets)*

`packages/ui/src/components/SmartQuoteForm.astro:346` — `<p class="sqf-confirmed-sub">You'll receive a confirmation by email within 24 hours.</p>` *(DELIVERY-PROMISE — shown to customer after submitting quote form; wording is ambiguous — "confirmation" of the quote or of the translation? Needs desktop review)*

`packages/ui/src/components/SmartQuoteForm.astro:2675` — `if (totalPages <= 3) return 'Within 24 hours';` *(DELIVERY-PROMISE — ETA displayed to customer during checkout. **Already correct per locked bands (1-3 pages = 24h) — may need no change, but confirm wording is "estimated" not promised**)*

---

#### IE — `apps/ie/src/**`

**`apps/ie/src/pages/certified-translation.astro`** (highest-density IE page — 32 total matches)

`apps/ie/src/pages/certified-translation.astro:5` — `const title = "Certified Translation Dublin | ISD Accepted | €39.99/page, 24h"` *(META-TAG + DELIVERY-PROMISE)*

`apps/ie/src/pages/certified-translation.astro:8` — `const description = "… €39.99/page, 24h delivery …"` *(META-TAG + DELIVERY-PROMISE)*

`apps/ie/src/pages/certified-translation.astro:160` — `'Standard delivery is 24 hours. For urgent cases — same-day, 2-hour, or faster — contact us directly for a bespoke schedule.'` *(STRUCTURED-DATA + DELIVERY-PROMISE — inside FAQPage schema)*

`apps/ie/src/pages/certified-translation.astro:265` — `<div class="trust-item"><span class="icon">⚡</span><strong>Same‑Day</strong><small>Urgent 2‑Hour</small></div>` *(DELIVERY-PROMISE — visible trust bar)*

`apps/ie/src/pages/certified-translation.astro:293` — `"…Our qualified translators deliver same-day certified translations for birth certificates…"` *(DELIVERY-PROMISE — hero paragraph)*

`apps/ie/src/pages/certified-translation.astro:299` — `"I was quoted 5 days for a birth certificate" — We deliver in 24h, urgent cases faster.` *(DELIVERY-PROMISE — testimonial comparison)*

`apps/ie/src/pages/certified-translation.astro:384` — `"Receive certified PDF via secure email… Same-day delivery standard."` *(DELIVERY-PROMISE — features list)*

`apps/ie/src/pages/certified-translation.astro:521` — `Standard delivery is 24h. Urgent (same-day, 2-hour, or faster) is always available…` *(DELIVERY-PROMISE — FAQ body)*

`apps/ie/src/pages/certified-translation.astro:554` — `<li>Certified translators · same-day delivery</li>` *(DELIVERY-PROMISE — SmartQuote tab bullet; this is LangHero/SmartQuoteDrawer shared content)*

---

**`apps/ie/src/pages/translation-services-dublin.astro`** (22 total matches)

`apps/ie/src/pages/translation-services-dublin.astro:5` — `const title = "Translation Services Dublin | Certified, Same-Day | €39.99 from Tatkowski"` *(META-TAG + DELIVERY-PROMISE)*

`apps/ie/src/pages/translation-services-dublin.astro:6` — `const description = "… €39.99/page, 24h delivery…"` *(META-TAG + DELIVERY-PROMISE)*

`apps/ie/src/pages/translation-services-dublin.astro:19` — `'description': '… €39.99/page, 24h delivery.'` *(STRUCTURED-DATA + DELIVERY-PROMISE — service schema)*

`apps/ie/src/pages/translation-services-dublin.astro:29` — `'name': 'Standard Certified Translation — 24h Delivery'` *(STRUCTURED-DATA + DELIVERY-PROMISE — product name in schema)*

`apps/ie/src/pages/translation-services-dublin.astro:43` — `'… €39.99/page, 24h standard delivery.'` *(STRUCTURED-DATA + DELIVERY-PROMISE)*

`apps/ie/src/pages/translation-services-dublin.astro:59` — `'Urgent delivery shorter than 24h is always available on request.'` *(STRUCTURED-DATA + DELIVERY-PROMISE — references sub-24h as always available)*

`apps/ie/src/pages/translation-services-dublin.astro:83` — `'Standard delivery is 24 hours. Urgent translation — same-day, 2-hour, or faster — is always available on request.'` *(STRUCTURED-DATA + DELIVERY-PROMISE — FAQ schema)*

`apps/ie/src/pages/translation-services-dublin.astro:112` — `<h1>Translation Services Dublin<br><span class="accent">€39.99/page · 24h · ISD & Courts Accepted</span></h1>` *(DELIVERY-PROMISE — H1 subtitle)*

`apps/ie/src/pages/translation-services-dublin.astro:117` — `<span>⚡ 24h Delivery</span>` *(DELIVERY-PROMISE — visible badge)*

`apps/ie/src/pages/translation-services-dublin.astro:129` — `<li><strong>24h delivery</strong> — urgent same-day available</li>` *(DELIVERY-PROMISE)*

`apps/ie/src/pages/translation-services-dublin.astro:260/266` — `<td>24h</td>` × 2 *(DELIVERY-PROMISE — pricing table turnaround column)*

`apps/ie/src/pages/translation-services-dublin.astro:276` — `<td>Urgent (sub-24h)</td>` *(DELIVERY-PROMISE — pricing table)*

`apps/ie/src/pages/translation-services-dublin.astro:278` — `<td>Same-day / 2h</td>` *(DELIVERY-PROMISE — table cell)*

`apps/ie/src/pages/translation-services-dublin.astro:306` — `Standard delivery is 24 hours. Urgent options (same-day, 2-hour, or faster) are always available on request.` *(DELIVERY-PROMISE — body)*

`apps/ie/src/pages/translation-services-dublin.astro:325` — `Send your document — fixed quote in 15 minutes, certified translation in 24h.` *(DELIVERY-PROMISE — CTA copy)*

---

**`apps/ie/src/pages/inis-translation-guide.astro`** (15 total matches)

`apps/ie/src/pages/inis-translation-guide.astro:6` — `const description = "… Guaranteed for immigration acceptance. From €39.99/page, 24h turnaround…"` *(META-TAG + DELIVERY-PROMISE + ACCEPTANCE-GUARANTEE mixed)*

`apps/ie/src/pages/inis-translation-guide.astro:96` — `'Same-day delivery is standard for birth and marriage certificates when received before 3pm. Diplomas: 1-2 days. Complex legal: 2-3 days. Urgent 2-hour service available…'` *(STRUCTURED-DATA + DELIVERY-PROMISE — FAQ schema; makes specific same-day + cut-off time claim)*

`apps/ie/src/pages/inis-translation-guide.astro:236/241/246/261` — `<td>Same-day</td>` × 4 *(DELIVERY-PROMISE — turnaround table for specific document types)*

`apps/ie/src/pages/inis-translation-guide.astro:300` — `<h3>🚀 Same-Day (Standard)</h3>` *(DELIVERY-PROMISE — section heading calling same-day the standard tier)*

`apps/ie/src/pages/inis-translation-guide.astro:395` — `Same-day delivery for €39.99/page.` *(DELIVERY-PROMISE — CTA paragraph)*

---

**IE language / document pages** (repeated pattern across ~12 pages)

The following pattern repeats verbatim (or near-verbatim) across all IE language and document pages. Each page contains the same structural blocks:

| File | Title "24h" | Meta "24h" | Structured-data 24h | Body pill/badge | FAQ body | CTA para |
|------|-------------|------------|---------------------|-----------------|----------|----------|
| `birth-certificate-translation-ireland.astro` | ✓ | ✓ | ✓ | ✓ `⚡ 24h delivery` | ✓ `24 hours standard` | ✓ `in 24 hours` |
| `marriage-certificate-translation-ireland.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `criminal-record-translation-ireland.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `driving-licence-translation-ireland.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `police-clearance-translation-ireland.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `medical-records-translation-ireland.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `diploma-and-transcript-translation-ireland.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `divorce-decree-translation-ireland.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `arabic-translation.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `chinese-translation.astro` | likely | likely | likely | likely | likely | likely |
| `polish-translation.astro` | — | ✓ | ✓ | ✓ | ✓ | ✓ |
| `ukrainian-translation.astro` | — | ✓ | ✓ | ✓ | ✓ | ✓ |
| `polish-to-english-certified-translation.astro` | ✓ | ✓ | ✓ | ✓ stat | ✓ | ✓ |
| `ukrainian-to-english-certified-translation.astro` | ✓ | ✓ | ✓ | ✓ stat | ✓ | ✓ |
| `english-to-polish-certified-translation.astro` | likely | likely | likely | likely | likely | likely |
| `english-to-ukrainian-certified-translation.astro` | likely | likely | likely | likely | likely | likely |
| `lithuanian-translation.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `romanian-translation.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `russian-translation.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `portuguese-translation.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `immigration-translation-ireland.astro` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

Specific notable lines in this group:

`apps/ie/src/pages/polish-translation.astro:578` — `<option value="rush">Rush Service (24h)</option>` *(DELIVERY-PROMISE — in form select; same pattern in `ukrainian-translation.astro:578`)*

`apps/ie/src/pages/about.astro:96` — `<p>Urgent translation available in 2-6 hours. Standard delivery same-day or next business day.</p>` *(DELIVERY-PROMISE — claims sub-6h urgent and same-day standard)*

`apps/ie/src/pages/faq.astro:25` — `"We offer same-day certified translation service in Dublin (documents received before 12pm delivered same day). For urgent needs, we provide 2-hour express service for an additional fee. Standard turnaround is 24-48 hours."` *(DELIVERY-PROMISE — FAQ answer making both a same-day + noon-cutoff claim and a 2-hour claim)*

`apps/ie/src/pages/european-languages.astro:278` — `<li>✓ 24-hour delivery guaranteed</li>` *(DELIVERY-PROMISE + ACCEPTANCE-GUARANTEE framing — uses "guaranteed" for delivery)*

`apps/ie/src/pages/european-languages.astro:525` — `Standard delivery is 48 hours for certified translations. Rush service (24 hours) is available for €39.99/page; same-day translation is possible for urgent situations…` *(DELIVERY-PROMISE — body text; this page says 48h standard but elsewhere IE says 24h — inconsistency)*

`apps/ie/src/pages/medical-translation.astro:30` — `'Standard medical translations are delivered within 24 hours. Urgent same-day delivery is available for hospital admissions…'` *(STRUCTURED-DATA + DELIVERY-PROMISE)*

`apps/ie/src/pages/legal-translation.astro:35` — `"Same-day legal translation available for urgent court filings. Express service within 4-6 hours for critical legal deadlines."` *(DELIVERY-PROMISE — FAQ, claims 4-6h express)*

`apps/ie/src/pages/document-translation.astro:16` — `'Standard turnaround is 24–48 hours. Same-day delivery is available for urgent documents.'` *(STRUCTURED-DATA + DELIVERY-PROMISE — says 24-48h standard, inconsistent with certified pages saying 24h flat)*

`apps/ie/src/pages/data/pricing.json:20` — `"service": "Urgent Translation (sub-24h)"` *(DELIVERY-PROMISE — service name in pricing data file)*

`apps/ie/src/pages/irish-translation.astro:58` — `'Urgent turnaround shorter than 24h is always available — same-day or 2-hour slots for short documents, with weekend coverage on request.'` *(STRUCTURED-DATA + DELIVERY-PROMISE)*

---

#### UK — `apps/uk/src/**`

`apps/uk/src/pages/certified-translation.astro:6` — `const title = "Certified Translation UK | £39.99/page, 24h | UKVI Accepted"` *(META-TAG + DELIVERY-PROMISE)*

`apps/uk/src/pages/certified-translation.astro:8` — `const description = "UKVI-accepted certified translation UK. £39.99/page, 24h delivery…"` *(META-TAG + DELIVERY-PROMISE)*

`apps/uk/src/pages/certified-translation.astro:43` — `'Certified translations are £39.99 per page with 24-hour delivery for birth certificates…'` *(STRUCTURED-DATA + DELIVERY-PROMISE)*

`apps/uk/src/pages/certified-translation.astro:91` — `<p class="hero-subtitle-line">£39.99/Page • 24h Delivery • UKVI Accepted • Urgent Available</p>` *(DELIVERY-PROMISE — hero subtitle)*

`apps/uk/src/pages/certified-translation.astro:141` — `"I was quoted 5 days for a birth certificate" – We do it same-day.` *(DELIVERY-PROMISE — testimonial comparison)*

`apps/uk/src/pages/certified-translation.astro:242–246` — `<td>24h · Urgent on request</td>` × 4 (pricing table rows) *(DELIVERY-PROMISE)*

`apps/uk/src/pages/birth-certificate-translation-uk.astro:5` — `const title = "Birth Certificate Translation UK | UKVI Accepted | £39.99/page, Same-Day"` *(META-TAG + DELIVERY-PROMISE)*

`apps/uk/src/pages/birth-certificate-translation-uk.astro:6` — `const description = "… £39.99/page, same-day delivery."` *(META-TAG + DELIVERY-PROMISE)*

`apps/uk/src/pages/birth-certificate-translation-uk.astro:30` — `'Same-day for documents received before 15:00. Delivered as a certified PDF by email.'` *(STRUCTURED-DATA + DELIVERY-PROMISE — specific same-day + cut-off time claim)*

`apps/uk/src/pages/birth-certificate-translation-uk.astro:48` — `<span class="meta-pill speed">Same-day</span>` *(DELIVERY-PROMISE — visible badge)*

`apps/uk/src/pages/birth-certificate-translation-uk.astro:85` — `<div class="pricing-row urgent"><span class="pricing-label">Urgent same-day — on request</span>…</div>` *(DELIVERY-PROMISE)*

`apps/uk/src/pages/ukvi-translation-guide.astro:6` — `const description = "… £29.99/page UK pricing and same-day delivery. Acceptance guaranteed. Quote in 10 mins."` *(META-TAG + DELIVERY-PROMISE — also note price discrepancy: £29.99 vs locked £39.99)*

`apps/uk/src/pages/ukvi-translation-guide.astro:104` — `Acceptance guaranteed or we reissue free.` *(ACCEPTANCE-GUARANTEE)*

`apps/uk/src/pages/ukvi-translation-guide.astro:233` — `certified translation ready within 24 hours, same-day for urgent cases.` *(DELIVERY-PROMISE — body CTA)*

`apps/uk/src/pages/european-languages.astro:277` — `<li>✓ 24-hour delivery guaranteed</li>` *(DELIVERY-PROMISE — same violation as IE)*

`apps/uk/src/pages/european-languages.astro:524` — `Standard delivery is 48 hours for certified translations. Rush service (24 hours) is available for £39.99/page; same-day translation is possible for urgent situations…` *(DELIVERY-PROMISE — contradicts certified-translation.astro which says 24h standard)*

`apps/uk/src/pages/faq.astro:21` — `"Certified translations are £39.99 per page with 24-hour delivery."` *(DELIVERY-PROMISE)*

`apps/uk/src/pages/faq.astro:70` — `"we can often provide interpreters within 4-24 hours depending on language and location"` *(DELIVERY-PROMISE — interpreting, borderline: this is about interpreter confirmation time, not translation delivery)*

`apps/uk/src/pages/about.astro:96` — `<p>Urgent translation available in 2-6 hours. Standard delivery same-day or next business day.</p>` *(DELIVERY-PROMISE — same as IE about.astro)*

`apps/uk/src/data/pricing.json:15` — `"service": "Urgent Translation (same-day)"` *(DELIVERY-PROMISE — service name in pricing data)*

`apps/uk/src/data/pricing-uk.json:15` — `"service": "Urgent Translation (same-day)"` *(DELIVERY-PROMISE — duplicate in UK-specific pricing file)*

`apps/uk/src/pages/interpreting.astro:265` — `Certified Translation (A4 = 250 words) — £39.99 per page — 24h delivery` *(DELIVERY-PROMISE — cross-sell table on interpreting page)*

**UK document-specific pages with same-day in title/meta/schema:**
- `marriage-certificate-translation-uk.astro` — same-day in title/meta/schema/badge
- `criminal-record-translation-uk.astro` — 24h in title/meta
- `death-certificate-translation-uk.astro` — 24h/same-day in title/meta/schema
- `diploma-and-degree-translation-uk.astro` — 24h in title/meta
- `driving-licence-translation-uk.astro` — same-day in meta/schema
- `bank-statement-translation-uk.astro` — same-day likely
- `family-visa-translation.astro` — same-day in title/meta
- `ilr-translation.astro` — same-day likely
- `ukvi-certified-translation.astro` — same-day in meta/schema
- `asylum-translation.astro` — 24h/same-day likely
- `spouse-visa-translation.astro` — same-day in title/meta/schema (6 same-day matches)
- `student-visa-translation.astro` — `'Same-day for short documents received before 15:00.'`
- `visitor-visa-translation.astro` — likely
- `citizenship-translation.astro` — likely
- `employment-letter-translation-uk.astro` — likely
- `skilled-worker-visa-translation.astro` — likely
- `polish-translation.astro:432/542` — `✓ 24-hour delivery` + `<option value="rush">Rush Service (24h)</option>`
- `ukrainian-translation.astro:432/504` — same pattern

---

#### ES — `apps/es/src/**`

`apps/es/src/pages/certified-translation.astro:139` — `"I was quoted 5 days for a birth certificate" — We do it same-day.` *(DELIVERY-PROMISE — testimonial, same pattern as UK)*

`apps/es/src/pages/certified-translation.astro:290–291` — `100% guaranteed or reissue free` / `No guarantees given` *(ACCEPTANCE-GUARANTEE — comparison table)*

`apps/es/src/pages/european-languages.astro:276` — `<li>✓ 24-hour delivery guaranteed</li>` *(DELIVERY-PROMISE — same violation as IE/UK)*

`apps/es/src/pages/european-languages.astro:523` — `Standard delivery is 48 hours for certified translations. Rush service (24 hours) is available for €39.99/page; same-day translation is possible for urgent situations…` *(DELIVERY-PROMISE — incorrect pricing: should be €49.99 standard; also contradicts certified-translation.astro)*

`apps/es/src/pages/document-translation.astro:39` — `<strong>24h Rush</strong>` *(DELIVERY-PROMISE — trust bar badge)*

`apps/es/src/pages/document-translation.astro:53` — `<span class="dt-chip-label">Rush 24h</span><span class="dt-chip-value">+50%</span>` *(DELIVERY-PROMISE — pricing chip)*

`apps/es/src/pages/faq.astro:21` — `"Certified translations are €49.99 per page (urgent €64.99) with 24-hour delivery."` *(DELIVERY-PROMISE — price correct; 24h delivery still flat claim)*

`apps/es/src/pages/faq.astro:145` — `Turnaround 24 hours, cost €49.99 per page (urgent €64.99)` *(DELIVERY-PROMISE — driving licence FAQ)*

`apps/es/src/pages/apostille-service.astro:364` — `<div class="stat-number">24h</div>` *(DELIVERY-PROMISE — stat block)*

`apps/es/src/pages/polish-translation.astro:436/546` — `✓ 24-hour delivery` + `Rush Service (24h)` form option *(DELIVERY-PROMISE)*

`apps/es/src/pages/ukrainian-translation.astro:436/508` — same pattern *(DELIVERY-PROMISE)*

---

#### PT — `apps/pt/src/**`

`apps/pt/src/pages/certified-translation.astro:141` — `"I was quoted 5 days for a birth certificate" – We do it same-day.` *(DELIVERY-PROMISE)*

`apps/pt/src/pages/european-languages.astro:278` — `<li>✓ 24-hour delivery guaranteed</li>` *(DELIVERY-PROMISE — same 4-market violation)*

`apps/pt/src/pages/european-languages.astro:525` — `Standard delivery is 48 hours… Rush service (24 hours) is available for €64.99/page; same-day translation is possible…` *(DELIVERY-PROMISE — price is correct for PT urgent; 48h standard incorrect — should be 24–48h depending on page count)*

`apps/pt/src/pages/document-translation.astro:39/53/359` — `24h Rush` / `Rush 24h +50%` / `Rush Rate (24h)` *(DELIVERY-PROMISE — same pattern as ES)*

`apps/pt/src/pages/apostille-service.astro:373` — `<div class="stat-number">24h</div>` *(DELIVERY-PROMISE — stat block)*

`apps/pt/src/pages/faq.astro:21` — flat 24h claim with €49.99 standard pricing *(DELIVERY-PROMISE)*

`apps/pt/src/pages/faq.astro:145` — `Turnaround 24 hours, cost €49.99 per page (urgent €64.99)` *(DELIVERY-PROMISE)*

`apps/pt/src/pages/polish-translation.astro:436/546` — `✓ 24-hour delivery` + `Rush Service (24h)` *(DELIVERY-PROMISE)*

`apps/pt/src/pages/ukrainian-translation.astro:436/508` — same *(DELIVERY-PROMISE)*

---

### ACCEPTANCE-GUARANTEE — leave alone

These are about whether authorities will accept the translation, not about turnaround time. No rewrite needed.

`apps/{ie,uk,es,pt}/src/pages/apostille-service.astro` — `Guaranteed Acceptance`, `Guaranteed completion`, `we guarantee acceptance when the document is properly executed` (4 occurrences across 4 markets)

`apps/{ie,uk,es,pt}/src/pages/certified-translation.astro` — `We guarantee acceptance when documents are submitted intact and unaltered. If any authority raises a query, we correct and reissue at no charge.` (4 markets — STRUCTURED-DATA + body)

`apps/ie/src/pages/translation-services-dublin.astro` — `ISD-accepted service`, `guaranteed accepted — or reissued free`, `We guarantee acceptance — or we reissue free of charge` (3 occurrences)

`apps/uk/src/pages/ukvi-translation-guide.astro` — `Acceptance guaranteed or we reissue free`, `We guarantee acceptance for UKVI submissions` (2 occurrences)

`apps/uk/src/pages/ukvi-certified-translation.astro` — `'Do you guarantee UKVI acceptance?' … 'Yes. We guarantee every translation meets Para 39B requirements.'` (STRUCTURED-DATA + body)

`apps/ie/src/pages/immigration-translation-ireland.astro:177` — `acceptance guaranteed for any rejection attributable to our work, or full refund` *(ACCEPTANCE-GUARANTEE — note: "full refund" for rejections attributable to our work may need legal review against T&Cs §11 which reserves refund for impossibility, not errors)*

`apps/ie/src/pages/inis-translation-guide.astro:6` — `const description = "… Guaranteed for immigration acceptance…"` *(META-TAG + ACCEPTANCE-GUARANTEE — mixed with 24h turnaround claim in same string)*

`apps/{ie,uk,es,pt}/src/pages/terms.astro:42` — `We do not guarantee acceptance where third party requirements change or are misrepresented by the client.` *(ACCEPTANCE-GUARANTEE — T&Cs qualification, leave alone)*

---

### OTHER — not delivery-related

**Recruitment replacement guarantee in non-recruitment files** (do not rewrite — these are in recruitment service sections of shared pages, out of scope for this audit):
- `apps/{ie,uk,es,pt}/src/pages/index.astro` — "Replacement guarantee included", "Replacement & Guarantee" service card, 8-week guarantee row
- `apps/{ie,uk,es,pt}/src/pages/faq.astro:94–95` — "What is your replacement guarantee?" FAQ entry
- `apps/{ie,uk,es,pt}/src/pages/terms.astro:48` — "8-week replacement guarantee"

**Confidentiality guarantee** (leave alone):
- `apps/{ie,uk,es,pt}/src/pages/legal-translation.astro` — "Strict Confidentiality Guarantee" section heading
- `apps/{ie,uk,es,pt}/src/pages/interpreting.astro` — "confidentiality guaranteed"
- `apps/{ie,uk,es,pt}/src/pages/phone-interpreting.astro` — "GDPR compliant — confidentiality guaranteed"

**Revision guarantee** (quality, not turnaround — leave alone):
- `apps/{ie,uk,es,pt}/src/pages/document-translation.astro:451/466` — `<h3>Revision Guarantee</h3>`

**"Instant SmartQuote™" brand name** (not a delivery promise — it refers to the quote widget):
- `packages/ui/src/components/CtaCluster.astro` — "Instant SmartQuote™" (button label)
- `packages/ui/src/components/LangHero.astro:66` — `ctaText = 'Instant SmartQuote™'`
- `apps/uk/src/pages/certified-translation.astro:8` — `Instant SmartQuote™` in meta description
- `packages/ui/src/components/SmartQuoteDrawer.astro` — multiple aria-label mentions of "instant translation price" (not a delivery claim)
- `packages/ui/src/components/SmartQuoteForm.astro:108` — "Get instant quote on WhatsApp" (WhatsApp CTA button — not delivery)

**Admin internal only** (not customer-facing):
- `packages/ui/src/components/AdminApp.tsx:1086` — `'Standard: €39.99/page, delivered in 24–48 hours. Urgent: €49.99/page, delivered in under 24 hours.'` *(Internal admin FAQ. Note: urgent pricing here is €49.99 which is IE/UK correct but would be wrong for ES/PT context — minor data issue but not customer-facing)*
- `packages/ui/src/components/Dashboard.tsx:90` — `quoted >24h` (internal admin dashboard label)
- `packages/ui/src/components/OrderBoard.tsx:507` — `'24–48h · €39.99/p'` / `'<24h · €49.99/p'` (internal admin board display)
- `packages/ui/src/components/OrderDetail.tsx:156/662` — `'Urgent (<24h)'` / `'Standard (24-48h)'` (internal admin order detail)
- `packages/ui/src/components/NotificationSettings.tsx:30` — `'Payment overdue (24h+)'` (admin notification label)

---

## Hot-spot files

Rewrite-priority order by **DELIVERY-PROMISE match count** (estimated; includes title, meta, schema, and body hits together):

| Rank | File | Est. DELIVERY-PROMISE hits | Notes |
|------|------|---------------------------|-------|
| 1 | `packages/ui/src/layouts/BaseLayout.astro` | 4 direct / **all pages affected** | Default title templates + default description — highest leverage; fixing here cascades to every page that doesn't override |
| 2 | `apps/ie/src/pages/certified-translation.astro` | ~18 | Flagship IE page; all location tags (title, meta, schema, body, trust bar, FAQ) |
| 3 | `apps/ie/src/pages/translation-services-dublin.astro` | ~16 | Pricing table, H1 subtitle, schema product name, FAQ schema |
| 4 | `apps/uk/src/pages/certified-translation.astro` | ~14 | Same structure as IE; hero subtitle, schema, testimonial comparison, pricing table |
| 5 | `apps/ie/src/pages/inis-translation-guide.astro` | ~12 | "Same-Day (Standard)" section heading; turnaround table; specific noon cut-off claim |
| 6 | `apps/pt/src/pages/certified-translation.astro` | ~11 | Same pattern as UK/ES |
| 7 | `apps/es/src/pages/certified-translation.astro` | ~11 | Same pattern |
| 8 | `packages/ui/src/components/LangHero.astro` | 1 direct / **all language pages affected** | Default `turnaround = 'Same-day'` prop — cascades to all IE language pages |
| 9 | `packages/ui/src/components/SmartQuoteDrawer.astro` | 1 visible line / **all 4 markets** | "Certified translators · same-day delivery" shown to every visitor |
| 10 | `apps/ie/src/pages/faq.astro` | ~5 | Explicit noon cut-off same-day claim + 2-hour express claim |

> `BaseLayout.astro` and `LangHero.astro` are the two highest-leverage files. A change to the BaseLayout default title templates alone updates every page on IE and UK that doesn't supply its own title. A change to the LangHero default turnaround prop updates the visible badge on every language page.

---

## SEO-sensitive subset

Every match inside `const title =`, `const description =`, or JSON-LD structured data. Changes here affect Google rich results, title tags indexed by crawlers, and FAQ schema snippets.

**Changes in this subset require:**
1. Keyword impact check — "24h", "same-day" are likely in indexed anchor text
2. Redirect or redirect-free rewrite (title changes don't require redirects, but removing high-CTR keywords from titles may affect click-through)
3. Structured-data resubmission via GSC after deploy

**META-TAG matches (title/description):**

| File | Line | Pattern |
|------|------|---------|
| `BaseLayout.astro:57` | default IE/UK title template | `\| Same-Day \|` |
| `BaseLayout.astro:60` | default IE title template | `\| Same-Day \|` |
| `BaseLayout.astro:62` | default fallback description | `"Same-day delivery."` |
| `apps/ie/src/pages/certified-translation.astro:5` | title tag | `24h` |
| `apps/ie/src/pages/certified-translation.astro:8` | description | `24h delivery` |
| `apps/ie/src/pages/translation-services-dublin.astro:5` | title | `Same-Day` |
| `apps/ie/src/pages/translation-services-dublin.astro:6` | description | `24h delivery` |
| `apps/ie/src/pages/inis-translation-guide.astro:6` | description | `24h turnaround` |
| `apps/uk/src/pages/certified-translation.astro:6` | title | `24h` |
| `apps/uk/src/pages/certified-translation.astro:8` | description | `24h delivery` |
| `apps/uk/src/pages/birth-certificate-translation-uk.astro:5` | title | `Same-Day` |
| `apps/uk/src/pages/birth-certificate-translation-uk.astro:6` | description | `same-day delivery` |
| `apps/uk/src/pages/ukvi-translation-guide.astro:6` | description | `same-day delivery` *(also has price discrepancy: £29.99 not £39.99)* |
| Every IE language page (`arabic-translation.astro`, `birth-certificate-translation-ireland.astro`, `marriage-certificate-translation-ireland.astro`, `criminal-record-translation-ireland.astro`, `driving-licence-translation-ireland.astro`, `police-clearance-translation-ireland.astro`, `medical-records-translation-ireland.astro`, `diploma-and-transcript-translation-ireland.astro`, `divorce-decree-translation-ireland.astro`, `polish-to-english-certified-translation.astro`, `ukrainian-to-english-certified-translation.astro`, `romanian-translation.astro`, `russian-translation.astro`, `lithuanian-translation.astro`, `portuguese-translation.astro`) | title + description | `24h` or `24h delivery` |
| `apps/ie/src/pages/european-languages.astro:7` | description | `Same-day` |
| `apps/ie/src/pages/medical-translation.astro:7` | description | `Same-day available` |
| `apps/ie/src/pages/document-translation.astro:26` | description | `same-day certified available` |
| `apps/ie/src/pages/legal-translation.astro:7` | description | `same-day service` |
| `apps/ie/src/pages/apostille-service.astro:7` | description | `Same-day service` |
| `apps/ie/src/pages/interpreting.astro:9` | description | `Same-day booking` *(interpreting only — borderline)* |
| `apps/ie/src/pages/medical-interpreting.astro:6` | description | `Book same-day` *(interpreting — borderline)* |
| `apps/ie/src/pages/phone-interpreting.astro:7` | description | `Same-day availability` *(interpreting — borderline)* |

**STRUCTURED-DATA matches (JSON-LD schema, FAQPage, service descriptions):**

| File | Line | Pattern |
|------|------|---------|
| `BaseLayout.astro:375` | JSON-LD service schema | `"Same-day urgent translation with fast delivery."` |
| `apps/ie/src/pages/certified-translation.astro:160` | FAQPage schema | `'Standard delivery is 24 hours. For urgent cases — same-day, 2-hour, or faster…'` |
| `apps/ie/src/pages/translation-services-dublin.astro:19` | service schema description | `'€39.99/page, 24h delivery.'` |
| `apps/ie/src/pages/translation-services-dublin.astro:29` | service schema name | `'Standard Certified Translation — 24h Delivery'` |
| `apps/ie/src/pages/translation-services-dublin.astro:43` | service schema text | `'24h standard delivery.'` |
| `apps/ie/src/pages/translation-services-dublin.astro:59` | FAQ schema | `'Urgent delivery shorter than 24h is always available on request.'` |
| `apps/ie/src/pages/translation-services-dublin.astro:83` | FAQ schema | `'Standard delivery is 24 hours. Urgent translation — same-day, 2-hour, or faster…'` |
| `apps/ie/src/pages/inis-translation-guide.astro:96` | FAQ schema | `'Same-day delivery is standard… when received before 3pm'` |
| `apps/ie/src/pages/medical-translation.astro:30` | FAQ schema | `'Standard medical translations are delivered within 24 hours.'` |
| `apps/ie/src/pages/legal-translation.astro:65` | FAQ schema | `'Same-day legal translation available for urgent court filings. Express service within 4-6 hours…'` |
| `apps/ie/src/pages/document-translation.astro:15–16` | FAQ schema | `'Rush turnaround (same-day)…'` / `'Same-day delivery is available for urgent documents.'` |
| `apps/ie/src/pages/irish-translation.astro:58` | FAQ schema | `'Urgent turnaround shorter than 24h is always available…'` |
| `apps/ie/src/pages/european-languages.astro:40` | FAQ schema | `'same-day delivery'` for UKVI |
| `apps/ie/src/pages/court-interpreting.astro:30` | FAQ schema | `'Same-day and urgent court assignments…'` *(interpreting — borderline)* |
| `apps/ie/src/pages/interpreting.astro:128` | FAQ schema | `'Same-day availability is standard for most language pairs.'` *(interpreting — borderline)* |
| Every IE language page | FAQ schema answer | `'Standard turnaround is 24 hours from receipt of clear scan or photo.'` |
| `apps/uk/src/pages/certified-translation.astro:43` | FAQ schema | `'£39.99 per page with 24-hour delivery'` |
| `apps/uk/src/pages/ukvi-certified-translation.astro:35` | FAQ schema | `'We guarantee every translation meets Para 39B requirements.'` *(ACCEPTANCE-GUARANTEE)* |
| `apps/uk/src/pages/birth-certificate-translation-uk.astro:30` | FAQ schema | `'Same-day for documents received before 15:00.'` |
| `apps/uk/src/pages/student-visa-translation.astro:31` | FAQ schema | `'Same-day for short documents received before 15:00. Academic transcripts typically 24 hours.'` |
| `apps/es/src/pages/certified-translation.astro:40` | FAQ schema | `'We guarantee acceptance when documents are submitted intact…'` *(ACCEPTANCE-GUARANTEE)* |
| `apps/pt/src/pages/certified-translation.astro:42` | FAQ schema | same pattern *(ACCEPTANCE-GUARANTEE)* |

---

## Open questions for desktop chat

1. **"Urgent on request" — keep or drop?** The locked ETA bands cover *standard* tiers. Every IE page currently advertises a `sub-24h` urgent option as "always available." Is this still true post-ETA-band rewrite, or is urgent being dropped in favour of the 1-3/4-6/7-10 page bands only? This affects ~40 structured-data FAQPage answers and pricing tables.

2. **Same-day for interpreting — leave alone?** "Same-day booking available" on interpreting pages is about confirming an interpreter, not a translation window. It's operationally accurate. Desktop to confirm whether interpreting availability claims are in scope for this rewrite or out of scope (they're not translation delivery promises).

3. **BaseLayout default titles** — IE title template currently reads `🏆 Certified Translation Dublin | Same-Day | All Languages | ISD Accepted | ${site.name}`. What's the replacement wording? This needs a copy decision before code can touch it.

4. **LangHero `turnaround` prop** — currently defaults to `'Same-day'`. What should the new default be? Options: remove the badge entirely, replace with `'From 24h'`, `'24–48h'`, or inject from page-level config. Requires desktop to agree wording.

5. **SmartQuoteDrawer "same-day delivery" bullet** — this is shared across all 4 markets. Replacement needs to work in all market contexts (IE standard = 24h for 1-3 pages; UK same; ES/PT standard = 24-48h by page count). Probably needs to say something like "delivery within 24–48h" or the more accurate dynamic language. Desktop to confirm.

6. **SmartQuoteForm line 346** — "You'll receive a confirmation by email within 24 hours." Is this about the quote confirmation or the translation delivery? If it's the quote confirmation only, wording is fine. If a customer might read it as "your translation in 24 hours," it needs softening. Desktop to clarify intent.

7. **`inis-translation-guide.astro` turnaround table** — currently claims "Same-day" for birth, marriage, criminal records, diplomas. Post-rewrite, should this table use the dynamic ETA bands (1-3 pages = 24h, 4-6 = 36h, etc.) or a simpler "from 24h" range? This page is likely high-traffic for ISD queries.

8. **`european-languages.astro`** — "Standard delivery is 48 hours for certified translations" (on ES/PT/UK/IE). This contradicts `certified-translation.astro` which says 24h standard. Which is correct? The locked decision says 1-3 pages = 24h, 4-6 = 36h, 7-10 = 48h — so 48h is only correct for 7-10 pages. The european-languages.astro page needs to be aligned. Confirm whether it should show the full band table or a range like "24–48h depending on page count."

9. **`about.astro` (IE/UK)** — "Urgent translation available in 2-6 hours. Standard delivery same-day or next business day." This claims 2-6h urgent as a standard service offering. Is this still accurate? If urgent is "on request" only, this claim needs rewording. Desktop to confirm.

10. **`ukvi-translation-guide.astro:6`** — Meta description contains `£29.99/page` which is wrong (locked price is £39.99). This is a data error that should be fixed regardless of the ETA rewrite — it's live in a meta description and could affect conversion. Flag to fix as a quick standalone fix.

11. **"24-hour delivery guaranteed" on european-languages.astro across all 4 markets** — this is the most direct T&Cs §3 conflict: it uses "guaranteed" for a delivery time, directly contradicting the reasonable-endeavours clause. This one is a clear fix regardless of how the broader copy rewrite is framed. Desktop to confirm it's OK to kill this specific line in the next dev session without waiting for the full copy decision.

---

*Audit run by Claude Code, 07/06/26. No monorepo files edited. Report is inventory only.*
