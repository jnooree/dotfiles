#!/usr/bin/env bash

set -euo pipefail

# Name the tmux session after the task. Fires on every prompt until the agent
# renames the session away from tmux's numeric default.
# https://code.claude.com/docs/en/hooks#userpromptsubmit

if [[ -z ${TMUX:-} ]]; then
	exit 0
fi

name=$(tmux display-message -p '#S')
if [[ ! $name =~ ^[0-9]+$ ]]; then
	exit 0
fi

id=$(tmux display-message -p '#{session_id}')
others=$(tmux list-sessions -f "#{!=:#{session_name},$name}" -F '* `#S`')

if [[ -n $others ]]; then
	collision_hint="

It must distinguish this task from the other sessions on this server:

$others

If the natural slug collides, choose a more specific one, never a numeric suffix."
fi

cat <<EOF
This tmux session still has its default name "$name". Before you reply to this prompt, once you know what the task is, name the session after it:

    tmux rename-session -t '$id' '<slug>'

The slug is lowercase kebab-case, 2 to 4 words, ASCII letters, digits, and hyphens only. Do not mention the rename in your reply.${collision_hint-}

If you end this turn asking for clarification because the task is unclear, skip the rename; you will be reminded on the next prompt.
EOF
