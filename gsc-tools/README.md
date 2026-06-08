# Tatkowski GSC Puller

Pulls 16 months of Google Search Console data across all 4 markets
(IE, UK, ES, PT) for SEO analysis.

## Setup

1. Service account `gsc-puller@tatkowski-gsc.iam.gserviceaccount.com`
   added as Restricted user to each GSC property.
2. JSON key at `D:\secrets\gsc-key.json` (path in `.env`).
3. `npm install`

## Commands

```
npm test     # list accessible properties (verifies auth)
npm run pull # full historical pull (resumable, 30-60 min)
npm run export # convert raw JSON to flat CSVs
```

## Output

- `data/raw/{property}/{YYYY-MM}/{combo}.json` — source-of-truth JSON dumps
- `data/csv/{property}/{combo}.csv` — flat CSV exports
- `data/_progress.jsonl` — completed tasks (delete to force re-pull)

## Notes

- 16-month max retention is a GSC API limit. Older data is gone.
- Some queries are anonymised for privacy; not recoverable.
- Per-property quota: 30,000 queries/day. We use < 1%.
- All free of charge.
