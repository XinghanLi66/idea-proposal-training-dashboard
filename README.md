# MLS-Bench-Lite Results Dashboard (cc004)

Local GUI dashboard for the V3 MLS-Bench-Lite eval: **30 tasks × 18 arms**, every faithful
cell clickable down to problem description, master (proposer) prompt+output, worker
prompt+code, and per-seed scores.

## View it

```bash
cd autoresearch_idea_harness/runs/researcher_cot/mls_lite_dashboard
python3 -m http.server 8712 --bind 127.0.0.1
# open http://127.0.0.1:8712/index.html
```

(Must be served over HTTP — the page uses `fetch()` for the JSON data tree.)

## Regenerate the data

```bash
cd autoresearch_idea_harness
python3 scripts/mls_dashboard_extract.py            # calls `mlsbench score` per task (cached to raw_scores/)
python3 scripts/mls_dashboard_extract.py --no-score # reuse cached scores, re-scan logs only
```

## Layout

- `index.json` — the matrix: `tasks[]`, `arms[]` (grouped by 6 model families × {base,sft,rl}),
  `cells[task][arm] = {status, score, n_runs, n_scored, detail}`, plus `counts`/`legend`.
- `tasks/<slug>.json` — shared per-task detail: description, metric, master prompt (system/user),
  baseline methods + raw metrics.
- `cells/<slug>__<arm>.json` — per-cell detail: master output (idea + full proposal = the mocked
  human researcher), per-seed scores, and one entry per worker run (prompt, edit trace, final code, summary).
- `raw_scores/<slug>.json` — cached `mlsbench score` output (delete to force a re-query).

## Cell status semantics (faithful)

| status | meaning | cell |
|---|---|---|
| `ok` | run produced a valid metric → real rescaled score (**`0` = a TRUE 0**, not missing) | colored by score (50 = strong baseline, 100 = upper bound), clickable |
| `zero` | genuine 0-floor: proposal ran but ≤ worst anchor, no metric row emitted | `0*`, clickable |
| `failed` | broken run: empty worker output / crash / OOM / infra — no valid metric | `FAIL`, clickable |
| `unfinished` | dropped `robo-humanoid-sim2real-algo` row, `m2rl` (235B RL still training) column, or never-dispatched cell | `—`, not clickable |

### How status is decided (per cell, faithful to the freshest data)

Status is derived **cell-level from the live leaderboard** (`MLS-Bench/tasks/<t>/leaderboard.csv`),
which is fresher than `mls_lite_eval/results_table_FINAL.md` (e.g. `rl-value-discrete` and
`robomimic-bc-loss` were re-run after the 2026-07-22 snapshot and now have real scores):

1. A final row with ≥1 populated metric column ⇒ `ok`, score = `mlsbench score` rescaled ×100
   (this is the only reliable way to separate a genuine 0 from missing data — `mlsbench score`
   itself collapses both to `0.0`).
2. No populated metric but the run was attempted ⇒ `zero` if the task is a known genuine-floor
   task (`failure_reasons.json` verdict), else `failed`.
3. No rows and no logs ⇒ `unfinished` (never dispatched).

Validated against `results_table_FINAL.md`: **215/227** documented numeric cells match exactly;
the 12 differences are all cells the FINAL snapshot marked stale/`0*` that the live leaderboard
has since updated.

## The 18 arms

6 model families × {base, SFT, RL}: Qwen3-8B (`base8b`/`sft8b`/`qwen3-8b-rl`), Qwen3-14B
(`base14b`/`sft14b`/`qwen3-14b-rl`), Qwen3-32B (`base32bq3`/`sft32b`/`qwen3-32b-rl`),
Qwen2.5-32B-Inst (`base32b`/`qwen25sft`/`rl`), DeepSeek-R1-Qwen3-8B (`d1base`/`d1sft`/`d1rl`),
Qwen3-235B-A22B (`m2base`/`m2sft`/`m2rl`). The arm key equals the leaderboard tag
(`claude-fable-5__<arm>:eng:ctx_proposal`) and the log-dir suffix. Worker = Claude fable-5.
