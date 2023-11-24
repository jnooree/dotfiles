#!/bin/bash -eu
# shellcheck disable=SC1090,SC1091

set -o pipefail

_os_arch="$(uname -sm)"

function _auto_install_brew() {
	local brew_prefix

	if command -v brew &>/dev/null; then
		brew_prefix="$(brew --prefix)"
	else
		if [[ $_os_arch = *Linux* ]]; then
			brew_prefix=/home/linuxbrew/.linuxbrew
		elif [[ $_os_arch = *x86_64* ]]; then
			brew_prefix=/usr/local
		else
			brew_prefix=/opt/homebrew
		fi

		if ! [[ -x $brew_prefix/bin/brew ]]; then
			NONINTERACTIVE=1 bash -c "$(
				curl -fsSL \
					https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
			)"
		fi
	fi

	set +eu
	eval "$("$brew_prefix/bin/brew" shellenv)" || exit 1
	set -eu
}

function _auto_install_conda() {
	local conda_prefix="$1" os_conda arch script_dest

	if [[ -d $conda_prefix ]]; then
		return 0
	fi

	case "$_os_arch" in
	*Linux*) os_conda="Linux" ;;
	*Darwin*) os_conda="MacOSX" ;;
	*)
		echo "error: Invalid operating system '${os_conda}'" >&2
		exit 1
		;;
	esac

	arch="$(uname -m)"
	if ! [[ "$arch" = *arm64* || "$arch" = *aarch64* || "$arch" = *x86_64* ]]; then
		echo "error: Invalid architecture '${arch}'" >&2
		exit 1
	fi

	script_dest="$(mktemp -d)/conda-install.sh"

	curl -fsSL "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-${os_conda}-${arch}.sh" -o "$script_dest"
	bash "$script_dest" -bup "$conda_prefix"
	rm -rf "$(dirname "$script_dest")"
}

# Install package managers
if [[ -z ${SKIP_HOMEBREW-} ]]; then
	_auto_install_brew

	brew install coreutils fd ripgrep fzf zsh icu4c
	export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
fi

if [[ -z ${SKIP_CONDA-} ]]; then
	_auto_install_conda ~/anaconda3
fi

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
		cp -fT "$source" "$dest"
	else
		ln -sfT "$(realpath --relative-to "$dest_dir" "$source")" "$dest"
	fi
}

shopt -s dotglob

for _fd in * bin/* .config/* .config/gh/*; do
	case "$_fd" in
	.git | .github | .gitignore | .gitmessage | .config | .zfunc \
		bin | Library | LICENSE | README.md | bootstrap.sh)
		continue
		;;
	.config/htop | .config/gh | .config/karabiner)
		continue
		;;
	esac

	to_home "$_fd"
done

for _fd in .config/htop/*; do
	to_home "$_fd" copy
done

if [[ $_os_arch = *Darwin* ]]; then
	for _fd in .config/karabiner/*; do
		to_home "$_fd"
	done

	while IFS= read -r -d '' _fd; do
		to_home "$_fd"
	done < <(find Library -type f -print0)

	for _fd in Library/LaunchAgents/*; do
		launchctl bootstrap "gui/$UID" "$HOME/$_fd"
	done
fi

unset _fd

shopt -u dotglob

# Create directories
mkdir -p ~/opt ~/.config/zsh ~/.vim/{backup,swap,undo}

if [[ -z ${CODESPACES-} ]]; then
	# Link git autocompletion
	if [[ -n ${HOMEBREW_PREFIX-} ]]; then
		_zsh_git="$HOMEBREW_PREFIX/share/zsh/functions/_git"
	elif [[ $_os_arch = *Linux* ]]; then
		_zsh_git=/usr/share/zsh/functions/Completion/Unix/_git
	else
		_zsh_git="/usr/share/zsh/$(/bin/zsh -c 'echo $ZSH_VERSION')/functions/_git"
	fi
	ln -sfT "$_zsh_git" .zfunc/completion/_git

	if [[ $_os_arch = *Linux* ]]; then
		# cron
		crontab ~/.config/cron/mytab
	fi
else
	# Codespaces automatically sets up GPG signing
	set +e
	git config --global --unset-all user.signingkey
	set -e
fi

# Local gitignore repo
if [[ ! -d ~/opt/gitignore ]]; then
	git clone https://github.com/github/gitignore ~/opt/gitignore
else
	git -C ~/opt/gitignore pull
fi

# Zim
curl -fsSL --create-dirs -o ~/.zim/zimfw.zsh \
	https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
zsh ~/.zim/zimfw.zsh init -q

# iTerm2
if [[ ! -r ~/.iterm2_shell_integration.zsh ]]; then
	curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh |
		SHELL=zsh bash
fi
