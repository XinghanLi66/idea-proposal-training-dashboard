# AutoResearch — Idea-Proposal Training · Benchmark Dashboards

Static GitHub Pages site hosting faithful result dashboards for the research-idea proposal-training
project (SFT + RL across model families; worker = Claude fable-5). Built to hold multiple benchmarks.

```
index.html          project landing page (links to each benchmark + data samples)
.nojekyll           serve files verbatim (no Jekyll build)
mls-bench-lite/     MLS-Bench-Lite dashboard (30 tasks × 18 arms)  ← LIVE
  index.html          the results matrix + clickable cell detail
  index.json          matrix data
  tasks/ cells/ raw_scores/
  README.md           data model + faithfulness notes
data-samples/       SFT & RL (DPO) training-data demo  ← LIVE
  index.html          SFT / DPO tabbed viewer
  data.json           ~10 diverse SFT records + ~10 diverse DPO pairs
# mab/              MLAgentBench dashboard  ← coming soon
```

## Deploy (GitHub Pages)

1. Create an empty **public** repo on github.com (no README/license).
2. Push:  `./deploy.sh git@github.com:<user>/<repo>.git`
3. Enable Pages: repo → Settings → Pages → *Deploy from a branch* → `main` / root.
4. Live at `https://<user>.github.io/<repo>/` (landing) and `.../mls-bench-lite/` (dashboard).

## Update MLS-Bench-Lite data later

```bash
(cd /newcpfs/lxh/agentic-training/autoresearch_idea_harness && python3 scripts/mls_dashboard_extract.py)
./sync.sh && git push origin main
```

## Add MAB later

Drop the MAB dashboard under `mab/`, flip its card in `index.html` from `soon` to `live`
(pointing at `mab/index.html`), commit, and push.
