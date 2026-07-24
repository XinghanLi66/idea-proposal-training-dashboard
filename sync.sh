#!/usr/bin/env bash
# Refresh this bundle from the canonical dashboard output, then commit.
# Run the extractor first if the data is stale:
#   (cd /newcpfs/lxh/agentic-training/autoresearch_idea_harness && python3 scripts/mls_dashboard_extract.py)
set -euo pipefail
SRC=/newcpfs/lxh/agentic-training/autoresearch_idea_harness/runs/researcher_cot/mls_lite_dashboard
cd "$(dirname "$0")"
for item in index.html index.json README.md .nojekyll tasks cells raw_scores; do
  rm -rf "./$item"
  cp -r "$SRC/$item" "./$item"
done
git add -A
if git diff --cached --quiet; then echo "no changes"; else
  git commit -q -m "sync dashboard data $(date -u +%Y-%m-%dT%H:%MZ)"
  echo "committed. push with: git push origin main"
fi
