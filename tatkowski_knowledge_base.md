# TATKOWSKI INTERPRETING & RECRUITMENT LIMITED — COMPANY KNOWLEDGE BASE
**Last updated: 05 June 2026**
**Version: 5.4**
*Living company bible. Master copy on GitHub: https://github.com/satanhimself2137/tatkowski-kb — read/written by Claude via tools/kb.ps1 over gh api + Desktop Commander (stateless, no local clone). Project file auto-loads in Claude sessions; replace after significant updates.*

**STALE-DATA RULE:** Financial figures, GSC data, order statuses, and outstanding payments are accurate as of the date above. When working more than 7 days after this date, treat anything marked "as of [date]" or "outstanding" as potentially changed — check live sources (email, Revolut, GSC) before acting.

---

## TABLE OF CONTENTS
1. Company Overview & Legal Structure
2. Team & Responsibilities
3. Services, Pricing & Operational Workflows
4. Pricing by Market
5. Client Order History
6. Sales & Outreach
7. SEO, Website & Online Presence
8. Google Business Profile History
9. Recruitment Division
10. Translator & Interpreter Network
11. Tools, Platforms & Accounts
12. Key Operational Decisions & Principles
13. Pending Items & Next Actions
14. Financial Overview
15. Tech Infrastructure & Architecture
16. SalesManager Portal
17. Broader Vision — Tatkowski Systems

---

## 1. COMPANY OVERVIEW & LEGAL STRUCTURE

**Full legal name:** Tatkowski Interpreting & Recruitment Limited
**CRO Number:** 803790
**Type:** LTD — Private Company Limited by Shares (Companies Act 2014)
**Status:** Normal
**Registered:** 15 December 2025
**Constitution signed:** 21 November 2025
**B1 Annual Return: filed 4 June 2026** (deadline 15 June 2026)

**Registered Address:** Apartment 32, The Green, Strand Street, Malahide, Dublin, K36 KV97, Ireland
*(Constitution lists 26 Castle Grove, Swords Demesne, K67 AE03 — pre-move. B2 filed 2 Feb 2026, CRO updated.)*

**Share Capital:** 100 Ordinary Shares of EUR 1.00 each, all held by Maciej Tatkowski (100%)
**Corporation Tax Ref:** 4724773JH
**First accounting period:** 15 Dec 2025 to 31 Dec 2026 | **First CT1 due:** 23 September 2027
**Director:** Maciej Tatkowski (DOB: 28/10/1992, Polish nationality)
**Company Secretary:** Magdalena Lewkowska (DOB: 26/06/2000)
**NACE Code:** 7430

**Markets:** Ireland live + earning | UK live, first organic clicks June 2026 | Spain live | Portugal live (20 May 2026)

---

## 2. TEAM & RESPONSIBILITIES

### Maciej Tatkowski — Director
- Ireland and UK operations; all technical/coding work; strategy
- Background: SCADA, Kibana/Elastic Stack, AWS, process automation, WMS, Telegram bot dev. Built ToH monitoring system at Royal Mail.
- Based in Malahide. UK Settled Status.
- +353 83 871 0861 | contact@tatkowski.com | Passport: ET5501820
- Windows machine — PowerShell-first.

### Magdalena Lewkowska — HR Lead & Co-founder
- Legal CRO title: Company Secretary.
- Based in Malahide. Maciej's partner and soon-to-be wife.
- Brand, social media (Facebook, LinkedIn, Instagram), admin, directories
  - Social profile URLs (confirmed 05/06/26): Facebook https://www.facebook.com/profile.php?id=61586714891353 ; Instagram https://www.instagram.com/contact_tatkowski/ ; LinkedIn company page exists but exact URL not yet recorded - get slug from Magda.
- B10 forms SR8705989 + SR8706130 registered 2 June 2026.

### Artur Pawłowski — Sales Manager
- Informally helping. Will eventually run UK operations.
- Fiverr account connected via invite.

### David Briceag — Regional Manager, Spain & Portugal
- Numbers: +351 927 901 200 = personal (runs his current WhatsApp Business / sender line, NOT public). +351 931 052 612 = COMPANY Business WhatsApp = PUBLIC NAP for PT (citations/website/GBP), human-answered for corporate + interpreting clients. +351 931 052 617 = AI / Cloud API (translation intake via AI + Chatwoot port in SalesManager). | Email: contact@tatkowski.com (shared M365)
- PT address (for citations/NAP): Avenida São João de Deus, Edifício Príncipe Real, Lote 1, 1C, 8500-500 Portimão, Algarve
- Commission-based contractor. Contractor Agreement + non-compete SIGNED - returned 17 May 2026 from davidjo9@hotmail.com ("David Briceag Signed Agreement May.pdf", single combined PDF, in contact@ mailbox). Risk closed.
- Fiverr Pro: davidjo9@hotmail.com
- David ADDED as tatkowski-kb repo collaborator (confirmed 05/06/26). His Claude can read+write the repo. GSC analysis guide sent via TEAM ONE 05/06/26 (gsc/HOW_TO.md).
- PT WhatsApp AI number: 931 052 617 (fresh eSIM, confirmed by David 05/06/26 as the AI/Cloud API line). Handles translation intake via AI + Chatwoot port in SalesManager. Distinct from 931 052 612 (human company WhatsApp). NOTE: 612 vs 617 differ by one digit - do not conflate.

---

## 3. SERVICES, PRICING & OPERATIONAL WORKFLOWS

### Phase 1: Certified Translations (active)

**Pricing — Ireland & UK:**
- Single rate: EUR 39.99/page (IE) | GBP 39.99/page (UK) — 24-hour standard delivery
- Handwriting surcharge: +EUR 5.00/page
- Postage (hard copy): +EUR 10 flat
- Orders over 3 pages or 750 words may need additional time — caveat in quote

**Pricing ����� Portugal & Spain:**
- Standard (24-48h): EUR 49.99/page
- Urgent (within 24h): EUR 64.99/page

**Rules (all markets):**
- Per-page only �� never flat per-document
- Quote total to client only — never show per-page breakdown
- Confirm language pair before committing to turnaround
- B2B clients: round numbers, invoice-based, no .99 on interpreting

**Package pricing:**
- For 6+ page enquiries, hold quote until scans seen
- Frame discount as package rate, never as response to client's own draft translation
- Reserve 10-15% room to drop if client hesitates

**What is included:**
- Full translation, Certificate of Accuracy, translator credentials, company branding
- QR validation code embedded in final PDF (validate.tatkowski.com/[ref])
- 90-day document storage and re-download via private drawer link

