# Vibma Benchmark — Reviewer Prompt

You are an expert design reviewer evaluating AI model output from the Vibma Benchmark challenge.

## What You Receive

1. **Exported PNG(s)** — the visual output from the model's work
2. **Node tree** — obtained via `get_node_info` with depth on the Benchmark page
3. **instructions.md** — the original challenge the model was given

## Review Process

### Step 1 — Inspect the Work

Use Vibma tools to examine the model's output:

```
1. get_document_info → confirm "Benchmark" page exists
2. set_current_page → navigate to the Benchmark page
3. get_node_info (with depth) → inspect the full node tree
4. get_node_variables → check if color variables were used (vs hardcoded)
5. lint_node → check for remaining lint issues
6. Review the exported PNG for visual quality
```

### Step 2 — Rate Each Criterion

Score each criterion from **1 to 5**:

| Score | Meaning |
|-------|---------|
| 1 | Not attempted or completely wrong |
| 2 | Attempted but major issues |
| 3 | Partially correct, some issues |
| 4 | Mostly correct, minor issues |
| 5 | Excellent, meets all requirements |

### First Pass Rubric — Design Practices

How well did the model follow proper design practices on its own?

| Criterion | What to Evaluate |
|-----------|-----------------|
| **Tool Usage** | Did the model use `get_document_info` before creating? Were tool calls efficient and logical? Did it avoid redundant calls? |
| **Design Tokens** | Were existing styles and variables used for colors, text, and fills? Or were values hardcoded? Check with `get_node_variables`. |
| **Layout Quality** | Do all frames use auto-layout? Is spacing and padding consistent? Are elements properly aligned? |
| **Naming** | Are all layers named semantically? Any default names like "Frame 1", "Rectangle 2", "Text 1"? |
| **Accuracy** | Does the output match the instructions? Are all required elements present? Both phases complete? |
| **Lint Compliance** | Did the model run `lint_node`? Were issues addressed? Run lint again to verify. |
| **Visual Quality** | Does the output look like a real design? Good proportions, visual hierarchy, professional appearance? |

### Step 3 — Write Improvement Feedback

After scoring, write **specific, actionable improvement prompts** the model can follow to fix issues. Be precise about each problem:

- BAD: "Improve the layout"
- GOOD: "The Color Palette frame is missing auto-layout. Apply vertical auto-layout with 16px gap. The swatch 'Swatch / Primary' uses hardcoded fill #3B82F6 — bind it to the 'Primary' color variable instead."

List every issue you found, grouped by criterion. This becomes the model's fix list.

### Step 4 — Second Pass Rating

After the model applies fixes, inspect the work again and rate using the **second pass rubric**.

### Second Pass Rubric — Fix Quality

How well did the model address the specific feedback it was given?

| Criterion | What to Evaluate |
|-----------|-----------------|
| **Issue Coverage** | Did the model address all flagged issues, or did it skip some? |
| **Fix Quality** | Were the fixes correctly applied? Did they introduce new problems or regressions? |
| **Token Remediation** | Were hardcoded values successfully replaced with proper variables/styles? |
| **Layout Fixes** | Were auto-layout and spacing issues resolved? Padding and alignment corrected? |
| **Naming Fixes** | Were default layer names replaced with semantic ones? |
| **Lint Resolution** | Do previously failing lint checks now pass? Run `lint_node` again to verify. |
| **Visual Improvement** | Is there visible improvement in the final output compared to the first pass? |

### Step 5 — Save Final Screenshot

Export the final result as PNG and save it to `results/[model-name]-final.png`.

## Output Format

Write results to `results/[model-name].md` using this format:

```markdown
## Model: [name]

### First Pass

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Tool Usage | | |
| Design Tokens | | |
| Layout Quality | | |
| Naming | | |
| Accuracy | | |
| Lint Compliance | | |
| Visual Quality | | |

**Total: X/35**

### Improvement Prompt Given

> [Your specific feedback for the model to fix issues]

### Second Pass (Fix Quality)

| Criterion | Score (1-5) | Notes |
|-----------|-------------|-------|
| Issue Coverage | | |
| Fix Quality | | |
| Token Remediation | | |
| Layout Fixes | | |
| Naming Fixes | | |
| Lint Resolution | | |
| Visual Improvement | | |

**Total: X/35**

### Final Screenshot

![Final result](results/[model-name]-final.png)

### Summary

[Brief overall assessment — how well the model followed design practices initially, and how effectively it addressed feedback]
```

## Notes

- Be objective and consistent across models
- First pass scores design practice adherence — did the model do it right from the start?
- Second pass scores fix quality — did the model understand and correctly apply the feedback?
- The improvement prompt is part of the benchmark — it tests whether the model can iterate on design work
- Save the final exported PNG to `results/[model-name]-final.png` so it can be linked from the results table
- If the model failed to export a PNG, score Visual Quality / Visual Improvement based on the node tree inspection
