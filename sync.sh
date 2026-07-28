#!/usr/bin/env bash
# Refresh all subsites (MLS-Bench-Lite, MAB) + the SFT/RL data samples, then commit.
# Regenerate the source data first if stale:
#   cd /newcpfs/lxh/agentic-training/autoresearch_idea_harness
#   python3 scripts/mls_dashboard_extract.py && python3 scripts/mab_dashboard_extract.py
set -euo pipefail
HARNESS=/newcpfs/lxh/agentic-training/autoresearch_idea_harness
cd "$(dirname "$0")"

# MLS-Bench-Lite (30x20)
SRC="$HARNESS/runs/researcher_cot/mls_lite_dashboard"; DEST=mls-bench-lite; mkdir -p "$DEST"
for item in index.html index.json README.md tasks cells raw_scores; do
  rm -rf "$DEST/$item"; [ -e "$SRC/$item" ] && cp -r "$SRC/$item" "$DEST/$item"
done

# MLAgentBench (5 x N) — source dir name is 'mab' (== the ../mab path the page fetches)
SRC="$HARNESS/runs/researcher_cot/mab"; DEST=mab; mkdir -p "$DEST"
for item in index.html index.json tasks cells; do
  rm -rf "$DEST/$item"; [ -e "$SRC/$item" ] && cp -r "$SRC/$item" "$DEST/$item"
done

# SFT/RL data-samples demo
python3 "$HARNESS/scripts/build_data_samples.py" --out "$(pwd)/data-samples"

git add -A
if git diff --cached --quiet; then echo "no changes"; else
  git commit -q -m "sync dashboards (MLS + MAB) + data samples $(date -u +%Y-%m-%dT%H:%MZ)"
  echo "committed. push with: git push origin main"
fi


