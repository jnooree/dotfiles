#!/usr/bin/env bash

set -euo pipefail

# Replaces Claude Code's worktree creation. `name` is `[<base>..]<branch>`.
# https://code.claude.com/docs/en/hooks#worktreecreate

mapfile -d '' -t F < <(jq --raw-output0 '.name, .cwd')
name="${F[0]}" cwd="${F[1]}"

base_opt=() branch=$name
if [[ $name == *..* ]]; then
	base_opt=(--base "${name%%..*}") branch=${name#*..}
fi
if [[ $branch != */* ]]; then
	branch=wt/$branch
fi

exec git -C "$cwd" wt "${base_opt[@]}" -- "$branch"
