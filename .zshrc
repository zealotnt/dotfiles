#!/bin/zsh

# boolean: true/false
RUN_PROFILING=false
if [ "$RUN_PROFILING" = true ]; then zmodload zsh/zprof; fi
# set -x

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="spaceship"
ZSH_THEME="robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array h
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bundler
  dotenv
  osx
  rake
  # rbenv
  ruby
  docker
  docker-compose
  iterm2
  postgres
  tmuxinator
  command-time
  sublime
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  kubectl
  alias-tips
  autojump
  z
  web-search
  urltools
  rails
  rake
  rake-fast
  copybuffer
  copydir
  copyfile
  colorize
  colored-man-pages
  extract
)

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

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# ZSH-Command-Time
# https://github.com/popstas/zsh-command-time
# If command execution time above min. time, plugins will output time.
ZSH_COMMAND_TIME_MIN_SECONDS=1
# Message to display (set to "" for disable).
ZSH_COMMAND_TIME_MSG="Execution time: %s sec"
# Message color.
ZSH_COMMAND_TIME_COLOR="cyan"

# >>>>>>>>>>>>>>>>>>>>>>>>>>> My stuff here >>>>>>>>>>>>>>>>>>>>>>>>>>>
# =========== prepare for the env
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' # https://stackoverflow.com/questions/444951/zsh-stop-backward-kill-word-on-directory-delimiter

export PYTHONSTARTUP=~/.startup.py

### LESS ###
# Enable syntax-highlighting in less.
# brew install source-highlight
# First, add these two lines to ~/.bashrc
export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
export LESS=" -R "
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias more='less'

# Change PROMPT a bit
PROMPT='${ret_status} %{$fg[cyan]%}%d%{$reset_color%} $(git_prompt_info) %{$fg[yellow]%}[%D{%y/%m/%f}|%@]%{$reset_color%}
%{$fg[cyan]%}$%{$reset_color%} '

export LANG=en_US.UTF-8 # fix alacrity UTF font issue
export EDITOR="emacsclient -nw -create-frame"
export GOPATH=~/go
export GOBIN=~/go/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/bin # fix alacrity PATH issue
export PATH=$PATH:/Users/zealot/Library/Python/2.7/bin
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
export PATH="/home/zealot/.cask/bin:$PATH"

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/usr/local/Cellar/findutils/4.6.0/bin:$PATH"
fi

. ~/dotfiles/my-dot-files.sh
DISABLE_AUTO_TITLE=true
# =========== load real stuff here
# complete -C aws_completer aws

# disable share command history
# https://superuser.com/questions/1245273/iterm2-version-3-individual-history-per-tab
# unsetopt inc_append_history
# unsetopt share_history

autoload -Uz compinit && compinit -i
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.bashrc-func
source ~/dotfiles/.custom_completions.sh
source ~/dotfiles/sandboxd/sandboxd
source ~/.helmenv/helmenv.sh

eval "$(hub alias -s)"
alias vim="nvim"
alias vi="nvim"

# ========================================================
# https://nuclearsquid.com/writings/edit-long-commands/
# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
# zle -N edit-command-line
# bindkey '^xe' edit-command-line
# bindkey '^x^e' edit-command-line
# Vi style:
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# https://superuser.com/questions/479600/how-can-i-prevent-tmux-exiting-with-ctrl-d
setopt ignoreeof

if [ "$RUN_PROFILING" = true ]; then zprof; fi
