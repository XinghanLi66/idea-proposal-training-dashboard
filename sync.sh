#!/usr/bin/env bash
# Refresh the MLS-Bench-Lite dashboard subsite + the SFT/RL data samples, then commit.
# Run the extractor first if the dashboard data is stale:
#   (cd /newcpfs/lxh/agentic-training/autoresearch_idea_harness && python3 scripts/mls_dashboard_extract.py)
set -euo pipefail
HARNESS=/newcpfs/lxh/agentic-training/autoresearch_idea_harness
SRC="$HARNESS/runs/researcher_cot/mls_lite_dashboard"
cd "$(dirname "$0")"
DEST=mls-bench-lite
mkdir -p "$DEST"
for item in index.html index.json README.md tasks cells raw_scores; do
  rm -rf "$DEST/$item"
  cp -r "$SRC/$item" "$DEST/$item"
done
# regenerate the diverse SFT/RL data-samples demo into ./data-samples/data.json
python3 "$HARNESS/scripts/build_data_samples.py" --out "$(pwd)/data-samples"
git add -A
if git diff --cached --quiet; then echo "no changes"; else
  git commit -q -m "sync dashboard + data samples $(date -u +%Y-%m-%dT%H:%MZ)"
  echo "committed. push with: git push origin main"
fi