**Standard DOCX layout (Vovka/Emerson format ��� confirmed 3 June 2026):**
- Page 1: mirrors original document layout — red official header band, reference number, centred title, justified body text, two-column stamp/signature block at bottom
- Page 2: translator certification statement with embedded signature image
- Logo: tatkowski_INTERPRETING_AND_REC.png, centred, ~0.3in from top, scaled to 24% of original file size
- Logo background must be cleanly removed — widen threshold to avoid edge artefacts

**SmartQuote form (redesigned 20 May 2026):**
- Step 1: Client details (name, email, phone + WhatsApp checkbox + delivery preference). Non-Latin name detection triggers Latin spelling field.
- Step 2: Document upload — AI analyses page count, doc type, language, price. Client confirms language pair.
- Step 3: Review and pay — urgency toggle, total price, Revolut checkout.
- Every Step 1 = trackable lead in KV even if client drops off.

**Automated workflow (SmartQuote to SalesManager):**
1. Step 1 complete: order written to ORDERS_KV, status new
2. Doc upload: AI analysis, price shown
3. Client confirms: Revolut checkout, status quoted
4. Payment: Revolut webhook, status paid, SalesManager Paid column
5. Translator auto-assigned, WhatsApp to owner with order ref
6. Operator uploads translated doc, QR placement editor
7. QR dragged to empty area, pdf-lib burns it, final PDF to R2
8. Delivery per client preference (WhatsApp/email/both) with private drawer link
9. Order marked Delivered, 90-day retention timer starts
10. Review request sent via WhatsApp 24h after delivery

**Document validation:** validate.tatkowski.com/[ref] �� shows doc reference, type, language pair, date, issuing company, Valid/Expired. Does NOT show client name, content, or download link.

**Certification standards:**
- IE/EU: Signed Statement of Accuracy; no sworn registry required in most cases
- UK: Signed Statement of Accuracy; no notarisation needed including UKVI
- Portugal: Traducao certificada by Ordem dos Advogados lawyer; notarisation sometimes required
- Spain: Traduccion jurada �� MAEC-registered Traductor Jurado (TIJ number required); mandatory for official use

### Phase 2: Interpreting (active in Ireland, planned elsewhere)

**Pricing:**
- First hour: EUR 120
- Each additional hour: EUR 100
- Medical/legal premium: +EUR 15 on top of hourly rate
- B2B: round numbers, invoice-based

**Cost:** Olga Tarasova ~EUR 50/h + travel | ATII interpreters typically EUR 80+/h + EUR 30 travel | Dominykas EUR 65/h + 2h min + VAT (viable only for B2B EUR 200+)

**Margin:** ~EUR 45-70 per job depending on length

---

## 4. PRICING BY MARKET

### Ireland (tatkowski.com)
| Service | Price |
|---|---|
| Certified translation (24h) | EUR 39.99/page |
| Handwriting surcharge | +EUR 5.00/page |
| Hard copy postage | +EUR 10 flat |
| Interpreting — first hour | EUR 120 |
| Interpreting — additional hour | EUR 100 |
| Medical/legal premium | +EUR 15 |

Cost ~EUR 7-12/page | Margin ~EUR 28-33/page

### UK (tatkowski.co.uk)
| Service | Price |
|---|---|
| Certified translation (24h) | GBP 39.99/page |
| Handwriting surcharge | +GBP 5.00/page |

Cost ~GBP 6-10/page | Margin ~GBP 30-34/page

### Portugal (tatkowski.pt) — live 20 May 2026
| Service | Price |
|---|---|
| Standard (24-48h) | EUR 49.99/page |
| Urgent (within 24h) | EUR 64.99/page |

Cost ~EUR 17-35/page (Fiverr + OA lawyer). Margin ~EUR 15-33/page.

### Spain (tatkowski.es) — live May 2026
| Service | Price |
|---|---|
| Standard (24-48h) | EUR 49.99/page |
| Urgent (within 24h) | EUR 64.99/page |

Must use MAEC-registered Traductor Jurado (TIJ number in credentials).


---

## 5. CLIENT ORDER HISTORY

**Trading commenced:** 13 January 2026
**Revolut settled payments (as of 4 June 2026):** 42 | Gross ~EUR 3,059 | Net ~EUR 3,016 | Plus Springdale bank transfer EUR 99.98 = **~EUR 3,116 total trading revenue**

### Completed orders (notable)

| Client | Language | Document | Outcome |
|---|---|---|---|
| Sergii Antonov | UA to EN | Bachelor's Diploma + Supplement (4p) | SETU application. 5-star review. EUR 159.96. Margin ~EUR 131. |
| Olha | UA to EN | Bachelor's Degree + Transcript | NARIC. Completed. |
| Romanian speaker | RO to EN | Cazier (2p) | EUR 79.98. Completed. |
| Paulo Miguel | PT | Vocational Training Certificate | Emerson Garcia. 13 April 2026. |
| Wael Alaorfi (1) | AR to EN | First job | Completed. |
| Adriano | PT/ES | Multi-page legal/commercial | EUR 520. Emerson ~GBP 300. Margin ~EUR 170. |
| Arabic client (Naas) | AR to EN | Interpreting 2h | EUR 140 charged. EUR 120 cost. Margin EUR 20. |
| Aurora | IT to EN | 6-page urgent | EUR 239.94. Completed. |
| Alina Semenova | UA to EN | Birth certificate (1p) | EUR 39.99 + EUR 10 postage. Hard copy to Castlebar. 20 May 2026. |
| Olha Arkhypenko | UA to EN | Bachelor's Diploma Attachment (2p) | TIR-PT-2026-0041. Vovka + Sofia Branco. 15 May 2026. |
| Lavrushko Volodymyr | UA to EN | Medical extract (1p urgent) | EUR 39.99. Paid 14:37, delivered 20:11. 19 May 2026. |
| Daniel Izquierdo Hijazi | ES to EN | 2 birth certs | EUR 39.99/page + handwriting. 20 May 2026. |
| Victoria Moroz | UA to EN | School parent-teacher interpreting | Jan 2026. Referred Olga. 5-star review. |
| Phill Anderson | PT to EN | Interpreting ~1h15m same-day | EUR 100 / EUR 27 cost / margin EUR 73. 23 May 2026. Paul R. |
| Rasimov Alim | UA to EN | Marriage Cert (1p, incl. notarial seal text) | EUR 39.99. Paid 28 May. Vovka. Delivered. |
| Dr Wael Alaorfi (returning) | AR to EN | MBChB Diploma (ECFMG/EPIC for GMC) | EUR 39.99. Hassan Zeyad. Delivered 31 May. |
| Vadym Skolyshev | UA to EN (Russian via Vovka) | Divorce decree + 2 birth certs (3p) | EUR 119.97. Paid 2 June. Vovka delivered 2 June 20:23. Delivered. |
| Antkiewicz Mieczyslaw | PL to EN | Driving Licence (1p) | EUR 39.99. Delivered by email 3 June 09:52. Payment unverified — check Revolut. |
| Fyffes / Valerij Saievskiy | UA to EN interpreting | Medical appointment, Swords, 5 June 2026 | EUR 220. Olga Tarasova. Paid by Weronika Michalak 4 June 12:40 (confirmed email + Revolut). |

