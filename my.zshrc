# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Antigen: https://github.com/zsh-users/antigen
ANTIGEN="$HOME/.local/bin/antigen.zsh"

# Install antigen.zsh if not exist
if [ ! -f "$ANTIGEN" ]; then
	echo "Installing antigen ..."
	[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
	[ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
	# [ ! -f "$HOME/.z" ] && touch "$HOME/.z"
	URL="http://git.io/antigen"
	TMPFILE="/tmp/antigen.zsh"
	if [ -x "$(which curl)" ]; then
		curl -L "$URL" -o "$TMPFILE"
	elif [ -x "$(which wget)" ]; then
		wget "$URL" -O "$TMPFILE"
	else
		echo "ERROR: please install curl or wget before installation !!"
		exit
	fi
	if [ ! $? -eq 0 ]; then
		echo ""
		echo "ERROR: downloading antigen.zsh ($URL) failed !!"
		exit
	fi;
	echo "move $TMPFILE to $ANTIGEN"
	mv "$TMPFILE" "$ANTIGEN"
fi



# Load local bash/zsh compatible settings
INIT_SH_NOLOG=1
DISABLE_Z_PLUGIN=1
[ -f "$HOME/.local/etc/init.sh" ] && source "$HOME/.local/etc/init.sh"

# exit for non-interactive shell
[[ $- != *i* ]] && return

# WSL (aka Bash for Windows) doesn't work well with BG_NICE
[ -d "/mnt/c" ] && [[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE

# Initialize antigen
source "$ANTIGEN"

# Setup dir stack
DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups cdablevars
alias d='dirs -v | head -10'

# Enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"

ZSH_AUTOSUGGEST_USE_ASYNC=1

# Declare modules
zstyle ':prezto:*:*' color 'yes'
zstyle ':prezto:module:prompt' theme 'cloud'
zstyle ':prezto:module:prompt' pwd-length 'short'
zstyle ':prezto:module:editor' key-bindings 'vi'
zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:autosuggestions' color 'yes'
zstyle ':prezto:module:python' autovenv 'yes'
zstyle ':prezto:load' pmodule \
	'environment' \
	'editor' \
	'history' \
	'git' \
	'utility' \
	'completion' \
	'history-substring-search' \
	'autosuggestions' \
	'prompt'
# Initialize prezto
antigen use prezto


# default bundles
antigen bundle rupa/z z.sh
antigen bundle Vifon/deer
antigen bundle zdharma-continuum/fast-syntax-highlighting
# antigen bundle zsh-users/zsh-autosuggestions

antigen bundle willghatch/zsh-cdr
# antigen bundle zsh-users/zaw

# check login shell
if [[ -o login ]]; then
	[ -f "$HOME/.local/etc/login.sh" ] && source "$HOME/.local/etc/login.sh"
	[ -f "$HOME/.local/etc/login.zsh" ] && source "$HOME/.local/etc/login.zsh"
fi

# syntax color definition
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

typeset -A ZSH_HIGHLIGHT_STYLES

# ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'

ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[assign]=none

# load local config
[ -f "$HOME/.local/etc/config.zsh" ] && source "$HOME/.local/etc/config.zsh"
[ -f "$HOME/.local/etc/local.zsh" ] && source "$HOME/.local/etc/local.zsh"

antigen apply

# work around: fast syntax highlighting may crash zsh without this
FAST_HIGHLIGHT[chroma-git]="chroma/-ogit.ch"

# options
unsetopt correct_all
unsetopt share_history
setopt prompt_subst
unsetopt prompt_cr prompt_sp

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY # Don't execute immediately upon history expansion.

# setup for deer
autoload -U deer
zle -N deer

# default keymap
bindkey -s '\ee' 'vim\n'
bindkey '\eh' backward-char
bindkey '\el' forward-char
bindkey '\ej' down-line-or-history
bindkey '\ek' up-line-or-history
bindkey '\eH' backward-word
bindkey '\eL' forward-word
bindkey '\eJ' beginning-of-line
bindkey '\eK' end-of-line

bindkey -s '\eo' 'cd ..\n'
bindkey -s '\e;' 'll\n'

bindkey '\e[1;3D' backward-word
bindkey '\e[1;3C' forward-word
bindkey '\e[1;3A' beginning-of-line
bindkey '\e[1;3B' end-of-line

bindkey '\ev' deer
bindkey -s '\eu' 'ranger_cd\n'
bindkey -s '\eOS' 'vim '


# source function.sh if it exists
[ -f "$HOME/.local/etc/function.sh" ] && . "$HOME/.local/etc/function.sh"

# Disable correction
unsetopt correct_all
unsetopt correct
DISABLE_CORRECTION="true"

# completion detail
zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*:*sh:*:' tag-order files


#export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export ICS_MODEL_ZOOS=/home/mini/cabin/ics_model_zoo
export QNX_700_TOOLCHAIN=/home/mini/cabin/qnx700sdp
export QNX_710_TOOLCHAIN=/home/mini/cabin/qnx710
export ANDROID_NDK=/home/mini/Software/android-ndk-r21e
export ANDROID_NDK_R21=/home/mini/Software/android-ndk-r21e
export ANDROID_DSP_LIBS=/home/mini/Software/android_dsp_libs
export ANDROID_HOME=/home/mini/Android/Sdk
export GCC_ARM64_TOOLCHAIN=/home/mini/Software/orinx_linux/aarch64--glibc--stable-2020.08-1
export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:/home/mini/Software/depot_tools:$PATH
export SDK_ROOT=/home/mini/sourcecode
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
