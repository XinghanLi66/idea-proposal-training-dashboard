#!/usr/bin/env bash
# Push this dashboard bundle to a GitHub repo and remind about Pages setup.
# Usage: ./deploy.sh <git-remote-url>
#   e.g. ./deploy.sh git@github.com:XinghanLi66/mls-bench-lite-dashboard.git
set -euo pipefail
REMOTE="${1:-}"
[ -z "$REMOTE" ] && { echo "usage: $0 <git-remote-url>"; exit 1; }
cd "$(dirname "$0")"

if git remote | grep -qx origin; then git remote set-url origin "$REMOTE"; else git remote add origin "$REMOTE"; fi
git branch -M main
git push -u origin main

# derive the Pages URL (works for git@github.com:USER/REPO.git and https form)
slug="$(printf '%s' "$REMOTE" | sed -E 's#^git@github.com:##; s#^https://github.com/##; s#\.git$##')"
user="${slug%%/*}"; repo="${slug##*/}"
cat <<EOF

Pushed to $REMOTE (branch: main).

Next — enable GitHub Pages (one-time):
  1. https://github.com/$slug/settings/pages
  2. Source: "Deploy from a branch"  ->  Branch: main  /  (root)  ->  Save
  3. Wait ~1 min for the first build.

Site URL:  https://$(printf '%s' "$user" | tr '[:upper:]' '[:lower:]').github.io/$repo/
EOF
