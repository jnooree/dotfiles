#!/usr/bin/env bash

set -euo pipefail

# Codex has no rules directory; inject Claude's instead.
# https://learn.chatgpt.com/docs/hooks

claude_dir=$HOME/.claude

cat "$claude_dir/CLAUDE.md"

for rule in "$claude_dir"/rules/*.md; do
	if [[ ${rule##*/} == pstack-models.md ]]; then
		continue
	fi

	printf '\n'
	cat "$rule"
done
