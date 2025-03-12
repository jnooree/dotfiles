#!/bin/bash -eu
# shellcheck disable=SC1090,SC1091

set -o pipefail

_os_arch="$(uname -sm)"

script_dir="$(dirname "$(realpath "$0")")"
cd "$script_dir"

function to_home() {
	local source="$script_dir/$1" dest="$HOME/$1" dest_dir

	case "$dest" in
	*.mac)
		if [[ $_os_arch = *Darwin* ]]; then
			dest="${dest%.mac}"
		else
			return 0
		fi
		;;
	*.lnx)
		if [[ $_os_arch = *Linux* ]]; then
			dest="${dest%.lnx}"
		else
			return 0
		fi
		;;
	esac

	dest_dir="$(dirname "$dest")"
	mkdir -p "$dest_dir"

	if [[ "${2-}" = copy ]]; then
		cp -rfT "$source" "$dest"
	else
		ln -sfT "$(realpath --relative-to "$dest_dir" "$source")" "$dest"
	fi
}

function is_tracked() {
	git ls-files --exclude-standard --error-unmatch "$1" &>/dev/null
}

shopt -s dotglob

for _fd in * bin/* .config/* .config/gh/*; do
	if ! is_tracked "$_fd"; then
		continue
	fi

	case "$_fd" in
	.github | .gitignore | .gitmessage | .config | .zfunc | \
		bin | Library | LICENSE | README.md | *.sh | *.json)
		continue
		;;
	.config/htop | .config/gh | .config/cron*)
		continue
		;;
	esac

	to_home "$_fd"
done

for _fd in .config/htop/* .config/cron*; do
	if is_tracked "$_fd"; then
		to_home "$_fd" copy
	fi
done

if [[ $_os_arch = *Darwin* ]]; then
	while IFS= read -r -d '' _fd; do
		if is_tracked "$_fd"; then
			to_home "$_fd"
		fi
	done < <(find Library -type f -print0)

	for _fd in Library/LaunchAgents/*; do
		if is_tracked "$_fd"; then
			launchctl bootstrap "gui/$UID" "$HOME/$_fd"
		fi
	done
fi
