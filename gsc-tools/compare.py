import pandas as pd
import os

base = r"D:\tatkowski-gsc\data\csv"
sites = {
    "IE (tatkowski.com)":   "sc-domain_tatkowski.com",
    "UK (tatkowski.co.uk)": "sc-domain_tatkowski.co.uk",
    "ES (tatkowski.es)":    "sc-domain_tatkowski.es",
    "PT (tatkowski.pt)":    "sc-domain_tatkowski.pt",
}

curr_end   = pd.Timestamp("2026-06-01")
curr_start = curr_end - pd.Timedelta(days=27)
prev_end   = curr_start - pd.Timedelta(days=1)
prev_start = prev_end - pd.Timedelta(days=27)

print(f"Current:  {curr_start.date()} -> {curr_end.date()} (28d)")
print(f"Previous: {prev_start.date()} -> {prev_end.date()} (28d)")
print()

def pct(a, b):
    if b == 0:
        return "n/a" if a == 0 else "+inf"
    return f"{(a-b)/b*100:+.0f}%"

rows = []
for label, folder in sites.items():
    fp = os.path.join(base, folder, "date_only.csv")
    if not os.path.exists(fp):
        continue
    df = pd.read_csv(fp)
    df.rename(columns={"dim1": "date"}, inplace=True)
    df["date"] = pd.to_datetime(df["date"])
    for c in ("clicks","impressions","ctr","position"):
        df[c] = pd.to_numeric(df[c])
    curr = df[(df["date"] >= curr_start) & (df["date"] <= curr_end)]
    prev = df[(df["date"] >= prev_start) & (df["date"] <= prev_end)]
    cc, ci = int(curr["clicks"].sum()), int(curr["impressions"].sum())
    pc, pi = int(prev["clicks"].sum()), int(prev["impressions"].sum())
    cctr = (cc/ci*100) if ci else 0
    pctr = (pc/pi*100) if pi else 0
    cp = (curr["position"]*curr["impressions"]).sum()/ci if ci else 0
    pp = (prev["position"]*prev["impressions"]).sum()/pi if pi else 0
    rows.append([label, f"{pc} -> {cc}", pct(cc,pc), f"{pi} -> {ci}", pct(ci,pi),
                 f"{pctr:.2f}% -> {cctr:.2f}%", f"{pp:.1f} -> {cp:.1f}"])

r = pd.DataFrame(rows, columns=["site","clicks","Dclk","impressions","Dimp","CTR","avg pos"])
print(r.to_string(index=False))

# top moving queries for IE
print("\n--- IE: TOP CLICK GAINERS (queries) ---")
qfile = os.path.join(base, "sc-domain_tatkowski.com", "date_query_page.csv")
df = pd.read_csv(qfile)
df.rename(columns={"dim1":"date","dim2":"query","dim3":"page"}, inplace=True)
df["date"] = pd.to_datetime(df["date"])
df["clicks"] = pd.to_numeric(df["clicks"])
df["impressions"] = pd.to_numeric(df["impressions"])
df["position"] = pd.to_numeric(df["position"])
cur = df[(df["date"]>=curr_start)&(df["date"]<=curr_end)].groupby("query").agg(
    clicks=("clicks","sum"), imps=("impressions","sum"),
    pos=("position", lambda x: (x*df.loc[x.index,"impressions"]).sum()/max(df.loc[x.index,"impressions"].sum(),1))
).reset_index()
pre = df[(df["date"]>=prev_start)&(df["date"]<=prev_end)].groupby("query").agg(
    clicks=("clicks","sum"), imps=("impressions","sum"),
    pos=("position", lambda x: (x*df.loc[x.index,"impressions"]).sum()/max(df.loc[x.index,"impressions"].sum(),1))
).reset_index()
m = cur.merge(pre, on="query", how="outer", suffixes=("_c","_p")).fillna(0)
m["clk_delta"] = m["clicks_c"] - m["clicks_p"]
m["imp_delta"] = m["imps_c"] - m["imps_p"]
gainers = m.sort_values("clk_delta", ascending=False).head(10)
print(gainers[["query","clicks_p","clicks_c","clk_delta","imps_p","imps_c","imp_delta"]].to_string(index=False))

print("\n--- IE: TOP IMPRESSION GAINERS (queries) ---")
imp_gainers = m.sort_values("imp_delta", ascending=False).head(10)
print(imp_gainers[["query","imps_p","imps_c","imp_delta","pos_p","pos_c"]].to_string(index=False))

print("\n--- IE: BIGGEST LOSERS (queries) ---")
losers = m.sort_values("imp_delta", ascending=True).head(10)
print(losers[["query","imps_p","imps_c","imp_delta","clicks_p","clicks_c"]].to_string(index=False))
