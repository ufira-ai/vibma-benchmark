# Vibma Benchmark

Standardized evaluation of AI models performing design tasks in Figma through [Vibma](https://github.com/nicepkg/vibma) MCP (V0.3.1).

## How It Works

A model connects to Figma via Vibma and is given a multi-step design challenge ([`instructions.md`](instructions.md)) — build a design system page, then a UI mockup, following proper design practices throughout.

The model runs via [Cursor agent CLI](https://cursor.com/docs/cli/using) with `--output-format stream-json`, which captures the full conversation — every tool call, response, and decision — into an NDJSON log. Opus 4.6 then reviews both the Figma output and the conversation log to evaluate how the model approached the work.

After first-pass scoring, Opus provides specific improvement feedback. The model applies fixes (also captured via Cursor CLI), and Opus scores a second time focused on how well the model addressed the feedback.

```
cursor-agent runs model with instructions.md
        ↓
Model builds in Figma via Vibma (conversation logged as NDJSON)
        ↓
Opus 4.6 reviews Figma output + conversation log
        ↓
Opus writes report: scores, what went well, what didn't (first pass, /35)
        ↓
Opus gives specific improvement feedback → model applies fixes
        ↓
Opus reviews again → report on fix quality (second pass, /35)
        ↓
Final screenshot + report saved to results/
```

## Running a Benchmark

```bash
# Run the model — captures full conversation to NDJSON
cursor-agent -p \
  --model <model-name> \
  --output-format stream-json \
  "$(cat instructions.md)" \
  > results/<model-name>-log.ndjson

# Opus reviews the work (in Claude Code or Cursor with Opus)
# Give it review.md + the NDJSON log + Vibma access to the Figma file
```

## Results

| Model | First Pass | After Fix | Visual |
|-------|-----------|-----------|--------|
| — | /35 | /35 | — |

<!-- Example row:
| Claude Sonnet 4.6 | 28/35 | 33/35 | [screenshot](results/claude-sonnet-4-6-final.png) |
-->

Full reports with commentary, score tables, and screenshots are in [`results/`](results/).

## Scoring

Each pass scores 7 criteria on a 1–5 scale (max 35).

**First pass** — did the model follow design practices on its own?

| Criterion | What's Evaluated |
|-----------|-----------------|
| Tool Usage | Read before write, efficient tool calls |
| Design Tokens | Styles/variables used vs hardcoded values |
| Layout Quality | Auto-layout, spacing, alignment |
| Naming | Semantic names on all layers |
| Accuracy | All required elements present |
| Lint Compliance | Ran lint, fixed issues |
| Visual Quality | Professional appearance, hierarchy |

**Second pass** — did the model fix what was flagged?

| Criterion | What's Evaluated |
|-----------|-----------------|
| Issue Coverage | All flagged issues addressed? |
| Fix Quality | Correct fixes, no regressions? |
| Token Remediation | Hardcoded values replaced with variables/styles? |
| Layout Fixes | Auto-layout and spacing issues resolved? |
| Naming Fixes | Default names replaced with semantic ones? |
| Lint Resolution | Previously failing checks now pass? |
| Visual Improvement | Visible improvement in the final screenshot? |

## License

MIT
