#!/usr/bin/env bash

set -euo pipefail

# Claude Code saves settings by rename, replacing the symlinks link.sh made.
# Move such edits back into the repo and restore the symlinks.
# https://code.claude.com/docs/en/hooks#sessionstart

files=(settings.json CLAUDE.md)

home_dir="$HOME/.claude"

function is_regular() {
	[[ -f $1 && ! -L $1 ]]
}

function git_op_in_progress() {
	local marker
	for marker in MERGE_HEAD rebase-merge rebase-apply CHERRY_PICK_HEAD REVERT_HEAD; do
		if [[ -e $git_dir/$marker ]]; then
			return 0
		fi
	done
	return 1
}

pending=()
for f in "${files[@]}"; do
	if is_regular "$home_dir/$f"; then
		pending+=("$f")
	fi
done
if ((${#pending[@]} == 0)); then
	exit 0
fi

repo_dir="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="${repo_dir%/*}"
git_dir="$(git -C "$repo_dir" rev-parse --absolute-git-dir)"

home_real="$(cd -P "$HOME" && pwd)"
if [[ $repo_dir = "$home_real"/* ]]; then
	link_dir="../${repo_dir#"$home_real"/}"
else
	link_dir="$repo_dir"
fi

lock="$git_dir/index.lock"
if ! (set -o noclobber && : >"$lock") 2>/dev/null; then
	exit 0
fi
trap 'rm -f "$lock"' EXIT

updated=()
skipped=()
for f in "${pending[@]}"; do
	home_file="$home_dir/$f"
	repo_file="$repo_dir/$f"

	if ! is_regular "$home_file"; then
		continue
	fi

	if ! cmp -s "$home_file" "$repo_file"; then
		if git_op_in_progress ||
			! GIT_OPTIONAL_LOCKS=0 git -C "$repo_dir" diff --quiet HEAD -- "$repo_file"; then
			skipped+=("$f")
			continue
		fi
		cp "$home_file" "$repo_file.heal.$$"
		mv -f "$repo_file.heal.$$" "$repo_file"
		updated+=("$f")
	fi

	ln -s "$link_dir/$f" "$home_file.heal.$$"
	mv -f "$home_file.heal.$$" "$home_file"
done

msgs=()
if ((${#updated[@]} > 0)); then
	msgs+=("settings-heal: moved edits to ${updated[*]} into $repo_dir and relinked; review and commit.")
fi
if ((${#skipped[@]} > 0)); then
	msgs+=("settings-heal: left ${skipped[*]} unlinked; the repo copy has uncommitted changes or a git operation is in progress.")
fi
if ((${#msgs[@]} > 0)); then
	jq -n --arg msg "${msgs[*]}" '{systemMessage: $msg}'
fi
