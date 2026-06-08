"""Fix UTF-8 replacement characters across tatkowski monorepo."""
import sys, re
from pathlib import Path

ROOT = Path(r"D:\tatkowski-interpreting-recruitment")
FFFD = "\uFFFD"

FILES = [
    ("uk", "interpreting.astro"),
    ("uk", "phone-interpreting.astro"),
    ("uk", "school-interpreting.astro"),
    ("uk", "parent-teacher-meetings.astro"),
    ("uk", "apostille-service.astro"),
    ("uk", "european-languages.astro"),
    ("es", "apostille-service.astro"),
    ("es", "european-languages.astro"),
    ("pt", "apostille-service.astro"),
    ("pt", "european-languages.astro"),
]

def cur_for(m): return "£" if m == "uk" else "€"

def fix_line(line, market):
    cur = cur_for(market)
    out = line
    # Range with double FFFD between numbers/prices: "0.10??0.14" → "0.10–£0.14"
    out = re.sub(rf"(\d(?:\.\d+)?){FFFD}{FFFD}(\d)", lambda m: f"{m.group(1)}–{cur}{m.group(2)}", out)
    # Currency before digit
    out = re.sub(rf"{FFFD}(\d)", lambda m: cur + m.group(1), out)
    # × between numbers: "20 ? 5" → "20 × 5"
    out = re.sub(rf"(\d+)\s+{FFFD}\s+(\d+)", lambda m: f"{m.group(1)} × {m.group(2)}", out)
    # Star after digit
    out = re.sub(rf"(\d){FFFD}", lambda m: m.group(1) + "★", out)
    # Em dash mid-sentence ' ? '
    out = re.sub(rf" {FFFD} ", " — ", out)
    # Compound noun en dash a?b
    out = re.sub(rf"([a-zA-Z]){FFFD}([a-zA-Z])", lambda m: m.group(1) + "–" + m.group(2), out)
    # Double leftover — likely emoji loss, strip
    out = re.sub(rf"{FFFD}{FFFD}", "", out)
    # Remaining single FFFD → bullet (most common case: language list separators)
    out = out.replace(FFFD, "•")
    return out

def process(path, market, apply):
    raw = path.read_bytes()
    text = raw.decode("utf-8", errors="replace")
    if FFFD not in text: return 0, 0
    before = text.count(FFFD)
    new = "".join(fix_line(l, market) for l in text.splitlines(keepends=True))
    after = new.count(FFFD)
    fixed = before - after
    if apply:
        path.write_bytes(new.encode("utf-8"))
    return fixed, after

apply = "--apply" in sys.argv
print(f"{'APPLY' if apply else 'DRY RUN'}")
grand = 0; remain = 0
for market, name in FILES:
    p = ROOT / "apps" / market / "src" / "pages" / name
    f, r = process(p, market, apply)
    print(f"  {market}/{name:35}  fixed {f:3}  remaining {r}")
    grand += f; remain += r
print(f"\nTotal: {grand} fixed, {remain} remaining")
