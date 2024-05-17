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

	path=(
		"$_brew_opt/gnu-sed/libexec/gnubin"
		"$_brew_opt/gnu-tar/libexec/gnubin"
		"$_brew_opt/grep/libexec/gnubin"
		"$_brew_opt/findutils/libexec/gnubin"
		"$_brew_opt/coreutils/libexec/gnubin"
		"$_brew_opt/curl/bin"
		"$_brew_opt/ruby/bin"
		"$_brew_opt/ssh-copy-id/bin"
		"$_brew_opt/gnu-units/libexec/gnubin"
		"$_brew_opt/icu4c/bin"
		"$_brew_opt/binutils/bin"
		"$_brew_opt/node@20/bin"
		"$HOMEBREW_PREFIX/bin"
		"$HOMEBREW_PREFIX/sbin"
		"$path[@]"
	)

	fpath=("$_brew_opt/curl/share/zsh/site-functions" "$fpath[@]")

	unset _brew_opt
fi

path=("$HOME/bin" "$HOME/.local/bin" "$path[@]")

function _source_if_readable() {
	if [[ -r $1 ]] builtin source "$1" || true
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
	path=("$HOME/.jenv/bin" "$path[@]")
	eval "$(jenv init -)"
fi

_source_if_readable "$HOME/.cargo/env"

if [[ $(hostname -s) = galaxy3 ]]; then
	_source_if_readable ~/.rvm/scripts/rvm
fi

if [[ -n ${HOMEBREW_PREFIX-} ]]; then
	manpath=("$HOMEBREW_PREFIX/share/man" "$manpath[@]")
	fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" "$fpath[@]")
	export NODE_PATH="$HOMEBREW_PREFIX/lib/node_modules:$NODE_PATH"
fi
fpath=("$HOME/.dotfiles/.zfunc/completion" "$fpath[@]")

export LS_COLORS="rs=0:di=1;36:ln=35:mh=00:pi=33:so=32:bd=34;46:cd=34;43:\
or=40;31;01:mi=00:su=30;41:sg=30;46:ca=00:tw=30;42:ow=30;43:st=30;44:ex=31:\
*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:\
*.swp=00;90:*.tmp=00;90"

# compdump file path
zstyle ':zim:completion' dumpfile \
	"${ZDOTDIR-$HOME}/.zcompdump-$SHORT_HOST-$ZSH_VERSION"
zstyle ':completion::complete:*' cache-path \
	"${XDG_CACHE_HOME-$HOME/.cache}/zsh/zcompcache-$SHORT_HOST"
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
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty)

if [[ $_OS_ARCH = *Darwin* ]]; then
	# NFD...
	function prompt_current_dir() {
		local curr_dir='%~'
		local expanded_curr_dir="${(%)curr_dir}"

		# Show full path of named directories if they are the current directory.
		if [[ $expanded_curr_dir != */* ]]; then
			curr_dir='%/'
			expanded_curr_dir="${(%)curr_dir}"
		fi
		if [[ ${#expanded_curr_dir} -gt $(( COLUMNS - ${MIN_COLUMNS:-30} )) ]]; then
			curr_dir='.../%2/'
			expanded_curr_dir="${(%)curr_dir}"
		fi

		psvar[1]="$(builtin print -rn -- "$expanded_curr_dir" | uconv -x Any-NFC)"
	}

	# Re-run for macos
	prompt_current_dir
fi

# Related to pre{cmd,exec}
function jnr_precmd() {
	builtin print -Pn '\e]0;%n@%m: %1v\a'
}

function jnr_preexec() {
	builtin print -Pn '\e]0;%n@%m: '
	builtin print -rn -- "$1"
	builtin print -n '\a'
}

autoload -U add-zsh-hook
add-zsh-hook precmd jnr_precmd
add-zsh-hook preexec jnr_preexec

# Preferred editor for local and remote sessions
if [[ ${TERM_PROGRAM-} = vscode ]]; then
	export EDITOR="$(which code) --wait"
elif [[ ${LC_TERMINAL-} = terminus ]]; then
	export EDITOR=vim
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
_source_if_readable ~/.iterm2_shell_integration.zsh

if command -v it2copy &>/dev/null; then
	detect-clipboard
	unfunction clipcopy
	function clipcopy() {
		it2copy "$@"
	}
fi

if command -v direnv &>/dev/null; then
	function _direnv_hook() {
		trap -- '' SIGINT;
		eval "$(direnv export zsh)";
		trap - SIGINT;
	}

	add-zsh-hook precmd _direnv_hook
	add-zsh-hook preexec _direnv_hook
fi

if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh --hook pwd --no-cmd)"

	function z() {
		setopt localoptions no_autonamedirs
		__zoxide_z "$@"
	}

	function zi() {
		setopt localoptions no_autonamedirs
		__zoxide_zi "$@"
	}
fi

_source_if_readable "${ZDOTDIR-$HOME}/.zshrc.local"

unset _OS_ARCH
unfunction _source_if_readable

function _cleanup_path_arr() {
	typeset -aUg "$1"

	: "${(PA)1::="${(@P)1:#}"}"
}

function _cleanup_path_str() {
	if [[ -z ${(P)1} ]] return

	local -a pa=("${(@Ps.:.)1}")
	_cleanup_path_arr pa
	: "${(P)1::="${(@j.:.)pa}"}"
}

for _arr in path fpath manpath module_path; do
	_cleanup_path_arr "$_arr"
done
for _str in CPATH GEM_PATH INFOPATH LD_LIBRARY_PATH LIBRARY_PATH \
		NLSPATH NODE_PATH PKG_CONFIG_PATH PYTHONPATH XDG_DATA_DIRS; do
	_cleanup_path_str "$_str"
done

unset _arr _str
unfunction _cleanup_path_arr _cleanup_path_str

# Add default search directories at the end
MANPATH="${MANPATH}:"
INFOPATH="${INFOPATH}:"

if command -v neofetch &>/dev/null &&
	[[ -z ${SSH_CONNECTION-} && $(who | wc -l) -eq 2 ]]; then
	echo
	neofetch
fi