### Open / active orders (as of 4 June 2026 end of day)

| Client | Status | Notes |
|---|---|---|
| Cepaitis Audrius | Confirmed and paid EUR 135 on 29 May | Lithuanian (Russian acceptable) interpreting. 8 June 14:30, Bowler Geraghty & Co, 2 Lower Ormond Quay, Dublin 1. Olga confirmed. cepaitis77@yahoo.com |
| Marius Nicula | Confirmed | Romanian interpreting. 23 June 2026, 14:30, Civil Registration Service, Drogheda. nicula_marius888@yahoo.ie. Share Marius's contact details ~18 June (5 days before). |
| Algerian enquiry | Awaiting scans | 6 pages (client-stated): Algerian civil docs, likely handwritten. Package quote frame sent. No commitment, no payment, no translator assigned. If proceeds, Hassan likely. |
| Velnichuk Oleksandr | Awaiting name confirmation | UA to EN. Marriage + birth cert (2p), HAP application. Quote EUR 79.98. Asked client to confirm English spelling of all 3 names per Irish docs before Vovka assigned. |

**Cold / likely lost:** Yaroslava Chernyshova (Master's 5p, quote EUR 159.96, no reply since 30 May). Kotenko Mike (birth cert, CC'd competitor, no reply).

**Language diversity to date:** Polish, Ukrainian, Russian, Spanish, French, Hungarian, Arabic, Italian, Romanian, IsiZulu, Portuguese, Dutch, Lithuanian, English

---

## 6. SALES & OUTREACH

**Key principles:**
- Warm, human, no pressure. Read thread before replying.
- WhatsApp: plain text, no markdown, no dividers, short.
- Email: "Kind Regards," on its own line only. Maciej adds name/signature.
- Max 2x customer name per thread.
- Never quote per-page breakdown — total only.

**Emoji rule (organised randomness):**
- Sometimes open a message with the orange heart, sometimes close with it, sometimes both, sometimes neither.
- Never every message in a row. Vary naturally.
- Drop emoji entirely on serious/legal/notarial delivery messages.

**Client language matching:** Reply in the client's language by default (Russian, Polish, Ukrainian, Portuguese etc.). English fallback if uncertain.

**Document handling:**
- Do not pre-emptively question clients about their documents. If something appears wrong, translator flags at translation stage.
- Name spelling: ask client how they want names spelled per their Irish documents ��� short, no over-explanation.
- Never demand photo ID for routine cert work.

**B2B payments:** 2 business days post-assignment internal grace before chasing (Fyffes confirmed as first B2B default).

**B2B outreach planned:**
- Primary channel: occupational health providers (Medmark, Cognate Health, Health Matters, MedWise)
- Secondary: employment law firms
- Active client: Fyffes (Weronika Michalak wmichalak@fyffes.com, CC acarroll@fyffes.com)
- Medmark Dublin Airport: medical interpreting appointments active

---

## 7. SEO, WEBSITE & ONLINE PRESENCE

### Domains
- tatkowski.com — Ireland (primary). Strong IE geo signals.
- tatkowski.co.uk — UK
- tatkowski.es — Spain
- tatkowski.pt — Portugal (EuroDNS Case ID 00896138, invoice E-1824442, registered 11 May 2026)
- tatkowski.ie — decision made to buy (EUR 5 via EuroDNS), 301 to tatkowski.com. Not yet purchased.

### Web platform
Astro 5 + React 18 monorepo on Cloudflare Pages. Apps: ie, uk, es, pt + packages/ui shared component library + SalesManager. Deployed via GitHub Actions. All four markets live.

**Page quality tiers (as of 04 June 2026):**
- Gen3 (benchmark): legal-translation, certified-translation, all doc-type pages
- Gen2 (upgraded): business-interpreting, court-interpreting, medical-interpreting, medical-translation, document-translation, immigration-translation, parent-teacher-meetings, phone-interpreting, school-interpreting, european-languages, irish-translation
- Gen1 (needs upgrade): arabic, chinese, lithuanian, portuguese, romanian, russian translation pages; direction pages
- polish-translation + ukrainian-translation: Gen3 since Sprint 2 (01/06), 1555-1600 lines. The pos 38-41 / 1,400-imp figure PREDATES the rebuild - re-judge from the 07/06 GSC pull, do not rebuild again.

### GSC performance — most recent 28 days vs prior 28 days (5 May to 1 June vs 7 Apr to 4 May)
| Site | Clicks | Impressions | CTR | Avg pos |
|---|---|---|---|---|
| IE | 29 to 45 (+55%) | 1,672 to 2,473 (+48%) | 1.73% to 1.82% | 14.1 to 15.6 |
| UK | 0 to 2 (first ever) | 110 to 227 (+106%) | 0% to 0.88% | 38.7 to 31.1 |
| ES | 0 | 0 to 1 | new | new |
| PT | 0 | 0 to 1 | new | new |

**Top IE gainers:** ukrainian translator (10 to 52 imps, pos 11.3 to 10.5) | translation services dublin (58 to 80 imps) | certified translation services dublin (5 to 27 imps but pos worsened 15 to 26 — investigate)

**IE dropouts:** medical translator 10 to 0 | pharmaceutical translation services 7 to 0 | legal translation services 6 to 0 | translation companies ireland 5 to 0

