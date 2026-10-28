#!/usr/bin/env bash

set -euo pipefail

# Replaces Claude Code's worktree creation. `name` is `[<base>..]<branch>`.
# https://code.claude.com/docs/en/hooks#worktreecreate

input=$(cat)
name=$(jq -r .name <<<"$input")
cd "$(jq -r .cwd <<<"$input")"

base=HEAD
branch=$name
if [[ $name == *..* ]]; then
	base=${name%%..*}
	branch=${name#*..}
fi
if [[ $branch != */* ]]; then
	branch=wt/$branch
fi

top=$(git rev-parse --path-format=absolute --git-common-dir)
top=${top%/.git}
suffix=${branch#*/}
suffix=${suffix//[-\/]/_}
dir=${top}-wt-$(date +%y%m%d)-${suffix}

if ! mkdir "$dir" 2>/dev/null; then
	echo "worktree path already exists: $dir" >&2
	exit 1
fi

trap 'rmdir "$dir" 2>/dev/null' ERR
git worktree add -b "$branch" "$dir" "$base" >&2
echo "$dir"
