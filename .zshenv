# shellcheck disable=SC1090,SC2034,SC2155

# For convenience
setopt autonamedirs

export LANG="en_US.UTF-8"

if [[ -z $SAFEPATH ]]; then
	SAFEPATH="$PATH"
fi

_OS_ARCH="$(uname -sm)"

if command -v brew &>/dev/null; then
	_brew_prefix="$(brew --prefix)"
elif [[ $_OS_ARCH = *Linux* ]]; then
	_brew_prefix=/home/linuxbrew/.linuxbrew
elif [[ $_OS_ARCH = *x86_64* ]]; then
	_brew_prefix=/usr/local
else
	_brew_prefix=/opt/homebrew
fi

_stripped_path="\
$(sed -E "s#:*$_brew_prefix/s?bin:*#:#g;s#:+#:#g;s#^:##g;s#:\$##g" <<<"$PATH")"
unset _stripped_path

if [[ -x $_brew_prefix/bin/brew ]]; then
	eval "$("$_brew_prefix/bin/brew" shellenv)"
	# shellcheck disable=SC2123
	path=("$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" "$path[@]")
fi
unset _brew_prefix

path=("$HOME/bin" "$HOME/.local/bin" "$path[@]")

# User env variables
if [[ -n $SSH_CONNECTION ]]; then
	alias -g subl=rsub
	export RMATE_PORT="${LC_RSUB_PORT:-58023}"
fi

export PAGER="less"
export MANPAGER="less"
# Fix for colored man pages when groff is installed
if command -v groff &>/dev/null; then
	export MANROFFOPT="-c"
fi

# For custom functions
for _file in ~/.zfunc/*.zsh; do
	. "$_file"
done
unset _file

export ZDOTDIR="$HOME/.config/zsh"
export SHORT_HOST="$(hostname -s)"

if [[ $_OS_ARCH = *Darwin* ]]; then
	export ramdisk="/Volumes/RAMDisk"
	alias chimera='open -n /Applications/Chimera.app --args'
fi

# Add options for pagers; set here for ssh sessions
if [[ -t 1 ]]; then
	export LESS='-RM~gi'
	if [[ -d /run/systemd/system ]]; then
		export SYSTEMD_LESS="${LESS}s"
		export SYSTEMD_URLIFY=no
	fi
fi

if [[ -r ~/.zshenv.local ]]; then
	. ~/.zshenv.local
fi

# For more zsh completions
skip_global_compinit=1
