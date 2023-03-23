# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
	else
	color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*)
	;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
  fi
fi

###############################################################################
### User's Constant
###############################################################################
ENDL="\r\n"

KNRM="\033[0m"
KRED="\033[31m"
KGRN="\033[32m"
KYEL="\033[33m"
KBLU="\033[34m"
KMAG="\033[35m"
KCYN="\033[36m"
KWHT="\033[37m"

KLGRN="\033[92m"
KLRED="\033[91m"
KLYEL="\033[93m"
KLBLU="\033[94m"
KLMAG="\033[95m"
KLCYN="\033[96m"

# Console style print
KBOLD="\033[1m"
KUDLN="\033[4m"

# Reset all settings of console print
KRESET="\033[0m"
KRBOLD="\033[21m"

ENDL="\r\n"

###############################################################################
### User's Settings
###############################################################################
xset r rate 169 58

###############################################################################
### ENV Vars
###############################################################################
export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]\[\033[01;34m\]\w\[\033[00m\]\n\$ "
export PATH=$PATH:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/go/bin
export PATH=$PATH:/opt/eldk-5.5.3/armv7a-hf/sysroots/i686-eldk-linux/usr/bin/arm-linux-gnueabi
export PATH=$PATH:~/bin/gcc-arm-none-eabi-5_4-2016q2/bin
export GREP_COLORS="ms=01;31:mc=01;31:sl=:cx=:fn=04;45:ln=32:bn=32:se=36"

###############################################################################
### Colorize the man page
###############################################################################
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan
# Tell less to interprated ANSI escaped color code
# [Ref](https://unix.stackexchange.com/questions/19317/can-less-retain-colored-output)
export LESS=-Xr

###############################################################################
### Utility Scripts
###############################################################################
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

###################
### Enable rails
source ~/.rvm/scripts/rvm

###################
### Python virtualenv
# Setup guide: http://exponential.io/blog/2015/02/10/install-virtualenv-and-virtualenvwrapper-on-ubuntu/
# Another good guide: http://docs.python-guide.org/en/latest/dev/virtualenvs/
# 1. Install packages:
# sudo apt-get install python-pip python-dev build-essential
# sudo pip install virtualenv virtualenvwrapper
# sudo pip install --upgrade pip
# 2. Add these 2 lines to ~/.bashrc
# 3. Enable virtual environment
# mkvirtualenv api
# 4. To wotk on `api` virtual environment, use:
# workon api
# 5. To deactivate `api` virtual environment, use:
# deactivate
export WORKON_HOME=~/virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

##################
### GO PATH
export GOPATH=~/workspace_pif-store/golang
export GOBIN=~/workspace_pif-store/golang/bin

##################
### ESP PATH
ESP_DIR=~/workspace_esp/
# generic ESP8266/ESP32 need these env variable
export PATH=$PATH:$ESP_DIR/esp32/xtensa-esp32-elf/bin
export PATH=$PATH:$ESP_DIR/esp8266/esp-open-sdk/xtensa-lx106-elf/bin
export IDF_PATH=$ESP_DIR/esp32/esp-idf
export PATH=$PATH:$ESP_DIR/esp8266/esp-open-sdk/esptool
export PATH=$PATH:$ESP_DIR/esp8266/Arduino/tools
# `makeEspArduino.mk` need this env variable, assume we use `arduino for esp8266` only
export ESP_ROOT=$ESP_DIR/esp8266/Arduino
# Create command line utility for esp arduino project
# https://github.com/plerup/makeEspArduino
alias espmake="make -f $ESP_DIR/makeEspArduino/makeEspArduino.mk"

source ~/.bash_completion.d/mbed
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/Users/zealot/Library/Python/2.7/bin

complete -C aws_completer aws

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
