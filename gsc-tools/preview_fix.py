import sys, re
from pathlib import Path
FFFD = "\uFFFD"
def cur_for(m): return "£" if m == "uk" else "€"
def fix_line(line, market):
    cur = cur_for(market); out = line
    out = re.sub(rf"(\d(?:\.\d+)?){FFFD}{FFFD}(\d)", lambda m: f"{m.group(1)}–{cur}{m.group(2)}", out)
    out = re.sub(rf"{FFFD}(\d)", lambda m: cur + m.group(1), out)
    out = re.sub(rf"(\d+)\s+{FFFD}\s+(\d+)", lambda m: f"{m.group(1)} × {m.group(2)}", out)
    out = re.sub(rf"(\d){FFFD}", lambda m: m.group(1) + "★", out)
    out = re.sub(rf" {FFFD} ", " — ", out)
    out = re.sub(rf"([a-zA-Z]){FFFD}([a-zA-Z])", lambda m: m.group(1) + "–" + m.group(2), out)
    out = re.sub(rf"{FFFD}{FFFD}", "", out)
    out = out.replace(FFFD, "•")
    return out

# Preview UK interpreting + UK phone-interpreting
for market, name in [("uk","interpreting.astro"), ("uk","phone-interpreting.astro"), ("uk","european-languages.astro")]:
    p = Path(r"D:\tatkowski-interpreting-recruitment") / "apps" / market / "src" / "pages" / name
    print(f"\n==== {market}/{name} ====")
    text = p.read_bytes().decode("utf-8", errors="replace")
    for i, line in enumerate(text.splitlines(), 1):
        if FFFD in line:
            new = fix_line(line, market)
            old_snip = line.strip()[:120]
            new_snip = new.strip()[:120]
            print(f"L{i}:")
            print(f"  -- {old_snip}")
            print(f"  ++ {new_snip}")
