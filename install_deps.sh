#!/bin/bash

# insstall oh-my-tmux: gpakosz/.tmux
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/
cp ~/.tmux/.tmux.conf.local .
# install tpm for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git -C ~/.tmux/ clone https://github.com/jonmosco/kube-tmux

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# zsh-plugins
git clone https://github.com/popstas/zsh-command-time.git ~/.oh-my-zsh/custom/plugins/command-time
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/djui/alias-tips.git ~/.oh-my-zsh/custom/plugins/alias-tips
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone git@github.com:wulfgarpro/history-sync.git ~/.oh-my-zsh/plugins/history-sync
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# other utils
git clone https://github.com/alexppg/helmenv.git ~/.helmenv

source ~/dotfiles/install.sh

git submodule init
git submodule update

