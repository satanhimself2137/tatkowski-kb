# IE Competitor Landscape

Last updated: 09/06/26. This file consolidates everything we know about IE competitors — interpreting-focused agencies (the ones magda will hit in B2B outreach) plus translation-volume players (the ones we benchmark against on SEO and page count). Pricing intel and the reusable scraper rig also live here.

We are NOT entering an empty market. There are real incumbents in Ireland with established public-sector and corporate accounts. Knowing them by name keeps the team from assuming green fields when pitching.

---

## INTERPRETING-FOCUSED INCUMBENTS (the B2B competition magda hits)

### Tier 1

**Translit (translit.com)** — The biggest IE interpreting-first agency. Award-winning, self-positioned as the trusted partner to "major public services, private sector organisations and central government bodies". 500+ languages and dialects on roster. Dominant in **public sector**: HSE-adjacent work, courts, government bodies. Most large IE hospitals likely have a Translit relationship or have at least quoted them. **Treat as the default incumbent** when reaching out to any hospital, large state-adjacent employer, or public body. Assume they've heard of Translit.

**Translation.ie** — 20+ years in IE. Self-positions as "the leading translation, localisation and interpreting services provider in Ireland and Europe". Translation + interpreting both core. Strong on enterprise translation + localisation more than pure interpreting volume.

### Tier 2

**FLEX Language Services (flexlanguageservices.com)** — HQ Belfast (NI), Dublin office. 500+ interpreters and translators on roster. Cross-border NI/IE positioning. Likely strong on Belfast-Dublin corridor and any NI-IE business work.

**Interling Translations (interling.ie)** — Dublin, founded 2003. Business, medical, legal focus. Director personally oversees each project — closer to our model in style, but smaller and older.

**DCU Language Services (dculs.dcu.ie)** — Dublin City University's in-house agency. Strong on academic + public-sector contracts via university affiliation.

---

## TRANSLATION-VOLUME COMPETITORS (the SEO benchmark)

Findings from the 20/05/26 scrape (D:\Users\adern\Downloads\data\scape competition\ — note typo "scape", on C: not D:). Re-run before specing new pages.

### IE
| Competitor | Page count | Language pages | Notes |
|---|---|---|---|
| certifiedtranslations.ie | 1,112 | 642 | Market leader by page volume. Wins on language coverage. |
| thetranslationcompany | — | — | Pricing intel: "from EUR 14.99" — we're premium at 39.99, justify via certification + QR + 24h. |

### UK
| Competitor | Page count | Notes |
|---|---|---|
| translayte | 1,395 | 155 lang + 225 blog. Heavy blog play. Survived March 2026 core update by building real authority-list specificity per page (not keyword-swap templates). |
| absolutetranslations | 1,343 | 260 lang + 108 doc. |
| TS24 | — | Per-word: GBP 0.08/word |
| espresso translations | — | Per-word: GBP 0.10–0.25/word |

### ES
- Leaders run 300–420 pages.
- **juratrad** — Traducción jurada EUR 28–36/page (vs our EUR 49.99 standard / 64.99 urgent).

### PT
- Thin market overall.
- **alphatrad** ~391 pages, the rest <120.

### Key SEO takeaway
Market leaders win on **language + document page volume**, not technical depth. Build out language + doc-type clusters. UK leaders lean heavily on blog content — consider blog for UK specifically.

---

## Pricing intel (consolidated)

| Market | Our price | Competitor range | Position |
|---|---|---|---|
| IE certified | EUR 39.99/page (24h) | EUR 14.99+ (thetranslationcompany) | Premium — justify via 24h + cert + QR |
| UK certified | GBP 39.99/page (24h) | GBP 0.08–0.25/word (TS24, espresso) | Premium per-page, comparable when normalised |
| ES jurada | EUR 49.99 std / 64.99 urgent | EUR 28–36 (juratrad) | Premium — justify via urgent option + IE Ltd backing |
| PT certificada | EUR 49.99 std / 64.99 urgent | Thin market, sparse benchmarks | First-mover-ish in modern-intake segment |

---

## Where we win against incumbents

- **Speed.** 24h turnaround on certified docs vs their typical 3–5 days.
- **Intake.** WhatsApp first-touch + AI quoting vs their web forms + phone + 24–48h quote turnaround.
- **No retainer / no minimums.** Per-job pricing vs their preference for account setup and ongoing engagement.
- **Direct-to-founder relationship.** No account manager layer for mid-sized clients.
- **Modern stack.** Magic-link drawer, QR-validated PDFs, instant payment links — incumbents are paper-and-PDF-via-email shops.

## Where they win against us

- **Existing public-sector contracts.** Translit in particular has multi-year framework agreements locked in.
- **ISO certifications and procurement-friendly compliance.** ISO 9001 / 17100 / 27001 carry weight in tender processes.
- **Language breadth.** 500+ languages vs our active 50+.
- **Track record at scale.** 20+ years of references vs our 6 months.
- **Page volume on SEO.** Translayte and certifiedtranslations.ie outweigh us 10x+ on indexable pages.

---

## Practical implications for outreach (magda + future B2B)

1. **Assume every hospital and large employer has had a Translit (or Translation.ie) quote already.** Pitch can't be "do you need translation?" — it has to be "are you tired of waiting 3 days for a quote?"
2. **Don't compete on tenders.** We lose to ISO-certified incumbents on procurement-driven bids. Win on ad-hoc, mid-sized, speed-sensitive work and grow the relationship from there.
3. **Lead with speed and modern intake** in every outreach email — that's the actual differentiator.
4. **For public sector specifically**, don't expect to displace Translit head-on. Target the private sector and private hospitals first; public bodies are a multi-year compliance battle.

## Practical implications for SEO (Maciej + product)

1. **Build out language + doc-type page clusters** until we match the leaders. Polish + Ukrainian already Gen3 (1555–1600 lines). Russian, Romanian, Arabic, Chinese, Lithuanian, Portuguese stubs still Gen1 — rebuild to Gen3 template.
2. **Consider a UK blog play** — translayte's survival of the March 2026 core update was built on blog + authority-list content, not template tricks.
3. **PT is the highest-leverage market for programmatic SEO** — incumbents thin, no programmatic players, page-count gap to leadership is small (~400 pages).

---

## Competitor scrape rig (reusable)

**Location:** `C:\Users\adern\Downloads\data\scape competition\` (note typo "scape", on **C:** not D:).
**Stack:** Puppeteer + Cheerio.
**Scripts:**
- `scrape-competitors.js` — content scraper (title, meta, pricing signals, review signals)
- `map-competitor-structure.js` — page-count taxonomy by category
**Outputs:** `competitor-data/` + `competitor-structure/` (each: `raw/` + `reports/` + `summary.md`)
**Status:** `node_modules` present, runs as-is.
**LIMITATION:** content scrape is SHALLOW (0–5 pages per competitor). Re-run deeper before using output to spec new pages — crawl the language/doc pages, capture H1/H2/word-count/schema/internal-links. A deeper scraper (`scrape-competitors-deep.js`) was written and syntax-checked; needs run after structure mapper refresh.

---

## Watch list (re-check quarterly)

- Are any of the incumbents (Translit, Translation.ie, FLEX) launching WhatsApp / AI intake?
- Are any new IE-focused interpreting-first agencies launching?
- Pricing benchmark — what are they actually charging private clients per page / per interpreter hour?
- Page count growth — re-scrape competitor sitemaps quarterly to track their content velocity.