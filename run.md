# Vibma Benchmark — Orchestrator Instructions

You are running the Vibma Benchmark pipeline. Your job is to run each model through a challenge, review the results, provide feedback, and record everything.

## Prerequisites

- Figma file open with an existing design system (color variables + text styles)
- Vibma V0.3.1 tunnel + plugin connected
- Cursor agent CLI installed (`cursor-agent`)

## Pipeline

For each **(model, challenge)** combination:

### 1. Run the Model

```bash
cursor-agent -p \
  --model <model-name> \
  --output-format stream-json \
  "$(cat challenges/<challenge>.md)" \
  > results/<model>-<challenge>-log.ndjson
```

This captures the full conversation — every tool call, decision, and response.

### 2. Review First Pass

Open Claude Code (or Cursor with Opus 4.6) and provide:
- The conversation log: `results/<model>-<challenge>-log.ndjson`
- The review rubric: `review.md`
- Vibma access to the same Figma file

Opus inspects the Figma output, reads the conversation log to understand how the model worked, and writes the first pass report with scores and commentary.

### 3. Feed Improvement Feedback

Take the improvement feedback from Opus's report and give it to the model:

```bash
cursor-agent -p \
  --model <model-name> \
  --output-format stream-json \
  --resume <session-id> \
  "<improvement feedback from Opus>" \
  > results/<model>-<challenge>-fix-log.ndjson
```

### 4. Review Second Pass

Give Opus the fix log and have it re-inspect the Figma file. Opus writes the second pass report focused on how well the model addressed feedback.

### 5. Record Cost

Check Cursor billing after each run. Record the cost for the model's first pass and fix pass combined. This goes in the **Cost** column of the results table.

### 6. Save Results

Each run produces:
- `results/<model>-<challenge>-log.ndjson` — first pass conversation
- `results/<model>-<challenge>-fix-log.ndjson` — fix pass conversation
- `results/<model>-<challenge>-final.png` — final screenshot
- `results/<model>-<challenge>.md` — full report (scores + commentary + cost)

### 7. Update Results Table

Add a row to the results table in `README.md`.

## Challenge Types

Challenges live in `challenges/` and come in two flavors:

### Structured
Step-by-step instructions with specific requirements. Tests whether the model can follow detailed design specs and use tools correctly.

Example: `challenges/design-system-structured.md`

### Vague
One or two sentences. No steps, no specs. Tests whether the model can interpret intent, make reasonable design decisions, discover the existing design system, and produce something useful without hand-holding.

Example: `challenges/personal-blog-vague.md` — "Build a design system for my personal blog. Support light and dark mode."

The same review rubric applies to both types. For vague challenges, the **Accuracy** criterion evaluates whether the model's interpretation was reasonable rather than whether it matched a spec.

## Notes

- Clean up the Figma file between runs — delete the Benchmark page so each model starts fresh
- Use the same Figma file (same design system) across all models for a fair comparison
- The conversation logs are the key differentiator — two models might produce similar output but get there very differently
