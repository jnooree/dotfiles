#!/bin/bash

set -euo pipefail

input=$(cat)

IFS=$'\t' read -r tx cwd < <(
	jq -r '[(.transcript_path // ""), (.cwd // "")] | @tsv' <<<"$input"
)
if [[ ! -f $tx ]] ||
	! git -C "$cwd" rev-parse --is-inside-work-tree &>/dev/null; then
	exit 0
fi

dirty=$(git -C "$cwd" status --porcelain)
if [[ -z $dirty ]]; then
	exit 0
fi

curr=$(
	jq -r '
		[.tool_input.todos[]? | select(.status == "completed").content]
		| unique
		| join("\n")
	' <<<"$input" 2>/dev/null
)

if [[ -z $curr ]]; then
	exit 0
fi

prev=$(
	jq -rs '
		[ .[] | .message?.content?[]?
			| select(.type == "tool_use" and .name == "TodoWrite") | .input.todos ]
		| (last // [])
		| map(select(.status == "completed") | .content)
		| unique
		| join("\n")
	' "$tx" 2>/dev/null
)

new=$(LC_ALL=C comm -13 <(printf '%s\n' "$prev") <(printf '%s\n' "$curr"))
if [[ -z $new ]]; then
	exit 0
fi

# Dirty + new tick -> deny.
jq -n --arg d "$dirty" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: ("Commit first, then tick. Uncommitted changes:\n" + $d)
  }
}'
exit 0
