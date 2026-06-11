# Interpreting Corpus — Cashflow Intelligence Extraction

**Status:** SHIPPED (v1) — 11/06/26
**Owner:** Maciej (via Claude, Opus)
**Location:** `research/interpreting-corpus/`

## Scope
Deep-read 11 practitioner/academic books on translation & interpreting (~1.26M words) to extract operational, cashflow-relevant business intelligence for Tatkowski. Goal stated by Maciej: surface practices that could unlock the cashflow problem.

## What shipped
- All 11 books extracted to plain text → `extracted/text/` (verified by size).
- Per-book grounded notes → `extracted/notes/01–11` (~63KB). Every load-bearing claim verified against source text during extraction (Tustison agency contacts, Mikkelson's 8 Canons verbatim, Routledge PSI outsourcing + Tseng model verbatim, China RMB-6000 "halo" passage, Medical Interpreter US-scope caveat).
- `MASTER-EXTRACTION.md` — 27KB thematic synthesis, 10 sections: Pricing Playbook, Cashflow Discipline, Client-Acquisition Engine, Quality & Ops, ToS Template, B2B/Partnership, Scaling Math, Market Intelligence, Forbidden Patterns, Tatkowski Action Map.
- Extraction script → `scripts/extract.py`.

## Yield assessment (honest)
- ★ High: Jenner, Samuelsson-Brown, McKay, Gebhardt, Mikkelson, Routledge PSI.
- Medium: Tustison (partnership target lists), Community Interpreter (non-circumvention ethic), Medical Interpreter (healthcare compliance-as-risk-control, US-scoped).
- Low: Conference Interpreting (training bible, points to AIIC for rates), China (one durable lesson: scarcity pricing + defend with quality).

## Highest-leverage finding
Three convergent disciplines attack the invoice-to-cash gap directly: **30/30/40 staged payment + non-payment escalation ladder + no-client-over-25%**. Multiple independent authors land on these.

## Next actions (tracked in MASTER-EXTRACTION §10)
Immediate cashflow-direct items to operationalise in SalesManager: 30/30/40 in SmartQuote + B2B template; automated escalation-ladder reminder stages; discount-reply canned response; revenue-concentration flag; annual inflation-raise calendar entry.

## Open questions
- Which immediate-tier actions does Maciej want wired into SalesManager first?
- Is there a v2 (the 3 remaining books from the original 14-book reading list)? Deferred unless Maciej wants the long tail.
