# Vibma Benchmark

Exploratory benchmarking of the [Vibma](https://github.com/nicepkg/vibma) MCP (V0.3.1) across different LLM models. The repo organization is messy and not worth digging into, but here are the official recommendations on model selection.

**Note:** This benchmarking is immature and subject to model performance degradation. No multi-run averaging was performed, so results are not statistically unbiased. That said, if a model fails a task with a failure probability above ~20%, I consider it unusable for that task class. Additionally, the Vibma MCP is heavily fine-tuned to Claude Opus 4.6, which may introduce bias in its favour.

## Recommendations

**For cheap, stable design system initialization from a blank session:** GPT-5.3 Codex with medium reasoning effort. It creates proper Figma components, binds all variables, and produces clean output on the first pass for under $1. Degrades on follow-up tasks, so best for one-shot builds.

**For reading existing work and building on top of it:** Choose from GPT-5.3 Codex (xhigh reasoning), Gemini 3.1 Pro, or Claude Opus 4.6. These models maintain quality as context grows — they learn from lint feedback, keep variable discipline across new components, and handle iterative design work without degrading.

**Avoid for Figma work:** Models that don't call `components()` — like Cursor Auto and Kimi K2.5 — produce frames that look right but aren't structurally usable. No instances, no variants, no library. The output is a picture of a design system, not an actual one.

## Results

| Model | Generation | Building on Top | Total | Cost | Tokens (input / output) | Screenshots | Details |
|-------|------------|-----------------|-------|------|-------------------------|-------------|---------|
| GPT-5.3 Codex (xhigh) | 27/30 | 28/30 | 55/60 | ~$1-2 | 16.9M (16.4M cached) / 69K | [detailed](results/gpt-5.3-codex-xhigh/detailed-screenshot.png) [fix](results/gpt-5.3-codex-xhigh/fix-screenshot.png) | [report](results/gpt-5.3-codex-xhigh/report.md) |
| Claude Opus 4.6 | 29/30 | 24/30 | 53/60 | — | 23.4M (cache) / 5K | [detailed](results/claude-opus-4-6/detailed-screenshot.png) [fix](results/claude-opus-4-6/fix-screenshot.png) | [report](results/claude-opus-4-6/report.md) |
| GPT-5.3 Codex (Medium) | 26/30 | 13/30 | 39/60 | ~$0.86 | 11.1M (9.7M cached) / 49K | [detailed](results/gpt-5.3-codex-medium/detailed-screenshot.png) [fix](results/gpt-5.3-codex-medium/fix-screenshot.png) | [report](results/gpt-5.3-codex-medium/report.md) |
| Kimi K2.5 | 14/30 | 12/30 | 26/60 | ~$1.41 | 17.8M (17.4M cached) / 38K | [detailed](results/kimi-k2.5/detailed-screenshot.png) | [report](results/kimi-k2.5/report.md) |
| Cursor Auto | 19/30 | — | 19/30 | — | 5.6M (5.3M cached) / 27K | [detailed](results/cursor-auto/detailed-screenshot.png) | [report](results/cursor-auto/report.md) |

Full reports with score tables, commentary, and screenshots are in [`results/`](results/).

## Behavior Matrix

What you get from each model, observed across all rounds.

**First pass** — building from a blank file

| What matters | Codex (xhigh) | Opus 4.6 | Codex (Medium) | Cursor Auto | Kimi K2.5 |
|-------------|----------------|----------|----------------|-------------|-----------|
| Creates Figma components | ✅ | ✅ | ✅ | ❌ All frames | ❌ All frames |
| Uses instances | ✅ | ✅ | ✅ | ❌ Detached clones | ❌ Detached clones |
| Binds variables | ✅ | ✅ | ✅ | ✅ | ⚠️ ~90% |
| Applies text styles | ✅ | ✅ | ✅ | ✅ | ❌ 25 unstyled |
| Auto-layout | ✅ | ✅ | ✅ | ✅ | ⚠️ Clipped |
| Runs lint | ✅ | ❌ | ❌ | ❌ | ❌ |
| Unique content | ✅ | ✅ | ✅ | ❌ Identical clones | ❌ Identical clones |

**Second pass** — building on top of existing work

| What matters | Codex (xhigh) | Opus 4.6                       | Codex (Medium) | Cursor Auto | Kimi K2.5 |
|-------------|----------------|--------------------------------|----------------|-------------|-----------|
| New work uses variables | ✅ | ❌ New colors hardcoded | ❌ New components entirely hardcoded | — | ❌ All hardcoded |
| Reuses components | ✅ | ✅                              | ✅ | — | ❌ From scratch |
| Learns from lint | ✅ | ❌ Ran lint, didn't fix        | ❌ | — | ❌ |
| Layout holds up | ✅ | ✅                              | ❌ Broke on fixes | — | ⚠️ |

<details>
<summary>Full behavior matrix (technical detail)</summary>

**Blank context** — fresh session, model starts with minimal context

| Behavior | Codex (xhigh) | Opus 4.6 | Codex (Medium) | Cursor Auto | Kimi K2.5 |
|----------|----------------|----------|----------------|-------------|-----------|
| Variable Creation | ✅ 25 variables, Light/Dark modes | ✅ 25 variables, Light/Dark modes | ✅ 25 variables, Light/Dark modes | ✅ 25 variables, Light/Dark modes | ✅ 25 variables, Light/Dark modes |
| Variable Binding | ✅ Zero hardcoded colors | ✅ Zero hardcoded colors across entire page | ✅ All colors bound to variables | ✅ Zero hardcoded on landing page (inline bindings) | ⚠️ ~90% bound via 29 calls, labels left as #000000 |
| Text Style Creation | ✅ 13 styles with proper scale | ✅ 11 styles with proper scale | ✅ 12 styles with proper scale | ✅ 11 styles (missing 2 vs spec) | ✅ 11 styles (missing 2 vs spec) |
| Text Style Application | ✅ All text nodes use styles | ✅ All text nodes use styles | ✅ All text nodes use styles | ✅ All landing page text uses styles | ❌ 25 text nodes without styles |
| Component Creation | ✅ 5 components, Button variant set | ✅ 5 components, Button + Pricing as variant sets | ✅ 5 components, Button variant set | ❌ Zero components() calls — all frames | ❌ Zero components() calls — all frames |
| Component Properties | ❌ Text not exposed despite MCP warning | ❌ Text not exposed despite MCP warning | ❌ Text not exposed despite MCP warning | ❌ No components created | ❌ No components created |
| Frame & Auto-layout | ✅ Correct structure, proper spacing | ✅ Correct structure, proper spacing | ✅ Correct structure, proper spacing | ✅ Correct structure, no clipping | ⚠️ Auto-layout present but landing page clipped (1000×100) |
| Instance Usage | ✅ Landing page uses instances | ✅ 9 instances, nested Button in Nav Bar | ✅ Landing page uses instances | ❌ Used clone_node (detached copies) not instances | ❌ Used clone_node (detached copies) not instances |
| Batch Operations | ✅ Grouped creates, inline bindings | ✅ Inline bindings + set_text_content for instances | ✅ Grouped creates, inline bindings | ✅ Inline bindings, zero separate binding calls | ❌ Individual calls, 29 separate set_variable_binding |
| Semantic Naming | ✅ Zero default names | ✅ Zero default names | ✅ Consistent naming throughout | ✅ Good naming, no defaults | ⚠️ Descriptive but text nodes named as content |
| Lint Usage | ✅ Ran lint twice during build | ❌ Did not run lint (used 3 visual exports instead) | ❌ Did not run lint | ❌ Did not run lint | ❌ Did not run lint |
| MCP Warning Adherence | ❌ Ignored 6 component warnings | ❌ Ignored 7 component property warnings | ❌ Ignored 5 component warnings | ⚠️ Very few warnings (inline bindings prevented them) | ❌ Ignored all 59 warnings |
| Export | ✅ PNG at 1x | ✅ PNG 3x during build | ✅ PNG at 2x | ✅ PNG at 1x | ✅ PNG at 2x |

**Polluted context** — after exploration, lint passes, and accumulated tool results

| Behavior | Codex (xhigh) | Opus 4.6                                                    | Codex (Medium) | Cursor Auto | Kimi K2.5 |
|----------|----------------|-------------------------------------------------------------|----------------|-------------|-----------|
| Variable Binding | ✅ All new components bound to tokens, zero hardcoded-color on dashboard | ❌ New components entirely hardcoded | ❌ New components entirely hardcoded | — | ❌ 65 hardcoded colors, zero variable bindings on dashboard |
| Frame & Auto-layout | ✅ Correct table structure, column headers above rows | ✅ Correct structure, sidebar + main content                 | ❌ Table header below data row, icon fix broke layout | — | ⚠️ Clipping fixed (followed explicit instructions), but section overlap persists |
| Instance Usage | ✅ Reused Nav Bar and Button (Ghost variant in Table Row) | ✅ Reused Nav Bar, Button, all 4 new components as instances | ✅ Reused Nav Bar and Button in dashboard | — | ❌ Zero component reuse, everything built from scratch |
| MCP Warning Adherence | ⚠️ 7 warnings ignored (component properties + a few hardcoded colors) | ❌ Ignored 48 hardcoded color warnings             | ❌ Ignored 48 hardcoded color warnings | — | ❌ Ignored all warnings, 65 new hardcoded colors |
| Learning from Feedback | ✅ 39 lint passes, new components came out clean | ⚠️ 22 lint passes but dashboard still has 63 hardcoded colors | ❌ Did not apply lint lessons to new components | — | ❌ Ran lint twice (progress), fixed nothing — dashboard worse than detailed round |
| Component Architecture | ✅ Proper icon placeholders, Input Field as variant set | ✅ SVG icons, Input Field variant set, 5 distinct table rows | ❌ Icon placeholder solved with text star hack | — | ❌ All plain frames, identical cloned content, no variant states |

</details>

## How It Works

Models under test run in **[Cursor agent CLI](https://cursor.com/docs/cli/using)** or **[Codex CLI](https://github.com/openai/codex)** with JSON output, which captures the full conversation into an NDJSON log. The orchestrator and reviewer is **Opus 4.6 in Claude Code** ([`run.md`](run.md)), which manages the pipeline, inspects Figma output via Vibma, and writes reports.

Each model runs up to three rounds. First, a [structured challenge](challenges/design-system-structured.md) with detailed specs. Then a self-review and fix round with a [dashboard build](challenges/fix.md). Finally, a [vague prompt](challenges/personal-blog-vague.md) with no specs.

## Scoring

Three rounds, each scored on 6 criteria at 1-5 (max 30 per round, 90 total). Reports include commentary — what specifically went well and what went wrong.

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
