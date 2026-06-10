# Batch 1 — Source Books Inventory

11 books acquired and deduplicated. Ready for extraction.

## EPUB (9 files)

1. **How to Succeed as a Freelance Translator** — Corinne McKay (3rd ed, 2016)
   - File: `How to Succeed as a Freelance Translator, Third Edition -- Corinne; Zetzsche, Jost Mckay -- 3rd, 2016 -- BookBaby _ Made available through hoopla -- e0e35b2b52f847412b4df.epub`
   - Size: ~3.6 MB
   - Status: ✅ ready

2. **How to be a Successful Freelance Translator** — Robert Gebhardt (2nd ed, 2017)
   - File: `How to be a Successful Freelance Translator_ Second Edition -- Robert Gebhardt -- 2nd ed_, 2017 -- Acahi -- isbn13 9781521575369 -- 98d2b0c749ef65ca067751270c9da4de -- Anna's Archive.epub`
   - Size: ~2.1 MB
   - Status: ✅ ready

3. **The Entrepreneurial Linguist** — Judy & Dagmar Jenner (1st ed, 2010)
   - File: `The Entrepreneurial Linguist_ The Business-School Approach -- Judy & Jenner, Dagmar -- 6a0d0648b24624e37d5d766608f19f95 -- Anna's Archive.epub`
   - Size: ~3.6 MB
   - Status: ✅ ready

4. **Introduction to Court Interpreting** — Holly Mikkelson (2nd ed, 2017)
   - File: `Introduction to Court Interpreting -- Mikkelson, Holly -- Routledge -- 373f41ab00f93c146a08f9850eb8dc96 -- Anna's Archive.epub`
   - Size: ~1.2 MB
   - Status: ✅ ready

5. **The Medical Interpreter** — Marjory Bancroft et al. (1st ed, 2016)
   - File: `The medical interpreter _ a foundation textbook for medical -- Marjory A_ Bancroft; Sofia Garcia Beyaert; Katharine Allen; -- 1, PS, 2016 -- Culture -- isbn13 9780996651721 -- f5364e17f7ee48ded9.epub`
   - Size: ~4.8 MB
   - Status: ✅ ready

6. **The Community Interpreter** — Marjory Bancroft et al. (1st ed, 2015)
   - File: `The community interpreter _ an international textbook _ -- Marjory A_ Bancroft; Sofia Garcia Beyaert; Katharine Allen; -- 1, 2015-06-01 -- Culture and -- isbn13 9780982316672 -- bcc95229f58a07a6.epub`
   - Size: ~4.2 MB
   - Status: ✅ ready

7. **The Routledge Handbook of Public Service Interpreting** — Laura Gavioli (ed., 2022)
   - File: `The Routledge Handbook of Public Service Interpreting -- Laura Gavioli -- 2022 -- Routledge -- 2c60cfba69b493a84aa875eed5cc1415 -- Anna's Archive.epub`
   - Size: ~6.1 MB
   - Status: ✅ ready

8. **Translator's Market** — Clint Tustison (2017)
   - File: `Translator's Market_ The GIANT Book of Translation Agencies_ -- Tustison, Clint [Tustison, Clint] -- 2017 -- isbn13 9782634293355 -- e663e91b7105a7052566b1d186a0ef8b -- Anna's Archive.epub`
   - Size: ~2.3 MB
   - Status: ✅ ready

9. **The Rise of Conference Interpreting in China** — Zhang & Moratto (2023, bonus)
   - File: `The Rise of Conference Interpreting in China_ Insiders' -- Zhang, Irene A_ & Moratto, Riccardo -- 2023 -- Routledge -- dd8bb8998ccdda075745850121fcaef6 -- Anna's Archive.epub`
   - Size: ~1.8 MB
   - Status: ✅ ready

## PDF (2 files)

10. **A Practical Guide for Translators** — Geoffrey Samuelsson-Brown (5th ed)
    - File: `A Practical Guide for Translators (38) (Topics in -- Geoffrey Samuelsson-Brown -- Topics in translation, 5th ed_, Bristol, UK, New York, -- isbn13 9781847692511 -- f97990e0cfa9fe0616fb43558730af8.pdf`
    - Size: ~8.2 MB
    - Status: ⚠️ PDF — needs text extraction or Calibre conversion

11. **Conference Interpreting: A Complete Course and Trainer's Guide** — Setton & Dawrant
    - File: `Conference Interpreting – A Complete Course and Trainer's -- Robin Setton, Andrew Dawrant,John Benjamins Publishing -- Benjamins translation library -- isbn13 9789027258632 -- e80bb34482e051dc13b.pdf`
    - Size: ~12.4 MB
    - Status: ⚠️ PDF — needs text extraction or Calibre conversion

## Removed (deduped/wrong)

- **Found in Translation** (short stories by Frank Wynne) — deleted (wrong book)
- **The Entrepreneurial Linguist (duplicate)** — deleted (hash: 6a0d0648b24624e37d5d766608f19f95, kept one copy)

## Next steps

1. Convert PDFs (Samuelsson-Brown, Setton/Dawrant) to EPUB via Calibre or extract text locally
2. Unzip all EPUBs to `extracted/` folder
3. Run extraction pipeline (Phase 1): feed chapter text to Workers AI
4. Insert results into SQLite (`data/events.db`)
5. Query and cross-reference against SalesManager pipeline data

## Location

All books in: `D:\tatkowski-kb\research\interpreting-corpus\sources\`

Extracted content: `D:\tatkowski-kb\research\interpreting-corpus\extracted\`

Database: `D:\tatkowski-kb\research\interpreting-corpus\data\events.db` (created by pipeline)

---

**Status**: Batch 1 complete and staged. Ready for extraction pipeline build-out.

**Created**: 10/06/2026
