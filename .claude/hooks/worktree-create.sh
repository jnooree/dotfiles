#!/usr/bin/env bash

set -euo pipefail

# Replaces Claude Code's worktree creation. `name` is `[<base>..]<branch>`.
# https://code.claude.com/docs/en/hooks#worktreecreate

mapfile -d '' -t F < <(jq --raw-output0 '.name, .cwd')
name="${F[0]}" cwd="${F[1]}"

if [[ $name == *..* ]]; then
	set -- --base "${name%%..*}" -- "${name#*..}"
else
	set -- -- "$name"
fi

exec git -C "$cwd" wt "$@"
