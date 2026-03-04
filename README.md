# Vibma Benchmark

Standardized evaluation of AI models performing design tasks in Figma through [Vibma](https://github.com/nicepkg/vibma) MCP (V0.3.1).

## How It Works

Models are run via [Cursor agent CLI](https://cursor.com/docs/cli/using) with `--output-format stream-json`, which captures the full conversation — every tool call, response, and decision — into an NDJSON log. The orchestrator ([`run.md`](run.md)) manages the pipeline end-to-end.

Each model gets a challenge from [`challenges/`](challenges/) — either a detailed spec or a vague one-liner. Opus 4.6 reviews both the Figma output and the conversation log using [`review.md`](review.md), writes a report with scores and commentary on what the model did well and what it got wrong, then gives specific improvement feedback. The model applies fixes, and Opus reviews again.

```
Orchestrator picks model + challenge
        ↓
cursor-agent runs model (conversation → NDJSON log)
        ↓
Opus reviews Figma output + conversation log
        ↓
Report: scores + what went well + what went wrong (first pass, /35)
        ↓
Model receives improvement feedback → applies fixes
        ↓
Report: fix quality + what improved + what's still wrong (second pass, /35)
        ↓
Screenshot + full report saved to results/
```

## Challenges

| Challenge | Type | Prompt |
|-----------|------|--------|
| [design-system-structured](challenges/design-system-structured.md) | Structured | Build a design system page + settings card with specific requirements |
| [personal-blog-vague](challenges/personal-blog-vague.md) | Vague | "Build a design system for my personal blog. Support light and dark mode." |

**Structured** challenges test whether a model can follow detailed design specs. **Vague** challenges test whether it can interpret intent and make good design decisions on its own.

## Results

| Model | Challenge | First Pass | After Fix | Cost | Visual |
|-------|-----------|-----------|-----------|------|--------|
| — | — | /35 | /35 | — | — |

<!-- Example row:
| Claude Sonnet 4.6 | design-system-structured | 28/35 | 33/35 | $0.42 | [screenshot](results/claude-sonnet-4-6-design-system-structured-final.png) |
-->

Full reports with score tables, commentary, and screenshots are in [`results/`](results/).

## Scoring

Each pass scores 7 criteria on a 1–5 scale (max 35). Reports include commentary — not just scores, but what specifically went well and what went wrong.

**First pass** — did the model follow design practices?

| Criterion | What's Evaluated |
|-----------|-----------------|
| Tool Usage | Read before write, efficient tool calls |
| Design Tokens | Styles/variables used vs hardcoded values |
| Layout Quality | Auto-layout, spacing, alignment |
| Naming | Semantic names on all layers |
| Accuracy | All requirements met (structured) or reasonable interpretation (vague) |
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
