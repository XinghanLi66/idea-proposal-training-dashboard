# Deploying the MLS-Bench-Lite dashboard to GitHub Pages

This directory is a **standalone git repo** (separate from `autoresearch_idea_harness` to avoid
nested repos) containing the static dashboard at its root — ready for GitHub Pages.

- Content: `index.html` + `index.json` + `tasks/` + `cells/` + `raw_scores/` (86 MB, 554 files).
- Fully relative paths + `.nojekyll` → serves as-is, no build step.
- SSH from this machine authenticates to GitHub as **XinghanLi66** (verified), so a push works
  once the repo exists.

## One-time deploy

1. **Create an empty public repo** on github.com (no README/gitignore/license), e.g.
   `mls-bench-lite-dashboard` under `XinghanLi66`.
2. **Push** (from this directory):
   ```bash
   ./deploy.sh git@github.com:XinghanLi66/mls-bench-lite-dashboard.git
   ```
3. **Enable Pages**: repo → Settings → Pages → Source *Deploy from a branch* → Branch `main` `/ (root)` → Save.
4. After ~1 min the site is live at:
   `https://xinghanli66.github.io/mls-bench-lite-dashboard/`

## Updating later

Regenerate the data, then re-sync and push:
```bash
(cd /newcpfs/lxh/agentic-training/autoresearch_idea_harness && python3 scripts/mls_dashboard_extract.py)
./sync.sh
git push origin main
```