### Active SEO sprint priorities
1. Gen3 rebuild of the 6 thin IE language stubs (~165 lines each): russian, romanian, arabic, chinese, lithuanian, portuguese — template = polish-translation.astro (already Gen3). [polish + ukrainian ALREADY Gen3 since Sprint 2 01/06; the old "rebuild polish/ukrainian" note was STALE — verified 05/06/26, 1555-1600 lines, bigger than certified-translation benchmark.]
2. Direction pages rebuild (pos 60-76)
3. Rebuild ES/PT localised service pages in correct language
4. BrightLocal UK - DONE (hold resolved 2 June, campaign 971664 live)
5. PT citations - David first. NAP phone = +351 931 052 612 (David's COMPANY Business WhatsApp, human). NOT 927 (personal), NOT 617 (AI).
6. IE hreflang verification (en-IE) on tatkowski.com — replaces the dead GSC geo-target task (feature deprecated by Google Sept 2022). hreflang + ccTLD + citations are the only country signals now.
7. Irish translation cluster — ranking page 1 but zero clicks, fix meta/CTR

### Competitor scrape (20/05/26) — reusable rig
Location: C:\Users\adern\Downloads\data\scape competition\ (NOTE typo "scape", on C: not D:). Puppeteer + Cheerio. scrape-competitors.js (content: title/meta/pricing/review signals) + map-competitor-structure.js (page-count taxonomy by category). Outputs: competitor-data/ + competitor-structure/ (each: raw/ + reports/ + summary.md). node_modules present, runs as-is.
Key finding: market leaders win on LANGUAGE + DOCUMENT page volume. IE certifiedtranslations.ie = 1112 pages (642 language). UK translayte = 1395 (155 lang + 225 blog), absolutetranslations = 1343 (260 lang + 108 doc). ES leaders 300-420 pp. PT thin (alphatrad 391, rest <120). Validates: build out language + doc-type clusters; consider a blog (UK leaders lean on it heavily).
Pricing intel: IE thetranslationcompany "from EUR 14.99" (we are premium at 39.99 — justify via certification/QR/24h). UK per-word (TS24 GBP 0.08/word, espresso 0.10-0.25). ES jurada EUR 28-36 (juratrad).
LIMITATION: content scrape is SHALLOW (0-5 pages/competitor). RE-RUN deeper before using to spec pages — crawl the language/doc pages, capture H1/H2/word-count/schema/internal-links.

### GSC data pipeline
Location: D:\tatkowski-gsc\ - Node + OAuth2 (adernhael@gmail.com).
Schedule: Windows Task Scheduler "Tatkowski_GSC_Weekly_Pull", Sundays 14:00 -> runs D:\tatkowski-gsc\run-weekly.ps1. Logs: D:\tatkowski-gsc\logs\weekly_*.log.
Flow: run-weekly.ps1 does (1) npm run pull (resumable/incremental), (2) npm run export (CSV to data/csv/), (3) python gsc-sync.py -> stages CSVs + commits to repo gsc/ (idempotent, only commits if data changed).
NOTE (fixed 05/06/26): run-weekly.ps1 was MISSING - the weekly task had never actually run. Created it + gsc-sync.py and added the auto re-commit. Verified end-to-end 05/06/26; next scheduled run 07/06.
Repo-resident copy: all 4 properties' GSC CSVs live in the repo under gsc/ (committed snapshot, auto-refreshed weekly). Any team member's Claude pulls via tools/gsc-fetch.ps1 and analyses with pandas. See gsc/MANIFEST.md (schema) + gsc/HOW_TO.md (David's guide).
Commands (manual): npm run pull, npm run export, python gsc-sync.py [--by Maciej|David].

### Directories
- SayMore (acct ID 4499615): ~50 platforms. Audit fixes pending: INIS to ISD; address line; delete Swords + Corballis service areas; Eircode K36 KV97 space.
- BrightLocal UK Citation Builder (campaign 971664) - LIVE. Pre-submission hold resolved 2 June (site updated to UK number + 24/7 hours); now Submitting to Sites, 35 citations.
- Yelp Ireland: set up May 2026
- Manual IE directories pending (Magda): yourlocal.ie, localsearch.ie, irishbusinesslink.ie, askspud.ie, zuko.ie, near-me.ie, bigdirectory.ie
- Apple Business Connect, Bing Places: pending

### FCR Media
Contract signed 16 Oct 2025. EUR 61.50/mo from 1 Dec 2025. Not renewing. Cancel notice to contracts@fcrmedia.ie by 31 October 2026. Contact: Enoma.

---

## 8. GOOGLE BUSINESS PROFILE HISTORY

**Current status (05 June 2026):** VERIFICATION ROUTED. IE profile confirmed reverted to service-area (storefront->service-area ticket processed). Live support chat w/ specialist Vishwanath -> ticket routed to verification team, ETA 24-48h. NEW case ID: 3-6482000040927 (supersedes old 4-3059000041687). ACTION: do NOT edit IE profile until verified - edits reset review. Watch contact@tatkowski.com + 'Get verified' prompt.
**Service area:** Dublin only. Removed country-level 'Ireland' per Google rule (areas <=~2hr drive from base, up to 20 areas). Can add specific cities later (e.g. Cork) within policy.
**Root cause:** FCR Media switched to storefront January 2026 without sign-off ��� triggered video verification impossible at residential address.
**Profile:** 20 five-star reviews, 5.0 average.
**Review link:** https://g.page/r/CfRJ5zTwe30FEBE/review
**UK GBP:** Created and VERIFIED (service-area). Confirmed 05/06/26 during IE support chat - separate profile, no action needed.
**Rule:** Service-area type, one per market, no storefront.

---

## 9. RECRUITMENT DIVISION

Status: Planned. Not operationally active. Hidden across all sites. Enquiries redirected to official resources.
CV received from kishor_gyawali@hotmail.com (22 May 2026) — unactioned. File for when recruitment goes live.

---

## 10. TRANSLATOR & INTERPRETER NETWORK

**Primary sourcing:** Fiverr (~EUR 7-12/page standard). PT-specific: APIC, APTRAD.

### Translators
| Name | Pairs | Notes |
|---|---|---|
| Vovka (Vladimir Slovesnyy) | UA to EN (also RU to EN) | Go-to for Ukrainian/Russian. Fiverr Top Rated. $12/page + 5% loyalty discount. Zero issues since Sept 2025. Default for UA jobs. |
| Hassan Zeyad | AR to EN | Active. Watch: prior errors on document reference numbers and dates — review carefully before delivery. Brief in 2 messages: intro + attachment, then specific requirements list. |
| Emerson Garcia | PT/ES complex | ~GBP 300/project. Good quality. |
| Sofia Isabel Branco | PT certification | Advogada (OA nr 54321L, Lisboa). Provides Certificacao da Traducao. |
| Fiverr pool | PL, AR, RO, FR, ES, HU, IT, IsiZulu | General pool |

### Interpreters
| Name | Pairs | Notes |
|---|---|---|
| Olga Tarasova | UA/EN (RU acceptable) | Dublin (Balbriggan). Go-to. ~EUR 50/h + travel. Helltarasova@gmail.com / +353 85 732 1738. 5-star Google review. Admin of Room 7 Dublin interpreter network (~25). |
| Paul R | PT to EN | Dublin. Fiverr handle "Paul R". Used for Anderson 23 May. Direct contact still to capture from Fiverr order. |
| Marius Nicula | RO to EN | Booked for Drogheda civil ceremony 23 June. nicula_marius888@yahoo.ie |
| Dominykas | LT/RU to EN | ATII, Dublin. dom@dawmuz.com. EUR 65/h + 2h min + VAT. Viable only for B2B EUR 200+. |
| Diana Barbolovici Sabou | RO/ES to EN | Navan. CV reviewed May 2026. Backup option. |

**Key gap:** No standing interpreters for ES/PT. David sourcing.


---

## 11. TOOLS, PLATFORMS & ACCOUNTS

| Tool | Purpose | Notes |
|---|---|---|
| Microsoft 365 (contact@tatkowski.com) | Email, calendar | M365 connector active. Always use mailboxOwnerEmail: contact@tatkowski.com. Calendar SEARCH only via MCP �� no create. Auto-renewed 3 June 2026. |
| Revolut Business | Merchant payments | All client payments. Link naming: Certified Translation - [Surname] - [Doc Type] x[pages]. Interpreting: Interpreting - [Lang] - [Service] - [Date]. Webhook ID: ddf96576-f5ce-4767-afbb-ebdb59d3aea2. Fee ~1.48%. Personal address updated 4 June 2026. |
| GitHub (satanhimself2137) | Code repo + KB | tatkowski-kb repo: https://github.com/satanhimself2137/tatkowski-kb �� master KB copy, read/written by Claude via gh api (Desktop) and GitHub MCP (David). Monorepo: tatkowski-interpreting-recruitment. GitHub CLI v2.93.0 installed. Copilot Pro+ live from 1 June 2026. |
| SayMore (acct ID 4499615) | Directory listings | dashboard.saymore.ie/s/4499615/ |
| FCR Media | GBP posts + backlinks | EUR 61.50/mo. Not renewing. Contact: Enoma. Cancel by 31 Oct 2026. |
| BrightLocal | Citation Builder + Reputation Manager | UK campaign 971664, $112, LIVE (hold resolved 2 June). PT next: NAP phone +351 931 052 612, site tatkowski.pt. |
| EuroDNS | Domain registrar | tatkowski.pt: Case ID 00896138, invoice E-1824442 |
| Meta Cloud API (direct) | WhatsApp AI automation | App ID 1523183499431643, WABA ID 2086178738626839, IE Phone Number ID 1170128006173405. No WATI. |
| Chatwoot (planned) | Multi-number WhatsApp inbox | Hetzner CX22 (EUR 4.51/mo, IE datacentre) — gating step before AI builds. |
| Cloudflare Workers | Payment worker, email worker, WhatsApp webhook | tatkowski-payment-worker.2137satanshimself.workers.dev. Rename to tatkowski.workers.dev pending. |
| Cloudflare Workers AI | Doc analysis | LLaVA to Claude Haiku Vision. Llama 4 Scout to Claude Haiku. |
| Cloudflare Vectorize | RAG for WhatsApp AI | EmbeddingGemma + tatkowski_knowledge_base.md |
| Cloudflare KV (ORDERS_KV) | Order state, sessions | ID: 8f5f06b234c1432ca17886549b886af8 |
| Cloudflare R2 (tatkowski-orders) | Document storage | 90-day retention — Cron Trigger planned |
| VS Code + GitHub Copilot | IDE | BYOK via VS Code 1.122, Anthropic API key tatkowski-vscode-dev. Claude Sonnet 4.6 for chat/agent, Haiku for autocomplete. Local Ollama qwen2.5-coder:14b on RTX 2080 Super. |
| Anthropic API | AI integration | Key: tatkowski-vscode-dev. Transitioning WA + doc analysis to Claude Haiku. |
| Fiverr | Translator sourcing | Account: adernhael. |
| GSC pipeline | SEO data | D:\tatkowski-gsc\ — see Section 7 |
| WhatsApp bridge | In-session WA reads/sends | D:\tatkowski-whatsapp\bridge\inject.js. Desktop Claude only. Re-arm after page reload. API: __tw.findChat, getMessages, sendText. Team messages send without approval. Client/external messages require explicit "send". |
| Revolut | Payments | Merchant API: https://merchant.revolut.com/api/orders (version 2024-09-01) |
| Paperweight.ie | Print jobs (Malahide) | Used May 2026 |

### WhatsApp numbers architecture (planned: 2 per market, 8 total)
- Hard rule: AI number (Cloud API) and Human number (App) can never be the same. Once a SIM is registered on Cloud API it is permanently API-only.
- IE: AI (Cloud API) already registered | Human: Maciej +353 83 871 0861
- UK: AI = old +44 number being repurposed | Human: Artur's number
- ES: AI SIM via David (1 eSIM needed) | Human: David +351 927 901 200
- PT: AI = 931 052 617 (Cloud API, fresh eSIM) | Human company WhatsApp + public NAP = 931 052 612 | David personal (not public) = 927 901 200
- CONFIRMED 05/06/26 (David via TEAM ONE): 931 052 612 = company Business WhatsApp (human, PUBLIC NAP for citations); 931 052 617 = AI / Cloud API (fresh eSIM); 927 901 200 = David personal. Hard rule holds: 617 stays API-only once registered.
- PT AI eSIM = 931 052 617 (sorted). ES AI channel still needs its own number. Physical PAYG only.

### Implementation sequence (locked)
1. Chatwoot on Hetzner — gating step
2. Connect IE WABA to Chatwoot (manual replies, AI plugs in later)
3. Register UK number to Cloud API, connect Chatwoot
4. Migrate IE citations off +353 838710861 to IE WABA number
5. David buys + registers ES/PT SIMs; citations from day one
6. AI worker ships when ready — sits in front of Chatwoot, no re-architecture needed

### Home office / tax
- Company can pay a licence fee to Maciej for dedicated home office room (~25% of rent ~EUR 600/mo). Requires written licence + accountant sign-off.
- Switch mobile contract to company name — biggest standing deductible currently missed.
- Software subs, translator costs, travel, bank fees all 100% deductible with receipts.

### KB workflow (as of 5 June 2026) - STATELESS, repo is the only source of truth
- Master copy: GitHub repo https://github.com/satanhimself2137/tatkowski-kb (tatkowski_knowledge_base.md, branch **main**).
- NO local clone. Local clones rot/get deleted (this happened 05/06/26). Everything goes through gh api over Desktop Commander.
- Helper script lives IN the repo: tools/kb.ps1 (v3). It wraps read (base64 decode) + write (fetch SHA, base64, commit), auto-tags commits, refuses to overwrite if repo moved since read (stale-guard), and self-timeouts every gh call (20s) + disables interactive prompts so a hung gh can NEVER wedge Desktop Commander. v3 adds `read -Section N` which prints just one numbered section (full file still written to %TEMP%\kb_work.md) - use it for cheap surgical edits instead of pulling the whole ~10k-token file into context. Full `read` is only needed for recaps/audits.
- Per-session flow (any team member, via Desktop Commander):
  1. BOOTSTRAP (fetch helper, the only setup - nothing kept on disk):
     $b64=(gh api "repos/satanhimself2137/tatkowski-kb/contents/tools/kb.ps1?ref=main" --jq ".content")-replace "\s",""; [IO.File]::WriteAllBytes("$env:TEMP\kb.ps1",[Convert]::FromBase64String($b64))
  2. READ:  & "$env:TEMP\kb.ps1" read            (writes %TEMP%\kb_work.md)
  3. EDIT %TEMP%\kb_work.md with targeted string replacements (never regenerate whole file from scratch).
  4. WRITE: & "$env:TEMP\kb.ps1" write -By David -Message "what changed"   (David uses -By David, Maciej -By Maciej)
- If %TEMP%\kb.ps1 vanishes, re-run step 1. Requirements per machine: gh authed + Desktop Commander. That's it.
- RULE: one logical operation per start_process call. NEVER chain multiple gh calls glued with ';' - if one hangs it wedges the whole bridge (caused a 4-min dead bridge 05/06/26). The helper exists so you don't hand-roll gh chains.
- Project knowledge (claude.ai): the repo is wired in via the READ-ONLY GitHub connector - it auto-syncs on a delay, NOT on push. It is a convenience read layer only: cheap, chunked, works on mobile (no Desktop Commander), but it LAGS fresh commits (seen ~24h behind 05/06/26) and returns fragments, not the whole file. NEVER trust it for anything changed in the last ~24h or immediately after a write - use gh api for fresh or full-file reads. It is never a write path. (No more manual file uploads - the old "replace manually" step is gone.)
- Commit message format (auto-applied by helper): [Claude/Maciej] or [Claude/David] - description - DD/MM/YY

---

## 12. KEY OPERATIONAL DECISIONS & PRINCIPLES

**Pricing:** IE/UK EUR 39.99/GBP 39.99 per page, 24h, single rate. Handwriting +EUR 5. Postage +EUR 10. PT/ES EUR 49.99 standard / EUR 64.99 urgent. Per-page only. Quote total only. Multi-doc: hold quote, frame as package. B2B: round numbers, invoice-based.

**B2B payment grace:** 2 business days post-assignment before chasing.

**Client comms:** Company voice (we/our) by default. WhatsApp: plain text, no markdown, no dividers, short. Emoji organised randomness — open/close/both/neither, never every message, never on legal/notarial deliveries. Email: "Kind Regards," on own line. Max 2x client name per thread. Reply in client's language.

**Document handling:** Clients know their paperwork. Do not pre-emptively question their documents. Name spelling: ask client how they want names spelled per Irish docs — short, no over-explanation.

**Interpreter operations:** 5-day rule for sharing interpreter direct contact with client. Lock interpreter on reputable B2B before payment lands.

**Team comms (TEAM ONE group or individuals):** Open with "Hi team" line, then "Claude here, Maciej's AI assistant." One-line summary. Sectioned content with emoji headers. Warm close with orange heart. Plain text, no markdown, no dividers.

**LID mapping:** 223630424305904@lid = Maciej's English WhatsApp +44 7752 154028 (secondary phone, posts in TEAM ONE as fromMe: false). 226710469509153@lid = David Briceag.

**Document naming:** Certified Translation - [Source Lang] to [Target Lang] - [Document Type] - [Client Surname Firstname].pdf (em dashes with spaces)

**PDF signatures:** Source: tatkowski_signature_podpis_white.png. Process: greyscale, crop (avg brightness 5-240, +6px left/top, +1px right/bottom), invert, RGB PNG 300dpi. Embed at 50mm wide, ratio ~3.16.

**Coding / agent prompts:** Read files before editing. Build gate before commit. Screenshot 390px + 1440px after visual change. Never batch git commands ���� always 3 separate steps. Always --ipv4 (IPv6 DNS glitch on this machine).

**Git deploy (always 3 separate commands):**
git add -A
git commit -m "..."
git push origin main --ipv4

**Terminal:** PowerShell first. Windows machine. && not valid ��� use ; for command chaining.

**Hard truths preferred.** Evidence-backed. Push back when wrong.

**Chat naming:** [CATEGORY] - [Subject] - [DD/MM/YY]. Categories: CLIENT, OPS, SEO, TECH, FIN, LEGAL, HR, MKT. CLIENT: [CLIENT] - [Surname] - [Lang pair + Doc type] - [DD/MM/YY].

---

## 13. PENDING ITEMS & NEXT ACTIONS

> **To-do system (added 05/06/26):** Per-person task lists are the SOURCE OF TRUTH in the KB repo at `todos/` (maciej.md, magda.md, artur.md, david.md). Update those first; reflect significant items here.
>
> Key open items by owner:
> - Maciej: BrightLocal PT order + pay; fix SmartQuote/BookInterpreter hardcoded wa.me number (06/06); PT geo Lisbon -> Portimao (parked).
> - David: confirm 931 052 617 never on WhatsApp (AI freshness); send GitHub username; source ES AI SIM. [Contractor agreement + non-compete SIGNED 17 May - risk closed.]

### THIS WEEK

| Item | Owner | Notes |
|---|---|---|
| BrightLocal UK campaign - DONE | Maciej | Resolved 2 June: replied to ticket 722747, updated .co.uk to 07752154028 + 24/7 hours; BrightLocal confirmed and queued. Campaign 971664 now Submitting to Sites (35 citations). |
| BrightLocal PT campaign - DONE 05/06/26 | Maciej | Campaign 972979 (TATKOWSKI-PT-8500), 35 citations, $112, queued (data-accuracy stage). NAP +351 931 052 612 / tatkowski.pt / Portimao, service-area (address hidden), hours 24/7, PT description + services + logo submitted. tatkowski.pt deployed with matching number/hours (commit 715e21d) so pre-submission matched - no hold. |
| Antkiewicz payment verification | Maciej | Delivered 3 June. Check Revolut for EUR 39.99 payment. |
| Cepaitis 8 June interpreting | Maciej | Lithuanian/Russian. Olga confirmed. Bowler Geraghty & Co, 2 Lower Ormond Quay, Dublin 1, 14:30. cepaitis77@yahoo.com. |
| David GitHub collaborator — DONE 05/06/26 | Maciej | David added as repo collaborator; his Claude can read+write KB + gsc/ data. |
| Algerian enquiry follow-up | Maciej | Awaiting scans for package quote. |
| Velnichuk name confirmation | Maciej | Awaiting English spelling for 3 names per Irish docs before Vovka assigned. |

### IN-FLIGHT

| Item | Owner | Notes |
|---|---|---|
| WhatsApp AI sequence | Maciej | (1) Chatwoot on Hetzner (2) IE WABA to Chatwoot (3) register UK number (4) migrate IE citations off +353 838710861 (5) David ES/PT SIMs (6) AI worker. Permanent System User token needed before production. |
| SalesManager next build | Maciej | Archive/delete unpaid quotes, order modification, notification history, inline doc preview, Kanban search, pipeline widget fix, mobile tab labels. |
| ICO fee registration (UK GDPR) | Maciej | GBP 40 at ico.org.uk/registration. Tier 1. Live action item. |
| GBP verification - ROUTED 05/06/26 | Maciej | IE profile now service-area; ticket routed to verification team via chat w/ Vishwanath. Case 3-6482000040927. ETA 24-48h. Do NOT edit profile until verified. |
| Rebuild /polish-translation/ and /ukrainian-translation/ to Gen3 | Maciej | Highest GSC impact (pos 38-41, 1,400+ imps each). |
| Rebuild ES/PT localised service pages | David/Maciej | Currently redirected to English. Wrong long-term. |
| GSC geo-targeting — DEAD TASK | — | Google deprecated International/country Targeting Sept 2022; the setting no longer exists. IE targeting now via hreflang (en-IE), ccTLD signals, content + local citations. ACTION instead: verify hreflang on tatkowski.com in code. |
| SayMore audit fixes | Maciej | INIS to ISD; address line; delete Swords + Corballis service areas; Eircode space K36 KV97. |
| Flag emoji restoration | Maciej | european-languages.astro files across UK/ES/PT (last loose end of UTF-8 fix). |
| David contractor agreement — DONE | David | Signed + returned 17 May 2026 (davidjo9@hotmail.com, combined PDF in contact@ mailbox). Operational risk closed 05/06/26. |
| Marius Nicula contact share | Maciej | Share Marius details to civil ceremony client ~18 June (5 days before 23 June). |
| ES app _routes.json silently failing | Maciej | Quote forms failing on ES. Fix before ES scales. |

### COMPLIANCE / ADMIN

| Item | Owner | Notes |
|---|---|---|
| FCR Media auto-renewal | Maciej | Not renewing. Cancel by 31 Oct 2026 to contracts@fcrmedia.ie. |
| Home office licence agreement | Maciej | Simple licence needed before company pays rent portion. Accountant sign-off first. |
| Mobile contract to company name | Maciej | Biggest standing deductible currently missed. |
| Paul (PT interpreter) direct contact | Maciej | Get from Fiverr order. |

### BACKLOG

| Item | Notes |
|---|---|
| tatkowski.ie domain | Buy EUR 5, 301 to tatkowski.com. Decision made, not actioned. |
| Rename workers.dev subdomain | 2137satanshimself to tatkowski.workers.dev (confirmed available). |
| D1 migration | At ~order #200 (currently ~42 orders). KV fine until then. |
| ISO 17100 certification | Q3 2026 target (~EUR 9k-14k Year 1). |
| EUIPO trademark filing for SmartQuote | Classes 42 and 35, before wider public branding. |
| Offshore oil rig interpretation/recruitment | High-margin niche. Requires consistent monthly net profit baseline first. |
| tatkowski.ie to tatkowski.co.uk direction pages | Once .ie purchased. |

### RECENTLY COMPLETED
- B1 Annual Return filed 4 June 2026 (deadline 15 June) ���
- Fyffes EUR 220 paid 4 June 2026 (Weronika Michalak + Revolut confirmed) ✓
- GitHub KB system live: https://github.com/satanhimself2137/tatkowski-kb ✓
- GitHub CLI v2.93.0 installed, authed as satanhimself2137 ✓
- David's GitHub setup + prompts delivered via TEAM ONE 4 June ✓
- WhatsApp bridge armed: D:\tatkowski-whatsapp\bridge\inject.js ✓
- B10 forms SR8705989 + SR8706130 registered 2 June 2026 ✓
- VAPID key push notifications fixed ✓
- SalesManager auto-expiry extended ✓
- UK wrangler.toml kv_namespaces binding added ✓
- LEAD order 404 fix (commit 049dc66) ✓
- UTF-8 corruption 89 chars fixed across UK/ES/PT ✓
- GSC data pipeline + weekly scheduler ✓

---

## 14. FINANCIAL OVERVIEW

**Revenue to date (as of 4 June 2026):**
- Settled payments: 42
- Gross: ~EUR 3,059
- Revolut fees: ~EUR 44 (1.48% effective)
- Net to account: ~EUR 3,015
- Plus Springdale bank transfer EUR 99.98
- **Total trading revenue: ~EUR 3,115**

**Notable: Fyffes EUR 220 paid 4 June — funds available within 24 hours per Revolut.**

**Revenue payment mix:** 49% Revolut-to-Revolut | 37% Irish bank cards low rate | remainder international/credit cards at 2.8% tier.

**Cost structure (monthly):**
- FCR Media EUR 61.50 (exiting)
- Cloudflare ~$32.50
- Microsoft 365 Business Standard (auto-renewed 3 June)
- GitHub Copilot Pro+ (live from 1 June)
- Translator costs: Fiverr ~EUR 7-12/page; Emerson ~GBP 17-20/page; Vovka $12/page; Hassan $12/page

**Margin examples:**
- Single page standard: EUR 39.99 / ~EUR 7-10 cost / margin ~EUR 30-33 (75-83%)
- Sergii Antonov (4p): EUR 159.96 / ~EUR 29 / EUR 131 (82%)
- Adriano: EUR 520 / ~EUR 350 / EUR 170
- Anderson (PT interpreting): EUR 100 / EUR 27 / EUR 73 (73%)
- Fyffes (1h15m): EUR 220 / Olga ~EUR 63-75 / margin ~EUR 145-157

**Tax:**
- Corporation tax: 12.5% on trading profit
- No VAT obligation (below EUR 37,500 threshold)
- First CT1 + payment due: 23 September 2027

**Company valuation (May 2026 indication):** EUR 80k-150k to strategic buyer. Goal: not to sell — build to self-managing, then Tatkowski Systems.

---

## 15. TECH INFRASTRUCTURE & ARCHITECTURE

### Monorepo structure
D:\tatkowski-interpreting-recruitment\
  apps/ie, uk, es, pt, sales
  packages/ui (shared React components + tokens.css)
  workers/payment-worker, email-worker, whatsapp (in build)
  docs/
  snapshot.ps1

GSC pipeline at D:\tatkowski-gsc\

### Cloudflare Pages
| Project | Domain |
|---|---|
| tatkowski-ie | tatkowski.com |
| tatkowski-uk | tatkowski.co.uk |
| tatkowski-es | tatkowski.es |
| tatkowski-pt | tatkowski.pt |
| tatkowski-sales-manager | sales.tatkowski.com |

### Cloudflare Workers
| Worker | Purpose |
|---|---|
| tatkowski-payment-worker | Revolut checkout, doc AI analysis, webhook |
| tatkowski-email-worker | Email delivery via M365 Graph |
| whatsapp (in build) | WhatsApp AI automation |

Plan: rename 2137satanshimself.workers.dev to tatkowski.workers.dev

### KV namespace: ORDERS_KV
ID: 8f5f06b234c1432ca17886549b886af8
Key patterns: order:{ref} | order:pending:{sessionId} | users:{username} | push:{username} | notifications:{username}

### AI model decisions (May/June 2026)
| Use case | Decision |
|---|---|
| WhatsApp conversation AI | Claude Haiku (Anthropic API) |
| Document analysis | Claude Haiku Vision (Anthropic API) |
| IDE agent/chat | VS Code 1.122 BYOK + Claude Sonnet 4.6 |
| IDE autocomplete | Claude Haiku / Qwen2.5-coder:14b (local Ollama) |

### WhatsApp AI (in build)
- Meta Cloud API direct (no WATI)
- App ID 1523183499431643 | WABA ID 2086178738626839 | IE Phone Number ID 1170128006173405
- Claude Haiku for conversation + Haiku Vision for doc analysis
- RAG: EmbeddingGemma + Cloudflare Vectorize over tatkowski_knowledge_base.md
- Conversation state: Cloudflare KV per phone number
- Permanent System User token needed before production
- Chatwoot prerequisite — see Section 11 sequence

### Known bugs / open fixes (as of 4 June 2026)
| Bug | Status |
|---|---|
| apps/es _routes.json — quote forms silently failing | Open. Fix before ES scales. |
| Flag emoji restoration european-languages.astro UK/ES/PT | Open. |
| certified translation services dublin position drift 15 to 26 | Open — investigate. |
| IE dropout queries (medical/legal/pharmaceutical/translation companies ireland) | Open ��� find which pages used to rank. |

### D1 migration plan
Current: ORDERS_KV (flat, no querying). Target: Cloudflare D1. Trigger: order #200 (~42 now).

---

## 16. SALESMANAGER PORTAL

URL: sales.tatkowski.com | Codebase: apps/sales/

### User roles
- superadmin (Maciej): full access
- agent (Artur IE/UK, David ES/PT): assigned markets only

### PWA features
- Installable iOS + Android (must install as PWA on iOS for push)
- Push notifications: working (VAPID resolved May 2026)
- 7-day offline order cache (IndexedDB)
- Browser note: reliable push when closed = Firefox on Android, Safari on iOS. Chrome on Android unreliable by design.

### Auth
Username + password. Sessions in ORDERS_KV, 8h TTL. ADMIN_PASSWORD: Cloudflare Pages secret.

### Design system
Background: #080d14 | Brand orange: #ff6a1a | Surface: #0f1724 (cards), #162035 (inputs) | Success: #10b981 | Warning: #f59e0b | Danger: #ef4444

### Next build queue
Archive/delete for unpaid quotes | Order modification UI | Notification history log | Inline document preview | Pipeline widget calculation fix | Kanban search | Mobile status tab labels

### FULL PRO build target (scoped by Maciej 05/06/26) — end-state SalesManager as single operating cockpit
1. Finish core: complete the delivery flow (currently unfinished); client document drawer; in-browser multi-format document viewer; order modification; notification history.
2. Document-baking studio — SEPARATE access/role. Ingests many formats (PDF/JPG/PNG/DOCX), bakes QR + company logo + details, allows manual edits, outputs final cert PDF through the same pipeline. MUST also handle docs that arrived MANUALLY via WhatsApp (standalone "treat this document" entry point, not only SmartQuote orders).
3. Chatwoot embedded as a bottom-nav button — multi-number inbox (one per geo); agents work conversations in-app.
4. WhatsApp AI intake: AI persona + guidance + its own DB/knowledge. Takes docs/photos in any format from WA chat -> processes through the SmartQuote pipeline -> quotes in WA -> takes payment on approval (Revolut) -> emails client a doc-drawer link with their orders -> posts status updates -> captures delivery preference (WA / email / both) -> all controlled from SalesManager.
5. Notifications by assigned geo: order-placed alerts route to the right agent (same as SmartQuote, flagged source = WhatsApp).
6. Escalation handoff (HIGH priority): agent can take a conversation over from the AI inside the embedded Chatwoot port.

REALITY CHECK — "the only thing missing is D1" (Maciej 05/06/26): NOT correct. D1 is one workstream, not the gate. Critical path, gating first:
- Chatwoot on Hetzner — GATING prerequisite for inbox + embed + escalation. Not built. This is the real blocker.
- Meta permanent System User token — required before WA AI production. Not done.
- WA number provisioning — UK + ES AI numbers still to register; ES AI SIM still needed.
- Document-baking studio + in-browser viewer — net-new builds.
- AI persona + RAG (Vectorize + EmbeddingGemma over KB) + per-number conversation state — designed, not built.
- D1 migration — justified for the Pro RELATIONAL model (orders <-> conversations <-> clients <-> docs <-> delivery prefs <-> geo), which outgrows flat KV. So D1 lands ALONGSIDE the build, earlier than the order-#200 volume trigger, but it is NOT the only or gating piece. Order count ~42; KV fine for today's ops. D1 = architecture decision, not volume.

---

## 17. BROADER VISION — TATKOWSKI SYSTEMS

Tatkowski Interpreting & Recruitment is Company 1. Goal is not to sell ��� build it to self-managing state, then build Company 2, 3, etc. under a Tatkowski Systems umbrella.

Pattern: Maciej doesn't just manage systems — he builds new infrastructure on top of them. ToH (Traffic on Hand) at Royal Mail, Kibana dashboards, now SalesManager + WhatsApp AI intake.

Tatkowski Systems: Multiple operating companies, each running with AI automation reducing human touchpoints. Translation/interpreting/recruitment = sector 1. Offshore (language services + specialist recruitment for international crews, OPITO/BOSIET/HUET) identified as high-margin niche — requires consistent monthly net profit baseline first.

Domain strategy: tatkowski.ie (EUR 5, to be purchased) to 301 to tatkowski.com now. When tatkowski.com becomes group holding/portfolio site, translation business migrates to tatkowski.ie. 3-4 year horizon.

Current milestone: Translation business to self-managing (WhatsApp AI handles intake, SalesManager handles ops, David handles Iberia) — frees Maciej to build the next thing.

---

*End of knowledge base v5.1*
*Updated: Claude session 04 June 2026 — Fyffes paid, B1 filed, GitHub KB system live, David PT numbers confirmed*
*Next update: after any significant order, market launch, team change, or operational decision.*


---
**KB Update â€“ 05/06/2026 â€“ By Maciej**

Added interpreter contacts sourced via Olga Tarasova following Fyffes assignment (05/06/2026):

- **Sarah** â€” Chinese interpreter â€” +353 89 418 0947 (via Olga)
- **Dominykas** â€” Lithuanian interpreter â€” +353 86 371 6651 (via Olga)
- **Neringa** â€” Lithuanian interpreter â€” +353 87 781 3979 (via Olga)
- **Ivona** â€” Lithuanian interpreter â€” +353 87 933 2632 (via Olga)
