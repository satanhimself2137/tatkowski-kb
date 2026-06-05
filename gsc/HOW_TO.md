# GSC data - how to use it (for David's Claude, or any Claude)

All Google Search Console performance data for Tatkowski's four markets lives in this repo under `gsc/`. Any Claude with the GitHub CLI (`gh`) authed + Desktop Commander can pull it and analyse it. No GSC login needed.

## Quick start (run in Desktop Commander)

**1. Get the fetch helper** (one line, refetch anytime):
```powershell
$b64=(((gh api "repos/satanhimself2137/tatkowski-kb/contents/tools/gsc-fetch.ps1?ref=main" --jq ".content")) -join "") -replace "\s",""; [IO.File]::WriteAllBytes("$env:TEMP\gsc-fetch.ps1",[Convert]::FromBase64String($b64))
```

**2. Pull the data you want** (`pt`, `es`, `ie`, `uk`, `analysis`, or `all`):
```powershell
& "$env:TEMP\gsc-fetch.ps1" pt
& "$env:TEMP\gsc-fetch.ps1" es
```
Files land in `%TEMP%\gsc\<property>\`.

**3. Analyse with pandas:**
```python
import pandas as pd, os
g = os.path.join(os.environ["TEMP"],"gsc","pt_tatkowski.pt")
df = pd.read_csv(os.path.join(g,"date_query_country.csv"))
df.columns = ["date","query","country","clicks","impressions","ctr","position"]
# ... group, sort, summarise
```

## What the columns mean
GSC metrics are always `clicks, impressions, ctr (fraction), position (avg rank, lower=better)`. The leading dims differ per file - see `gsc/MANIFEST.md` for the full schema and per-property date ranges.

## Honest current state (05/06/2026)
- **PT / ES (David's markets):** effectively pre-traffic. 1 impression each so far. The BrightLocal PT campaign launched 05/06/26 - expect numbers to start moving over the coming weeks. Until then, "analysis" is mostly reporting near-zeros; don't read trends into 1-2 impressions.
- **IE:** ~10 months of real data - useful for research, keyword ideas, and seeing what actually ranks in this business (e.g. brand term converts, generic "translation services dublin" gets impressions at position ~30 but no clicks). David can study IE to understand what PT/ES should aim for.
- **UK:** early, building.

## Refresh
Maciej's pipeline pulls weekly. He re-commits this snapshot after pulls. If the data looks stale, ask Maciej to refresh `gsc/`.
