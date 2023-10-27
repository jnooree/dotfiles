# shellcheck disable=SC1090,SC1091,SC2034,SC2155

# Pre-framework settings
case "$TERM" in
xterm*) unset NO_COLOR ;;
esac

# Set via .zshenv
# shellcheck disable=SC2154
if [[ $_OS_ARCH = *Linux* ]]; then
	ulimit -s 1048576
elif [[ -n ${HOMEBREW_PREFIX-} ]]; then
	_brew_opt="$HOMEBREW_PREFIX/opt"

	PATH="$_brew_opt/gnu-sed/libexec/gnubin:$_brew_opt/gnu-tar/libexec/gnubin:\
$_brew_opt/grep/libexec/gnubin:$_brew_opt/findutils/libexec/gnubin:\
$_brew_opt/coreutils/libexec/gnubin:$_brew_opt/curl/bin:$_brew_opt/ruby/bin:\
$_brew_opt/ssh-copy-id/bin:$_brew_opt/gnu-units/libexec/gnubin:\
$_brew_opt/icu4c/bin:$_brew_opt/binutils/bin:\
$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}"

	FPATH="$_brew_opt/curl/share/zsh/site-functions${FPATH+:$FPATH}"

	unset _brew_opt
fi

export PATH="$HOME/bin:$HOME/.local/bin${PATH+:$PATH}"

function _source_if_readable() {
	if [[ -r $1 ]]; then
		. "$1" || true
	fi
}

# environment managers: conda, jenv, rvm

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/anaconda3/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
		. "$HOME/anaconda3/etc/profile.d/conda.sh"
	else
		export PATH="$HOME/anaconda3/bin:$PATH"
	fi
fi
unset __conda_setup

if [ -f "$HOME/anaconda3/etc/profile.d/mamba.sh" ]; then
	. "$HOME/anaconda3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

if [[ -x ~/.jenv/bin/jenv ]]; then
	export PATH="$HOME/.jenv/bin:$PATH"
	eval "$(jenv init -)"
fi

_source_if_readable "$HOME/.cargo/env"

if [[ $(hostname -s) = galaxy3 ]]; then
	_source_if_readable ~/.rvm/scripts/rvm
fi

if [[ -n ${HOMEBREW_PREFIX-} ]]; then
	FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions${FPATH+:$FPATH}"
	export NODE_PATH="$HOMEBREW_PREFIX/lib/node_modules${NODE_PATH+:$NODE_PATH}"
fi
FPATH="$HOME/.zfunc/completion${FPATH+:$FPATH}"

export LS_COLORS="rs=0:di=1;36:ln=35:mh=00:pi=33:so=32:bd=34;46:cd=34;43:\
or=40;31;01:mi=00:su=30;41:sg=30;46:ca=00:tw=30;42:ow=30;43:st=30;44:ex=31:\
*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:\
*.swp=00;90:*.tmp=00;90"

# compdump file path
zstyle ':zim:completion' dumpfile \
	"${ZDOTDIR-$HOME}/.zcompdump-$SHORT_HOST-$ZSH_VERSION"
zstyle ':zim:glob' case-sensitivity sensitive
zstyle ':zim:zmodule' use degit

# For oh-my-zsh
ENABLE_CORRECTION=true

DEFAULT_USER=jnooree

# zim loading
ZIM_HOME="$HOME/.zim"
if [[ ! -e $ZIM_HOME/zimfw.zsh ]]; then
	curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
		https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
if [[ ! $ZIM_HOME/init.zsh -nt ${ZDOTDIR-$HOME}/.zimrc ]]; then
	source "$ZIM_HOME/zimfw.zsh" init -q
fi
source "$ZIM_HOME/init.zsh"
_comp_options+=(globdots)

unset ENABLE_CORRECTION DEFAULT_USER

# Highlight settings
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets regexp root)
ZSH_HIGHLIGHT_STYLES[comment]='bold,9'
ZSH_HIGHLIGHT_REGEXP[\bsudo\b]='bold,underline'

# Autocomplete settings
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

if [[ $_OS_ARCH = *Darwin* ]]; then
	# NFD...
	function prompt_current_dir() {
		local curr_dir='%~'
		local expanded_curr_dir="${(%)curr_dir}"

		# Show full path of named directories if they are the current directory.
		if [[ "$expanded_curr_dir" != */* ]]; then
			curr_dir='%/'
			expanded_curr_dir="${(%)curr_dir}"
		elif [[ ${#expanded_curr_dir} -gt $(( COLUMNS - ${MIN_COLUMNS:-30} )) ]]; then
			curr_dir='.../%2d'
			expanded_curr_dir="${(%)curr_dir}"
		fi

		print -n "$expanded_curr_dir" | uconv -x Any-NFC
	}
fi

# Related to pre{cmd,exec}
function jnr_precmd() {
	builtin print -n $'\033]0;'"$USER@$SHORT_HOST: ${(%)$(prompt_current_dir)}"$'\a'
}

function jnr_preexec() {
	builtin print -n $'\033]0;'"$USER@$SHORT_HOST: $1"$'\a'
}

autoload -U add-zsh-hook
add-zsh-hook precmd jnr_precmd
add-zsh-hook preexec jnr_preexec

# You may need to manually set your language environment
export LANG="en_US.UTF-8"

# Preferred editor for local and remote sessions
if [[ ${TERM_PROGRAM-} = vscode ]]; then
	export EDITOR="$(which code) --wait"
elif [[ -n ${SSH_CONNECTION-} ]]; then
	export EDITOR='rsub -n -w'
else
	export HOMEBREW_EDITOR='subl -n'
	export EDITOR='subl -n -w'
fi
export SUDO_EDITOR="$EDITOR"

if [[ $_OS_ARCH = *Linux* ]]; then
	alias visudo="sudo visudo"
	alias ufw-full-reload="sudo bash -c 'iptables -F; iptables -X; ip6tables -F; ip6tables -X; ufw disable; ufw enable'"
	alias sinf='sinfo -N -o "%8N  %9P  %.2t  %.13C  %.8O  %.6m  %.8e  %$(( $COLUMNS - 68 ))E"'
else
	alias sdsubl="sudo '/Applications/Sublime Text.app/Contents/MacOS/sublime_text'"
fi

if [[ -z ${SSH_CONNECTION-} ]]; then
	unfunction rcode
	alias rcode=code
fi

_source_if_readable /etc/zsh_command_not_found
_source_if_readable ~/.fzf.zsh

export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1
_source_if_readable ~/.iterm2_shell_integration.zsh
unset ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX

_source_if_readable "${ZDOTDIR-$HOME}/.zshrc.local"

unset _OS_ARCH
unfunction _source_if_readable

if command -v neofetch &>/dev/null &&
	[[ -z ${SSH_CONNECTION-} && $(who | wc -l) -eq 2 ]]; then
	echo
	neofetch
fi

# Path deduplication
declare -aU path
