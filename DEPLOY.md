# Deploying to GitHub Pages

This directory is a **standalone git repo** (separate from `autoresearch_idea_harness` to avoid
nested repos). Project-level landing page at root + one subdirectory per benchmark.

- `index.html` — landing page linking to each benchmark dashboard.
- `mls-bench-lite/` — the live MLS-Bench-Lite dashboard (86 MB, self-contained, relative paths).
- `.nojekyll` — serves files verbatim, no build step.
- SSH from this machine authenticates to GitHub as **XinghanLi66** (verified), so a push works
  once the repo exists. An SSH key can't *create* a repo — do step 1 in the web UI.

## One-time deploy

1. **Create an empty public repo** on github.com (no README/gitignore/license).
2. **Push** (from this directory):
   ```bash
   ./deploy.sh git@github.com:XinghanLi66/<repo-name>.git
   ```
3. **Enable Pages**: repo → Settings → Pages → Source *Deploy from a branch* → Branch `main` `/ (root)` → Save.
4. After ~1 min:
   - Landing: `https://xinghanli66.github.io/<repo-name>/`
   - MLS dashboard: `https://xinghanli66.github.io/<repo-name>/mls-bench-lite/`

## Updating

```bash
(cd /newcpfs/lxh/agentic-training/autoresearch_idea_harness && python3 scripts/mls_dashboard_extract.py)
./sync.sh
git push origin main
```
