# Vibma Benchmark — Orchestrator Instructions

You are the orchestrator running in **Claude Code** (Opus 4.6). Your job is to run each model through three rounds, review the results, and record everything.

Models under test run via **Cursor agent CLI** or **Claude CLI** (for Anthropic models). You (the reviewer) run in **Claude Code** with Vibma access to inspect their work.

## Prerequisites

- Figma file open (blank — no existing styles or variables)
- Vibma V0.3.1 tunnel + plugin connected
- Cursor agent CLI (`cursor-agent`) and/or Claude CLI (`claude`) installed
- Claude Code session with Vibma MCP configured (for review steps)
- Vibma MCP server enabled in Cursor: `cursor-agent mcp enable vibma`

## CLI Reference

**Cursor agent CLI:**
```bash
cursor-agent -p --trust --yolo --approve-mcps \
  --model <model-name> \
  --output-format stream-json \
  "<prompt>" \
  > results/<output>.ndjson
```

**Claude CLI** (for Anthropic models):
```bash
claude -p \
  --model <model> \
  --output-format stream-json \
  --dangerously-skip-permissions \
  "<prompt>" \
  > results/<output>.ndjson
```

## Pipeline

For each model:

### Round 1 — Detailed (model runs in Cursor/Claude CLI)

Clean the Figma file first (delete any pages from previous runs, remove all styles and variables).

```bash
# Cursor
cursor-agent -p --trust --yolo --approve-mcps \
  --model <model-name> \
  --output-format stream-json \
  "$(cat challenges/design-system-structured.md)" \
  > results/<model>/detailed-log.ndjson

# Claude
claude -p --model <model> --output-format stream-json \
  --dangerously-skip-permissions \
  "$(cat challenges/design-system-structured.md)" \
  > results/<model>/detailed-log.ndjson
```

### Round 2 — Fix (fresh session)

The model discovers and fixes its own work with no prior context — tests whether it can explore, lint, fix, and build new components.

```bash
# Cursor
cursor-agent -p --trust --yolo --approve-mcps \
  --model <model-name> \
  --output-format stream-json \
  "$(cat challenges/fix.md)" \
  > results/<model>/fix-log.ndjson

# Claude
claude -p --model <model> --output-format stream-json \
  --dangerously-skip-permissions \
  "$(cat challenges/fix.md)" \
  > results/<model>/fix-log.ndjson
```

### Round 3 — Vague (fresh session)

Clean the Figma file (delete pages, styles, variables), then run the vague challenge.

```bash
# Cursor
cursor-agent -p --trust --yolo --approve-mcps \
  --model <model-name> \
  --output-format stream-json \
  "$(cat challenges/personal-blog-vague.md)" \
  > results/<model>/vague-log.ndjson

# Claude
claude -p --model <model> --output-format stream-json \
  --dangerously-skip-permissions \
  "$(cat challenges/personal-blog-vague.md)" \
  > results/<model>/vague-log.ndjson
```

### Review All Rounds (Claude Code)

You (Opus in Claude Code) review all three rounds:
- Parse each log: `./scripts/parse-log.sh results/<model>/*-log.ndjson`
- Use Vibma to inspect the Figma output directly
- Follow the rubric in `review.md`
- Write the full report with scores and commentary for each round

### Record Cost & Time

- Time is in the NDJSON result event (`duration_ms`)
- Check Cursor/Claude billing for cost

### Save Results

Each model gets a folder `results/<model>/` containing:
- `detailed-log.ndjson` — detailed round conversation
- `fix-log.ndjson` — fix round conversation
- `vague-log.ndjson` — vague round conversation
- `detailed-parsed.txt` — parsed detailed log (via `scripts/parse-log.sh`)
- `fix-parsed.txt` — parsed fix log
- `vague-parsed.txt` — parsed vague log
- `detailed-screenshot.png` — screenshot after detailed round
- `fix-screenshot.png` — screenshot after fix round
- `report.md` — full report (scores + human observations + commentary + cost + time)

### Update Results Table

Add a row to the results table and behavior matrix in `README.md`.

## Figma Cleanup

Before each detailed or vague round, clean the Figma file completely:
- Delete all pages except one default page
- Delete all styles
- Delete all variable collections (which deletes all variables)

The model should start with a truly blank canvas every time.

## Notes

- Use the same Figma file across all models for a fair comparison
- The fix round is a fresh session — the model must discover its own work from scratch
- The vague round is a fresh session — no carry-over from previous rounds
- The conversation logs are the key differentiator — two models might produce similar output but get there very differently
