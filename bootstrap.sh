#!/bin/bash
# shellcheck disable=SC1090,SC1091

set -euo pipefail

if [[ $OSTYPE == darwin* ]]; then
	./init-macos.sh
fi

script_dir="$(dirname "$(realpath -s "$0")")"
cd "$script_dir"

function _auto_install_brew() {
	local brew_prefix

	if command -v brew &>/dev/null; then
		brew_prefix="$(brew --prefix)"
	else
		if [[ $OSTYPE = linux* ]]; then
			brew_prefix=/home/linuxbrew/.linuxbrew
		elif [[ $HOSTTYPE = x86_64 ]]; then
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

	case "$OSTYPE" in
	linux*) os_conda="Linux" ;;
	darwin*) os_conda="MacOSX" ;;
	*)
		echo "error: Invalid operating system '${OSTYPE}'" >&2
		exit 1
		;;
	esac

	arch="$HOSTTYPE"
	if ! [[ "$arch" = *arm64* || "$arch" = *aarch64* || "$arch" = *x86_64* ]]; then
		echo "error: Invalid architecture '${arch}'" >&2
		exit 1
	fi

	script_dest="$(mktemp -d)/conda-install.sh"

	curl -fsSL "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-${os_conda}-${arch}.sh" -o "$script_dest"
	bash "$script_dest" -bup "$conda_prefix"
	rm -rf "$(dirname "$script_dest")"
}

# Install package managers
if [[ -z ${SKIP_HOMEBREW-} ]]; then
	_auto_install_brew

	brew install coreutils fd ripgrep fzf zsh icu4c git
	export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

	mkdir -p ~/bin
	ln -st ~/bin "$HOMEBREW_PREFIX/opt/git/share/git-core/contrib/diff-highlight/diff-highlight"
fi

if [[ -z ${SKIP_CONDA-} ]]; then
	_auto_install_conda ~/anaconda3
fi

# Invoke by absolute logical path (not ./link.sh) so link.sh's own `realpath -s`
# does not re-resolve it against the physical cwd and undo the symlink handling.
"$script_dir/link.sh" || exit 1

# Create directories
mkdir -p ~/opt ~/.cache/zsh ~/.vim/{backup,swap,undo}

if [[ -z ${CODESPACES-} ]]; then
	# Link git autocompletion
	if [[ -n ${HOMEBREW_PREFIX-} ]]; then
		_zsh_git="$HOMEBREW_PREFIX/share/zsh/functions/_git"
	elif [[ $OSTYPE = linux* ]]; then
		_zsh_git=/usr/share/zsh/functions/Completion/Unix/_git
	else
		_zsh_git="/usr/share/zsh/$(/bin/zsh -c 'echo $ZSH_VERSION')/functions/_git"
	fi
	ln -sfT "$_zsh_git" .zfunc/completion/_git

	if [[ $OSTYPE = linux* ]]; then
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
export ZIM_HOME="$HOME/.zim"
curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
	https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
zsh -c 'zstyle ":zim:zmodule" use degit; source "$0" init -q' \
	"$ZIM_HOME/zimfw.zsh"
