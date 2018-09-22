#!/bin/bash

FILES=( .bashrc .bashrc-func .gitconfig .tmux.conf.local .zshrc)
for file in  "${FILES[@]}"
do
	echo "Backing up $file"
	mv ~/$file ~/$file.bak
	echo "Using dotfiles file instead"
	ln -sf $(realpath $file) ~/
done
