# Vibma Benchmark

Standardized evaluation of AI models performing design tasks in Figma through [Vibma](https://github.com/nicepkg/vibma) MCP.

## How It Works

A model connects to Figma via Vibma and is given a multi-step design challenge ([`instructions.md`](instructions.md)) — build a design system page, then a UI mockup, following proper design practices throughout.

Once complete, Opus 4.6 reviews the work using [`review.md`](review.md): inspects the node tree, checks for hardcoded values vs design tokens, runs lint, and scores across 7 criteria. It then gives the model specific feedback to fix. The model applies fixes, and Opus scores a second time — this pass measures how well the model responds to design review feedback.

```
Model reads instructions.md
        ↓
Model builds in Figma via Vibma
        ↓
Opus 4.6 reviews → scores design practice adherence (first pass, /35)
        ↓
Opus gives specific improvement feedback
        ↓
Model applies fixes
        ↓
Opus reviews again → scores fix quality (second pass, /35)
        ↓
Final screenshot + results saved
```

## Results

| Model | First Pass | After Fix | Visual |
|-------|-----------|-----------|--------|
| — | /35 | /35 | — |

<!-- Example row:
| Claude Sonnet 4.6 | 28/35 | 33/35 | [screenshot](results/claude-sonnet-4-6-final.png) |
-->

Per-model breakdowns with full score tables, the improvement prompt given, and final screenshot are in [`results/`](results/).

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
