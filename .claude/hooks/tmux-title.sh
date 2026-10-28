#!/usr/bin/env bash

set -euo pipefail
shopt -s extglob

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

# Session names group by main worktree; the common dir lives there even from a
# linked worktree. tmux rejects "." and ":" in names.
top=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || top=$PWD/.git
top=${top%.git}
top=${top%/}
prefix=${top##*/}
prefix=${prefix,,}
prefix=${prefix//+([^a-z0-9])/-}
prefix=${prefix##+(-)}
prefix=${prefix%%+(-)}

others=$(tmux list-sessions -f "#{!=:#{session_name},$name}" -F '* `#S`')

if [[ -n $others ]]; then
	collision_hint="

It must distinguish this task from the other sessions on this server:

$others

If the natural slug collides, make it more specific instead of appending a counter."
fi

cat <<EOF
This tmux session still has its default name "$name". Before you reply to this prompt, once you know what the task is, name the session after it:

    tmux rename-session -t '$id' '$prefix-<slug>'

The slug is lowercase kebab-case, 1 to 3 words, ASCII letters, digits, and hyphens only. Digits that belong to the task itself count as part of a word, not as extra words: step 2.2 is \`step-2-2\`. Do not mention the rename in your reply.${collision_hint-}

If you end this turn asking for clarification because the task is unclear, skip the rename; you will be reminded on the next prompt.
EOF
