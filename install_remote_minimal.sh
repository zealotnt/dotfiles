#!/bin/bash

# insstall oh-my-tmux: gpakosz/.tmux
git clone https://github.com/gpakosz/.tmux.git ~/
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
# install tpm for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

source ~/dotfile/install.sh
