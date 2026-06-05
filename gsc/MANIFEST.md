# Google Search Console Data — Tatkowski (all properties)

Snapshot of GSC performance data for all four market properties, committed to the repo so any team member's Claude can pull and analyse it directly (no GSC login, no local pipeline needed). Source pipeline: `D:\tatkowski-gsc` on Maciej's machine, pulled weekly (Sundays 14:00). This snapshot: 05 June 2026, data through 2026-06-01.

## Properties

| Folder | Market | Domain | Data from | Notes |
|---|---|---|---|---|
| `ie_tatkowski.com` | Ireland | tatkowski.com | 2025-08-10 | Real volume. ~10 months. The one with signal. |
| `uk_tatkowski.co.uk` | UK | tatkowski.co.uk | 2026-03-01 | Early. Low volume, building. |
| `es_tatkowski.es` | Spain | tatkowski.es | 2026-05-20 | Near-zero. 1 impression so far. |
| `pt_tatkowski.pt` | Portugal | tatkowski.pt | 2026-05-20 | Near-zero. 1 impression so far. BrightLocal campaign launched 05/06/26 — expect movement over coming weeks. |

**Honest state (05/06/26):** Only IE has enough data to analyse meaningfully. UK is early. ES/PT are effectively pre-traffic — any "analysis" there is reporting near-zeros until citations and site age kick in. Don't manufacture trends from 1–2 impressions.

## File schema

Every CSV: GSC metrics are `clicks, impressions, ctr, position`. The leading `dim1/dim2/dim3` columns are the GSC dimensions, which differ per file:

| File | dim1 | dim2 | dim3 | Use for |
|---|---|---|---|---|
| `date_only.csv` | date | — | — | Daily clicks/impressions trend over time |
| `date_query_country.csv` | date | query | country (ISO-3, e.g. irl/gbr) | What searches surface the site, by country |
| `date_query_page.csv` | date | query | landing page URL | Which query lands on which page |
| `date_page_device.csv` | date | page URL | device (DESKTOP/MOBILE) | Page performance by device |
| `searchappearance.csv` | appearance type | — | — | Rich-result types (e.g. PRODUCT_SNIPPETS) |

Notes: `ctr` is a fraction (0.05 = 5%). `position` is average rank (lower = better; 1 = top). A row with clicks=0, impressions=1 means "shown once, not clicked" — normal for low positions.

## Pre-computed IE analysis (`_analysis_ie/`)

Convenience rollups for Ireland, last-90-days:
- `_analysis_top_queries_L90.csv` — top queries by impressions, with avg position + CTR%
- `_analysis_ctr_killers_L90.csv` — pages with impressions but poor CTR (ranking but not converting clicks)
- `_analysis_page1_L90.csv` / `_analysis_page2_L90.csv` — queries sitting on search page 1 vs page 2
- `_ie_meta.tsv` — page titles/meta for IE URLs (for matching pages to content)

These are IE-only and a snapshot; for anything else, compute from the raw CSVs above.

## How to analyse (any Claude, via Desktop Commander)

The data is in this repo. To work on it, pull the folder you need then load with pandas:

```python
import pandas as pd
# after pulling the CSV locally (see repo README for gh api fetch, or use the kb-style helper)
df = pd.read_csv("date_query_country.csv")
df.columns = ["date","query","country","clicks","impressions","ctr","position"]  # name the dims
# top queries by impressions, last 90d:
df["date"] = pd.to_datetime(df["date"])
recent = df[df["date"] >= df["date"].max() - pd.Timedelta(days=90)]
top = (recent.groupby("query")
       .agg(impr=("impressions","sum"), clicks=("clicks","sum"), pos=("position","mean"))
       .sort_values("impr", ascending=False).head(20))
print(top)
```

Same pattern for any property — only IE/UK have enough rows to be interesting today.

## Refresh

Maciej's pipeline pulls weekly. To refresh this snapshot: re-run the staging + commit (the data lives at `D:\tatkowski-gsc\data\csv` on Maciej's machine). Raw JSON is intentionally NOT committed — CSVs are the working format.
