#!/bin/bash
# Parse a cursor-agent stream-json NDJSON log into a readable summary.
# Usage: ./scripts/parse-log.sh results/<model>-detailed-log.ndjson

set -euo pipefail

LOG="${1:?Usage: parse-log.sh <ndjson-file>}"

if [ ! -f "$LOG" ]; then
  echo "File not found: $LOG" >&2
  exit 1
fi

echo "=== Session Info ==="
jq -r 'select(.type=="system" and .subtype=="init") | "Model: \(.model)\nCWD: \(.cwd)\nMode: \(.permissionMode)"' "$LOG" 2>/dev/null || echo "(no init event)"

echo ""
echo "=== Assistant Messages ==="
jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="text") | .text' "$LOG" 2>/dev/null | head -100

echo ""
echo "=== Tool Calls ==="
jq -r 'select(.type=="tool_call" and .subtype=="started") |
  if .tool_call.mcpToolCall then
    "MCP: \(.tool_call.mcpToolCall.args.providerIdentifier // .tool_call.mcpToolCall.serverName // "?")/\(.tool_call.mcpToolCall.args.toolName // .tool_call.mcpToolCall.toolName // "?")"
  elif .tool_call.shellToolCall then
    "Shell: \(.tool_call.shellToolCall.command // .tool_call.shellToolCall.args.command // "(pending)")"
  elif .tool_call.readToolCall then
    "Read: \(.tool_call.readToolCall.path // .tool_call.readToolCall.args.path // "(pending)")"
  elif .tool_call.writeToolCall then
    "Write: \(.tool_call.writeToolCall.path // .tool_call.writeToolCall.args.path // "(pending)")"
  elif .tool_call.updateTodosToolCall then
    "Todo: update"
  elif .tool_call.taskToolCall then
    "Task: \(.tool_call.taskToolCall.args.description // "agent")"
  else
    "Other: \(.call_id)"
  end' "$LOG" 2>/dev/null

echo ""
echo "=== Rejected Tool Calls ==="
jq -r 'select(.type=="tool_call" and .subtype=="completed") |
  .tool_call |
  to_entries[] |
  select(.value.result.rejected != null) |
  "REJECTED: \(.value.result.rejected.command // .value.result.rejected.reason // "unknown")"' "$LOG" 2>/dev/null || echo "(none)"

echo ""
echo "=== Errors ==="
jq -r 'select(.type=="tool_call" and .subtype=="completed") |
  .tool_call |
  to_entries[] |
  select(.value.result.error != null or .value.args.result.error != null) |
  "ERROR [\(if .value.args.toolName then .value.args.toolName else .key end)]: \(.value.result.error // .value.args.result.error | tostring)"' "$LOG" 2>/dev/null | head -20
if [ "$(jq -r 'select(.type=="tool_call" and .subtype=="completed") | .tool_call | to_entries[] | select(.value.result.error != null or .value.args.result.error != null) | "x"' "$LOG" 2>/dev/null | wc -l)" -eq 0 ]; then
  echo "(none)"
fi

echo ""
echo "=== MCP Tool Warnings ==="
jq -r 'select(.type=="tool_call" and .subtype=="completed") |
  .tool_call.mcpToolCall |
  .result.success.content[] |
  select(.text) |
  .text |
  if type == "string" then fromjson? // {} else . end |
  if type == "object" and .text then (.text | fromjson? // {}) else . end |
  select(.warnings) |
  .warnings[]' "$LOG" 2>/dev/null | sort | uniq -c | sort -rn | head -20
MCP_WARN_COUNT=$(jq -r 'select(.type=="tool_call" and .subtype=="completed") |
  .tool_call.mcpToolCall.result.success.content[] |
  select(.text) | .text |
  if type == "string" then fromjson? // {} else . end |
  if type == "object" and .text then (.text | fromjson? // {}) else . end |
  select(.warnings) | .warnings | length' "$LOG" 2>/dev/null | paste -sd+ - | bc 2>/dev/null || echo 0)
echo "Total warnings: $MCP_WARN_COUNT"

echo ""
echo "=== Lint Findings ==="
jq -r 'select(.type=="tool_call" and .subtype=="completed") |
  .tool_call.mcpToolCall |
  select(.args.toolName == "lint_node" or .toolName == "lint_node") |
  .result.success.content[0].text |
  if type == "string" then fromjson else . end |
  if type == "object" and .text then .text | fromjson else . end |
  .categories[]? |
  "\(.rule): \(.count) findings"' "$LOG" 2>/dev/null | sort | uniq -c | sort -rn | head -30
LINT_COUNT=$(jq -r 'select(.type=="tool_call" and .subtype=="completed") |
  .tool_call.mcpToolCall |
  select(.args.toolName == "lint_node" or .toolName == "lint_node") |
  .result.success.content[0].text |
  if type == "string" then fromjson else . end |
  if type == "object" and .text then .text | fromjson else . end |
  .categories[]? | .count' "$LOG" 2>/dev/null | paste -sd+ - | bc 2>/dev/null || echo 0)
echo "Total lint findings received: $LINT_COUNT"

echo ""
echo "=== Result ==="
jq -r 'select(.type=="result") | "Status: \(.subtype)\nDuration: \((.duration_ms // 0) / 1000 | floor)s (\((.duration_ms // 0) / 60000 * 10 | floor / 10)min)"' "$LOG" 2>/dev/null || echo "(no result — run may have been interrupted)"

echo ""
echo "=== Stats ==="
TOTAL_EVENTS=$(wc -l < "$LOG" | tr -d ' ')
TOOL_CALLS=$(grep -c '"subtype":"started"' "$LOG" 2>/dev/null || echo 0)
MCP_STARTED=$(jq -r 'select(.type=="tool_call" and .subtype=="started" and .tool_call.mcpToolCall) | "x"' "$LOG" 2>/dev/null | wc -l | tr -d ' ')
echo "Total events: $TOTAL_EVENTS"
echo "Tool calls: $TOOL_CALLS"
echo "MCP calls: $MCP_STARTED"
