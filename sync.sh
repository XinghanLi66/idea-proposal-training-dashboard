#!/usr/bin/env bash
# Refresh the MLS-Bench-Lite dashboard subsite from the canonical extractor output, then commit.
# Run the extractor first if the data is stale:
#   (cd /newcpfs/lxh/agentic-training/autoresearch_idea_harness && python3 scripts/mls_dashboard_extract.py)
set -euo pipefail
SRC=/newcpfs/lxh/agentic-training/autoresearch_idea_harness/runs/researcher_cot/mls_lite_dashboard
cd "$(dirname "$0")"
DEST=mls-bench-lite
mkdir -p "$DEST"
for item in index.html index.json README.md tasks cells raw_scores; do
  rm -rf "$DEST/$item"
  cp -r "$SRC/$item" "$DEST/$item"
done
git add -A
if git diff --cached --quiet; then echo "no changes"; else
  git commit -q -m "sync mls-bench-lite data $(date -u +%Y-%m-%dT%H:%MZ)"
  echo "committed. push with: git push origin main"
fi
