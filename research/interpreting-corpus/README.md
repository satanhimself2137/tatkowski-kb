# Interpreting Corpus — Market Intelligence Research

## What this is

A research initiative to extract structured, event-level data from interpreting practitioner literature and turn it into a queryable dataset on how interpreting jobs actually originate, route, and price across markets and settings.

The bet: published memoirs, practitioner business books, and ethnographic studies are full of granular job-origination data that nobody has bothered to systematically code, because hand-coding 20+ books is dull. AI extraction flips the economics. The output is a SQLite/Parquet dataset that can be cross-referenced against our own SalesManager and Revolut pipeline data — interesting findings live where published patterns *don't* match our actual pipeline.

This is not a reading project. It is a structured-data project where books are the raw input.

## Project status

Scoping. Reading list curated. Schema drafted (see below). Extraction pipeline not yet built.

## Schema (draft, v0)

Per job/event mentioned in source material:

- trigger_event — what happened in the client's world that created the need (legal deadline, ER admission, asylum interview, M&A close, court date, etc.)
- channel — how the interpreter was found (agency, court roster, embassy list, direct referral, repeat client, professional body, GBP/web)
- decision_maker — who picked up the phone (lawyer, HR, hospital admin, family member, procurement, court clerk)
- setting — courtroom, hospital, police station, boardroom, remote, asylum interview, etc.
- lead_time — same-day, 24h, 1 week, scheduled weeks out
- stakes — criminal liberty, immigration status, medical, commercial, consular
- pricing_model — direct, agency markup, legal aid, insurance, government rate
- payer — who actually paid (client direct, agency, state, insurer)
- failure_mode — if mentioned (no-show, dialect mismatch, ethics breach, late arrival, withdrawn assignment)
- repeat_vs_oneoff
- geography — country/region
- language_pair
- source — book title + page/chapter

## Known biases in the corpus

Memoirs are selected for the dramatic. Boring repeat work (notary swearings, follow-up oncology appointments, second-quarter HR meetings) doesn't make books because nobody publishes "Tuesday at 11am I notarised three diplomas." So the corpus skews exceptional cases and underweights bread-and-butter. The mode of our dataset will not match the mode of our real pipeline.

Geography is the bigger problem. Most published interpreter literature is US court, UN/EU institutional, or war-zone (Iraq/Afghanistan linguists subgenre). Ireland, UK, Iberia community + commercial work is underrepresented.

"Where do jobs come from" channel-wise is partly already known — rosters, LSP gatekeepers, professional bodies (ATII, ITIA, AIIC), direct referrals, GBP. The corpus will not be shocking on the channel map. Novel insight will live in the less obvious axes: trigger events and decision-maker chokepoints. Extraction should weight those columns.

## Tech approach (planned)

- Source: see `reading-list.md` for the tiered book list.
- Acquisition: physical or ebook copies; OCR scans for non-ebook texts via existing Workers AI document pipeline.
- Extraction: Workers AI (Llama) prompted with the schema above, processing chapter chunks. Same model layer as document analysis — no new infra needed.
- Storage: SQLite for development; Parquet for any larger-scale joins. Both inside this folder.
- Cross-reference: join against `SalesManager` orders export and Revolut transaction log to surface deltas between published patterns and our actual pipeline.

## What success looks like

A dataset of 1,000–3,000 coded job-events from ~15 books, with at least three findings where the literature pattern materially differs from our pipeline and points to a market gap or untapped channel.

## Out of scope for now

- War-zone interpreter memoirs (Iraq/Afghanistan linguist subgenre) — high drama, low operational relevance to our markets.
- Sign-language interpreting books — different market structure.
- Pure interpreting theory / linguistics texts without practitioner data.
- Paid industry reports (Slator, Nimdzi, CSA) — separate budget line, decision deferred until extraction is proven on free/owned material.

## Files in this folder

- `README.md` — this file
- `reading-list.md` — curated list of books, ISBNs, status, online discovery directories

## Owner & cadence

Owner: Maciej. No fixed cadence. Next review after first 2–3 books acquired and a pilot extraction run.

Created: 10/06/2026
