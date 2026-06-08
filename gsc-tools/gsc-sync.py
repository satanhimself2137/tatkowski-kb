#!/usr/bin/env python3
"""gsc-sync.py - stage GSC CSVs from the local pipeline and commit them to gsc/ in the repo.
Idempotent: only commits if content changed. Run after the GSC export step.
Usage: python gsc-sync.py [--by Maciej]
"""
import os, sys, subprocess, base64, json, glob, datetime

REPO = "satanhimself2137/tatkowski-kb"
BRANCH = "main"
SRC = r"D:\tatkowski-gsc\data\csv"
BY = "Maciej"
if "--by" in sys.argv:
    BY = sys.argv[sys.argv.index("--by") + 1]

PROPS = {
    "sc-domain_tatkowski.com": "ie_tatkowski.com",
    "sc-domain_tatkowski.co.uk": "uk_tatkowski.co.uk",
    "sc-domain_tatkowski.es": "es_tatkowski.es",
    "sc-domain_tatkowski.pt": "pt_tatkowski.pt",
}

def gh(args, input_data=None):
    return subprocess.run(["gh"] + args,
                          input=(input_data.encode("utf-8") if input_data else None),
                          capture_output=True, timeout=90)

def gh_text(args, input_data=None):
    return gh(args, input_data).stdout.decode("utf-8", "replace")

# 1. gather local files -> repo paths
staged = {}  # repo_path -> local_path
for src_name, dst_name in PROPS.items():
    d = os.path.join(SRC, src_name)
    if not os.path.isdir(d):
        continue
    for f in glob.glob(os.path.join(d, "*.csv")):
        staged[f"gsc/{dst_name}/{os.path.basename(f)}"] = f
for f in glob.glob(os.path.join(SRC, "_analysis_*.csv")) + glob.glob(os.path.join(SRC, "_ie_meta.tsv")):
    staged[f"gsc/_analysis_ie/{os.path.basename(f)}"] = f

if not staged:
    print("gsc-sync: no local CSVs found at", SRC, "- nothing to do.")
    sys.exit(0)

# 2. head + base tree
head = gh_text(["api", f"repos/{REPO}/git/ref/heads/{BRANCH}", "--jq", ".object.sha"]).strip()
base_tree = gh_text(["api", f"repos/{REPO}/git/commits/{head}", "--jq", ".tree.sha"]).strip()

# 3. blobs
entries = []
for repo_path, local_path in sorted(staged.items()):
    with open(local_path, "rb") as fh:
        b64 = base64.b64encode(fh.read()).decode("ascii")
    sha = json.loads(gh_text(["api", f"repos/{REPO}/git/blobs", "-X", "POST", "--input", "-"],
                              json.dumps({"content": b64, "encoding": "base64"})))["sha"]
    entries.append({"path": repo_path, "mode": "100644", "type": "blob", "sha": sha})

# 4. tree
tree_sha = json.loads(gh_text(["api", f"repos/{REPO}/git/trees", "-X", "POST", "--input", "-"],
                               json.dumps({"base_tree": base_tree, "tree": entries})))["sha"]

# idempotent: if new tree == base tree, nothing changed
if tree_sha == base_tree:
    print("gsc-sync: data unchanged, no commit needed.")
    sys.exit(0)

# 5. commit + move ref
today = datetime.date.today().strftime("%d/%m/%y")
msg = f"[Claude/{BY}] - weekly GSC refresh (auto) - {today}"
commit_sha = json.loads(gh_text(["api", f"repos/{REPO}/git/commits", "-X", "POST", "--input", "-"],
                                 json.dumps({"message": msg, "tree": tree_sha, "parents": [head]})))["sha"]
gh(["api", f"repos/{REPO}/git/refs/heads/{BRANCH}", "-X", "PATCH", "--input", "-"],
   json.dumps({"sha": commit_sha}))
print(f"gsc-sync: committed {len(entries)} files -> https://github.com/{REPO}/commit/{commit_sha}")
