# Vibma Benchmark

Standardized evaluation of AI models performing design tasks in Figma through [Vibma](https://github.com/nicepkg/vibma) MCP (V0.3.1).

## How It Works

Models under test run in **[Cursor agent CLI](https://cursor.com/docs/cli/using)** with `--output-format stream-json`, which captures the full conversation into an NDJSON log. The orchestrator and reviewer is **Opus 4.6 in Claude Code** ([`run.md`](run.md)), which manages the pipeline, inspects Figma output via Vibma, and writes reports.

Each model runs three rounds. First, a [structured challenge](challenges/design-system-structured.md) with detailed specs — tests instruction following and reading from the existing design system. Opus reviews and gives feedback, then the model fixes — tests how well it responds to design review. Finally, a [vague prompt](challenges/personal-blog-vague.md) with no steps or specs — tests whether the model can interpret intent and make good design decisions on its own.

```
Opus (Claude Code) picks model
        ↓
Model runs structured challenge in Cursor → Detailed score (/30)
        ↓
Model self-reviews and fixes in Cursor (no hints) → Fix score (/30)
        ↓
Model runs vague challenge in Cursor → Vague score (/30)
        ↓
Screenshot + full report saved to results/
```

## Results

| Model | Detailed | Fix | Vague | Total | Cost | Visual |
|-------|---------|-----|-------|-------|------|--------|
| — | /30 | /30 | /30 | /90 | — | — |

<!-- Example row:
| Claude Sonnet 4.6 | 24/30 | 27/30 | 22/30 | 73/90 | $0.42 | [screenshot](results/claude-sonnet-4-6-final.png) |
-->

Full reports with score tables, commentary, and screenshots are in [`results/`](results/).

## Scoring

Three rounds, each scored on 6 criteria at 1–5 (max 30 per round, 90 total). Reports include commentary — what specifically went well and what went wrong.

**Detailed** — instruction following + reading from the design system

| Criterion | What's Evaluated |
|-----------|-----------------|
| Tool Usage | Read before write, efficient tool calls |
| Design Tokens | Styles/variables used vs hardcoded values |
| Layout Quality | Auto-layout, spacing, alignment |
| Naming | Semantic names on all layers |
| Accuracy | All required elements present and correct |
| Lint Compliance | Ran lint, fixed issues |

**Fix** — how well the model addresses review feedback

| Criterion | What's Evaluated |
|-----------|-----------------|
| Issue Coverage | All flagged issues addressed? |
| Fix Quality | Correct fixes, no regressions? |
| Token Remediation | Hardcoded values replaced with variables/styles? |
| Layout Fixes | Auto-layout and spacing issues resolved? |
| Naming Fixes | Default names replaced with semantic ones? |
| Lint Resolution | Previously failing checks now pass? |

**Vague** — interpreting intent with no detailed spec

| Criterion | What's Evaluated |
|-----------|-----------------|
| Interpretation | Reasonable reading of the vague prompt? |
| Design Tokens | Discovered and used existing design system? |
| Layout Quality | Auto-layout, spacing, alignment |
| Naming | Semantic names on all layers |
| Completeness | Produced something substantial and usable? |
| Visual Quality | Professional appearance, hierarchy |

## License

MIT
