#!/usr/bin/env bash

set -euo pipefail

# Plan mode only inside tmux. Two entry paths, two events:
#   PreToolUse(EnterPlanMode)  -> model-initiated, deny via JSON
#   UserPromptSubmit           -> Shift+Tab toggle, block first prompt in plan mode
# https://code.claude.com/docs/en/hooks

if [[ -n ${TMUX:-} ]]; then
	exit 0
fi

mapfile -d '' -t F < <(
	jq --raw-output0 '
		(.hook_event_name // ""),
		(.permission_mode // "")
	'
)
event=${F[0]} mode=${F[1]}

case $event in
PreToolUse)
	jq -n '{
	  hookSpecificOutput: {
	    hookEventName: "PreToolUse",
	    permissionDecision: "deny",
	    permissionDecisionReason: "Plan mode requires tmux, but claude is not running inside tmux. Ask the user to relaunch claude in a tmux session, then retry. Do not plan inline as a workaround."
	  }
	}'
	;;
UserPromptSubmit)
	if [[ $mode != plan ]]; then
		exit 0
	fi
	echo "Plan mode requires tmux. Exit plan mode (Shift+Tab) or relaunch claude inside tmux." >&2
	exit 2
	;;
esac
