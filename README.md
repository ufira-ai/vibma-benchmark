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

| Model | Detailed | Fix | Vague | Total | Tokens (input / output) | Report |
|-------|---------|-----|-------|-------|-------------------------|--------|
| GPT-5.3 Codex (Medium) | 26/30 | 13/30 | 18/30 | 57/90 | 11.1M (9.7M cached) / 49K | [report](results/gpt-5.3-codex-medium/report.md) |
| GPT-5.3 Codex (xhigh) | 27/30 | 28/30 | — | 55/60 | 16.9M (16.4M cached) / 69K | [report](results/gpt-5.3-codex-xhigh/report.md) |

Full reports with score tables, commentary, and screenshots are in [`results/`](results/).

## Behavior Matrix

How each model handles key design practices, observed across all rounds.

**Blank context** — fresh session, model starts with minimal context

| Behavior | GPT-5.3 Codex (Medium) | GPT-5.3 Codex (xhigh) |
|----------|------------------------|------------------------|
| Variable Creation | ✅ 25 variables, Light/Dark modes | ✅ 25 variables, Light/Dark modes |
| Variable Binding | ✅ All colors bound to variables | ✅ Zero hardcoded colors |
| Text Style Creation | ✅ 12 styles with proper scale | ✅ 13 styles with proper scale |
| Text Style Application | ✅ All text nodes use styles | ✅ All text nodes use styles |
| Component Creation | ✅ 5 components, Button variant set | ✅ 5 components, Button variant set |
| Component Properties | ❌ Text not exposed despite MCP warning | ❌ Text not exposed despite MCP warning |
| Frame & Auto-layout | ✅ Correct structure, proper spacing | ✅ Correct structure, proper spacing |
| Instance Usage | ✅ Landing page uses instances | ✅ Landing page uses instances |
| Semantic Naming | ✅ Consistent naming throughout | ✅ Zero default names |
| Lint Usage | ❌ Did not run lint | ✅ Ran lint twice during build |
| MCP Warning Adherence | ❌ Ignored 5 component warnings | ❌ Ignored 6 component warnings |
| Export | ✅ PNG at 2x | ✅ PNG at 1x |

**Polluted context** — after exploration, lint passes, and accumulated tool results

| Behavior | GPT-5.3 Codex (Medium) | GPT-5.3 Codex (xhigh) |
|----------|------------------------|------------------------|
| Variable Binding | ❌ New components entirely hardcoded | ✅ All new components bound to tokens, zero hardcoded-color on dashboard |
| Frame & Auto-layout | ❌ Table header below data row, icon fix broke layout | ✅ Correct table structure, column headers above rows |
| Instance Usage | ✅ Reused Nav Bar and Button in dashboard | ✅ Reused Nav Bar and Button (Ghost variant in Table Row) |
| MCP Warning Adherence | ❌ Ignored 48 hardcoded color warnings | ⚠️ 7 warnings ignored (component properties + a few hardcoded colors) |
| Learning from Feedback | ❌ Did not apply lint lessons to new components | ✅ 39 lint passes, new components came out clean |
| Component Architecture | ❌ Icon placeholder solved with text star hack | ✅ Proper icon placeholders, Input Field as variant set |

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

**Fix** — self-review, fixing, and dashboard build

| Criterion | What's Evaluated |
|-----------|-----------------|
| Lint & Fix | Found and fixed lint issues on the landing page? |
| Visual Polish | Exported, reviewed, and improved visual quality? |
| New Components | 4 dashboard components well-built? (Stat Card, Sidebar Nav, Table Row, Input Field) |
| Dashboard Layout | Assembled dashboard functional and well-structured? Reuses existing components? |
| Learned from Lint | New components come out clean — variables bound, styles applied, semantic names — without needing a second lint pass? |
| Overall Quality | Professional result across fixed landing page and new dashboard? |

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
