# Vibma Benchmark — Orchestrator Instructions

You are the orchestrator running in **Claude Code** (Opus 4.6). Your job is to run each model through three rounds via **Cursor agent CLI**, review the results, and record everything.

The models under test run in **Cursor**. You (the reviewer) run in **Claude Code** with Vibma access to inspect their work.

## Prerequisites

- Figma file open with an existing design system (color variables + text styles)
- Vibma V0.3.1 tunnel + plugin connected
- Cursor agent CLI installed (`cursor-agent`)
- Claude Code session with Vibma MCP configured (for review steps)

## Pipeline

For each model:

### Round 1 — Detailed (Cursor)

Run the model with the structured challenge:

```bash
cursor-agent -p \
  --model <model-name> \
  --output-format stream-json \
  "$(cat challenges/design-system-structured.md)" \
  > results/<model>-detailed-log.ndjson
```

### Round 2 — Fix (Cursor)

Without giving the model any specific feedback, tell it to review and fix its own work:

```bash
cursor-agent -p \
  --model <model-name> \
  --output-format stream-json \
  --resume <session-id> \
  "Review what you just built. Lint all sections, check that you're using design tokens instead of hardcoded values, verify all layers have semantic names, and fix any issues you find." \
  > results/<model>-fix-log.ndjson
```

The model gets no hints about what's wrong — it has to find and fix issues on its own.

### Round 3 — Vague (Cursor)

Clean the Figma file (delete the Benchmark page), then run the vague challenge:

```bash
cursor-agent -p \
  --model <model-name> \
  --output-format stream-json \
  "$(cat challenges/personal-blog-vague.md)" \
  > results/<model>-vague-log.ndjson
```

### Review All Rounds (Claude Code)

You (Opus in Claude Code) review all three rounds:
- Read each conversation log
- Use Vibma to inspect the Figma output directly
- Follow the rubric in `review.md`
- Write the full report with scores and commentary for each round

### Record Cost

Check Cursor billing after all rounds. Record the total cost across all three rounds.

### Save Results

Each model produces:
- `results/<model>-detailed-log.ndjson` — detailed round conversation
- `results/<model>-fix-log.ndjson` — fix round conversation
- `results/<model>-vague-log.ndjson` — vague round conversation
- `results/<model>-final.png` — final screenshot
- `results/<model>.md` — full report (scores + commentary + cost)

### Update Results Table

Add a row to the results table in `README.md`.

## Notes

- Clean up the Figma file between the fix and vague rounds — delete the Benchmark page so the vague round starts fresh
- Use the same Figma file (same design system) across all models for a fair comparison
- The conversation logs are the key differentiator — two models might produce similar output but get there very differently
- The fix round is intentionally blind — the model must self-review, not follow specific instructions
