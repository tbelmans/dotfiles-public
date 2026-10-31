# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/usr/local/go/bin:$HOME/repos/utils/dns:/usr/local/go/bin:/usr/bin:$HOME/.local/bin:$PATH
export GOPATH=$HOME/repos/go
#export GOROOT=/opt/homebrew/Cellar/go/1.23.2/libexec

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="pygmalion" # set by `omz`
#ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm
export LC_TIME=en_DK.UTF-8

alias rsync="/usr/bin/rsync -avzP"

# spaceship-prompt options
#SPACESHIP_PROMPT_ADD_NEWLINE="true" 
#SPACESHIP_CHAR_SYMBOL=" \\uf0e7" 
#SPACESHIP_CHAR_SUFFIX=(" ") 
#SPACESHIP_CHAR_COLOR_SUCCESS="yellow" 
#SPACESHIP_PROMPT_DEFAULT_PREFIX="$USER" 
#SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="true" 
#SPACESHIP_USER_SHOW="true"

#export LS_COLORS="di=34;40:ln=36;40:so=35;40:pi=33;40:ex=32;40:bd=1;33;40:cd=1;33;40:su=0;41:sg=0;43:tw=0;42:ow=34;40:"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
LC_CTYPE=en_US.UTF-8
LC_ALL=en_US.UTF-8

plugins=(git zsh-autosuggestions)
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
plugins=(zsh-ssh $plugins)


__complete_ssh_host() {
    local KNOWN_FILE=~/.ssh/known_hosts
    if [ -r $KNOWN_FILE ] ; then
        local KNOWN_LIST=`cut -f 1 -d ' ' $KNOWN_FILE | cut -f 1 -d ',' | grep -v '^[0-9[]'`
    fi

    local CONFIG_FILE=~/.ssh/config
    if [ -r $CONFIG_FILE ] ; then
        local CONFIG_LIST=`awk '/^Host [A-Za-z]+/ {print $2}' $CONFIG_FILE`
    fi

    local PARTIAL_WORD="${COMP_WORDS[COMP_CWORD]}";

    COMPREPLY=( $(compgen -W "$KNOWN_LIST$IFS$CONFIG_LIST" -- "$PARTIAL_WORD") )

    return 0
}

complete -F __complete_ssh_host ssh
export PATH="/opt/homebrew/bin:$PATH"

# Created by `pipx` on 2024-10-04 07:49:51
export PATH="$PATH:$HOME/.local/bin"
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"
export PATH="/opt/homebrew/opt/mariadb@11.4/bin:$PATH"
alias tar='tar --no-xattrs'

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Antigravity IDE
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# Dropped ssh/tmux connections leave the terminal in mouse-tracking mode,
# spewing 35;52;36M-style sequences on mouse move. Reset every mouse mode
# (tracking 1000/1002/1003, focus 1004, encodings 1005/1006/1015/1016)
# before each prompt, so any way back to a commandline turns it off.
_reset_mouse_modes() { printf '\e[?1000;1002;1003;1004;1005;1006;1015;1016l'; }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _reset_mouse_modes
alias fixmouse=_reset_mouse_modes

# Tint the Ghostty tab red while an ssh session is active; reset on exit.
# Uses hooks instead of an ssh() wrapper because Ghostty's shell integration
# defines its own ssh() after .zshrc loads.
_ssh_tint_preexec() {
  local -a words=(${(z)1})
  [[ ${words[1]} == ssh ]] || return
  printf '\e]11;#4a161c\a'
  _ssh_tinted=1
}
_ssh_tint_precmd() {
  (( _ssh_tinted )) || return
  printf '\e]111\a'
  _ssh_tinted=0
}
add-zsh-hook preexec _ssh_tint_preexec
add-zsh-hook precmd _ssh_tint_precmd

# Entire CLI shell completion
autoload -Uz compinit && compinit
(( $+commands[entire] )) && source <(entire completion zsh)

# Machine- or person-specific settings that don't belong in the shared repo.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
