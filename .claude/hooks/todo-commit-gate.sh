#!/bin/bash

set -euo pipefail

# PreToolUse gate for TaskUpdate: block marking a task `completed` while the
# working tree is dirty. Enforces CLAUDE.md "Task tick == committed change".
#
# TaskUpdate input is a single delta {taskId, status, ...}; status == completed
# IS the tick event. A denied tick never executes, so the commit+retry cycle
# (deny -> commit -> retry on a now-clean tree) needs no transcript history.

IFS=$'\t' read -r status taskId cwd < <(
	jq -r '[
		(.tool_input.status // ""),
		(.tool_input.taskId // "" | tostring),
		(.cwd // "")
	] | @tsv'
)

# Only completions gate. in_progress / pending / subject-only / deleted pass.
if [[ $status != completed ]]; then
	exit 0
fi

if ! git -C "$cwd" rev-parse --is-inside-work-tree &>/dev/null; then
	exit 0
fi

dirty=$(git -C "$cwd" status --porcelain)
if [[ -z $dirty ]]; then
	exit 0
fi

# Dirty + completion -> deny.
jq -n --arg d "$dirty" --arg t "$taskId" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: ("Commit first, then tick task #" + $t + ". Uncommitted changes:\n" + $d)
  }
}'
