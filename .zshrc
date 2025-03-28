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
		"$_brew_opt/ruby/bin"
		"$_brew_opt/ssh-copy-id/bin"
		"$_brew_opt/gnu-units/libexec/gnubin"
		"$_brew_opt/icu4c/bin"
		"$_brew_opt/binutils/bin"
		"$_brew_opt/node@20/bin"
		"$HOMEBREW_PREFIX/bin"
		"$HOMEBREW_PREFIX/sbin"
		$path
	)

	fpath=("$_brew_opt/curl/share/zsh/site-functions" $fpath)

	unset _brew_opt
fi

path=("$HOME/bin" "$HOME/.local/bin" $path)

function _source_if_readable() {
	if [[ -r $1 ]] builtin source "$1" || true
}

# environment managers

if [[ -x ~/.jenv/bin/jenv ]]; then
	path=("$HOME/.jenv/bin" $path)
	eval "$(jenv init -)"
fi

if command -v rbenv &>/dev/null; then
	eval "$(rbenv init - --no-rehash zsh)"
fi

_source_if_readable "$HOME/.cargo/env"

if [[ -n ${HOMEBREW_PREFIX-} ]]; then
	manpath=("$HOMEBREW_PREFIX/share/man" $manpath)
	fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
	export NODE_PATH="$HOMEBREW_PREFIX/lib/node_modules:$NODE_PATH"
fi
fpath=("$HOME/.dotfiles/.zfunc/completion" $fpath)

export LS_COLORS="rs=0:di=1;36:ln=35:mh=00:pi=33:so=32:bd=34;46:cd=34;43:\
or=40;31;01:mi=00:su=30;41:sg=30;46:ca=00:tw=30;42:ow=30;43:st=30;44:ex=31:\
*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:\
*.swp=00;90:*.tmp=00;90"

# compdump file path
zstyle ':zim:completion' dumpfile \
	"${XDG_CACHE_HOME-$HOME/.cache}/zsh/zcompdump-$SHORT_HOST-$ZSH_VERSION"
zstyle ':completion::complete:*' cache-path \
	"${XDG_CACHE_HOME-$HOME/.cache}/zsh/zcompcache-$SHORT_HOST-$ZSH_VERSION"
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
ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1 source "$ZIM_HOME/init.zsh"
_comp_options+=(globdots)

unset ENABLE_CORRECTION DEFAULT_USER

# Highlight settings
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets root)
ZSH_HIGHLIGHT_STYLES[comment]='bold,9'

if [[ -o rematchpcre ]]; then
	ZSH_HIGHLIGHT_HIGHLIGHTERS+=(regexp)
	ZSH_HIGHLIGHT_REGEXP[\bsudo\b]='bold,underline'
fi

# Autocomplete settings
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty)

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE="$HOME/anaconda3/bin/mamba";
export MAMBA_ROOT_PREFIX="$HOME/anaconda3";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# Preferred editor for local and remote sessions
export EDITOR=vim
if [[ ${TERM_PROGRAM-} = vscode ]]; then
	export EDITOR="$(which code) --wait"
elif [[ -z ${SSH_CONNECTION-} ]]; then
	unfunction rcode
	alias rcode=code
	if command -v subl &>/dev/null; then
		export HOMEBREW_EDITOR='subl -n'
		export EDITOR='subl -n -w'
	fi
elif command -v rsub &>/dev/null && [[ ${LC_TERMINAL-} != terminus ]]; then
	alias -g subl=rsub
	export EDITOR='rsub -n -w'
	export RMATE_PORT="${LC_RSUB_PORT:-58023}"
fi
export SUDO_EDITOR="$EDITOR"

if [[ $_OS_ARCH = *Linux* ]]; then
	alias visudo="sudo visudo"
	alias ufw-full-reload="sudo bash -c 'iptables -F; iptables -X; ip6tables -F; ip6tables -X; ufw disable; ufw enable'"
	alias sinf='sinfo -N -o "%8N  %9P  %.2t  %.13C  %.8O  %.6m  %.8e  %$(( $COLUMNS - 68 ))E"'
else
	alias sdsubl="sudo '/Applications/Sublime Text.app/Contents/MacOS/sublime_text'"
fi

_source_if_readable /etc/zsh_command_not_found
_source_if_readable ~/.fzf.zsh

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

export DFT_BACKGROUND=light

_source_if_readable "${ZDOTDIR-$HOME}/.zshrc.local"

if [[ -z ${RCODE_REMOTE-} && -n ${LC_RCODE_REMOTE-} ]]; then
  RCODE_REMOTE="$LC_RCODE_REMOTE"
fi

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
