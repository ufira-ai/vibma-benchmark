# Vibma Benchmark

Standardized evaluation of AI models performing design tasks in Figma through [Vibma](https://github.com/nicepkg/vibma) MCP.

Models are given a multi-step design challenge (`instructions.md`), then reviewed and scored by Opus 4.6 (`review.md`). After receiving improvement feedback, models get a second attempt. Both scores are recorded.

## Results

| Model | First Pass | After Fix | Visual |
|-------|-----------|-----------|--------|
| — | /35 | /35 | — |

<!-- Example row:
| Claude Sonnet 4.6 | 28/35 | 33/35 | [screenshot](results/claude-sonnet-4-6-final.png) |
-->

## How to Run

### Prerequisites
- A Figma file with an existing design system (color variables + text styles)
- [Vibma](https://github.com/nicepkg/vibma) tunnel + plugin running and connected

### Benchmark a Model

1. Open a Figma file that has color variables and text styles defined
2. Start Vibma tunnel and connect the plugin
3. Give the model the contents of `instructions.md` as its task
4. Let it complete both phases without interruption
5. When done, give Opus 4.6 the contents of `review.md` along with:
   - The exported PNG from the model
   - Access to inspect the Figma file via Vibma
6. Opus scores the work and provides improvement feedback
7. Give the model the improvement feedback, let it apply fixes
8. Opus scores again (second pass rubric — focused on fix quality)
9. Save the final exported PNG to `results/[model-name]-final.png`
10. Save results to `results/[model-name].md`

### Scoring

Each criterion is scored 1–5 (max total: 35).

**First pass** — how well the model follows design practices:

| Criterion | What's Evaluated |
|-----------|-----------------|
| Tool Usage | Read before write, efficient tool calls |
| Design Tokens | Styles/variables used vs hardcoded values |
| Layout Quality | Auto-layout, spacing, alignment |
| Naming | Semantic names on all layers |
| Accuracy | All required elements present |
| Lint Compliance | Ran lint, fixed issues |
| Visual Quality | Professional appearance, hierarchy |

**Second pass** — how well the model fixes issues from feedback:

| Criterion | What's Evaluated |
|-----------|-----------------|
| Issue Coverage | Did it address all flagged issues? |
| Fix Quality | Were fixes correct, or did they introduce new problems? |
| Token Remediation | Hardcoded values replaced with proper variables/styles? |
| Layout Fixes | Auto-layout and spacing issues resolved? |
| Naming Fixes | Default names replaced with semantic ones? |
| Lint Resolution | Previously failing lint checks now pass? |
| Visual Improvement | Visible improvement in the final screenshot? |

### Results per Model

Full per-model breakdowns are in `results/[model-name].md`. Each includes both score tables, the improvement prompt given, and a final screenshot at `results/[model-name]-final.png`.

## License

MIT
