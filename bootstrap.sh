#!/bin/bash -eu
# shellcheck disable=SC1090,SC1091

set -o pipefail

_os_arch="$(uname -sm)"

function _auto_install_brew() {
	local brew_prefix

	if command -v brew &>/dev/null; then
		brew_prefix="$(brew --prefix)"
	else
		NONINTERACTIVE=1 bash -c "$(
			curl -fsSL \
				https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
		)"

		if [[ $_os_arch = *Linux* ]]; then
			brew_prefix=/home/linuxbrew/.linuxbrew
		elif [[ $_os_arch = *x86_64* ]]; then
			brew_prefix=/usr/local
		else
			brew_prefix=/opt/homebrew
		fi
	fi

	set +eu
	eval "$("$brew_prefix/bin/brew" shellenv)" || exit 1
	set -eu
}

function _auto_install_conda() {
	local os_conda arch conda_prefix script_dest

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

	conda_prefix="$1"
	script_dest="$(mktemp -d)/conda-install.sh"

	curl -fsSL "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-${os_conda}-${arch}.sh" -o "$script_dest"
	bash "$script_dest" -bup "$conda_prefix"
	rm -rf "$(dirname "$script_dest")"
}

# Install package managers
_auto_install_brew
if [[ ! -d ~/anaconda3 ]]; then
	_auto_install_conda ~/anaconda3
fi

brew install coreutils fd ripgrep fzf
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

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
	.git | .gitignore | .config | bin | Library | LICENSE | README.md | bootstrap.sh)
		continue
		;;
	.config/htop | .config/gh)
		continue
		;;
	esac

	to_home "$_fd"
done

for _fd in .config/htop/*; do
	to_home "$_fd" copy
done

if [[ $_os_arch = *Darwin* ]]; then
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

# Link zsh configs
for _file in .zshenv .zshrc .zimrc; do
	ln -sfT "../../$_file" "$HOME/.config/zsh/$_file"
done

if [[ -z ${CODESPACES-} ]]; then
	# Homebrew
	brew bundle install --global --no-lock
	"$HOMEBREW_PREFIX/opt/fzf/install"
	ln -sfT "$HOMEBREW_PREFIX/share/zsh/functions/_git" ~/.zfunc/completion/_git

	# Conda
	set +eu
	. ~/anaconda3/bin/activate base || exit 1
	set -eu

	mamba update -yn base mamba
	mamba update -yn base --all
	if ! mamba env list | grep -q default &>/dev/null; then
		mamba create -yn default -c conda-forge \
			python numpy scipy scikit-learn \
			matplotlib seaborn pandas jupyter joblib tqdm \
			rdkit openbabel autopep8
	fi

	# cron
	if [[ $_os_arch = *Linux* ]]; then
		crontab ~/.config/cron/mytab
	fi
else
	# Codespaces automatically sets up GPG signing
	set +e
	git config --global --unset-all user.signingkey
	git config --global --unset-all gpg.format
	git config --global --unset-all gpg.ssh.allowedSignersFile
	set -e
fi

# Local gitignore repo
git clone https://github.com/github/gitignore ~/opt/gitignore

# Zim
curl -fsSL --create-dirs -o ~/.zim/zimfw.zsh \
	https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh

# iTerm2
if [[ ! -r ~/.iterm2_shell_integration.zsh ]]; then
	curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
fi
