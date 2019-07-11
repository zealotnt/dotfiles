#!/bin/bash

# Sync my-dot-files.sh
. ~/dotfiles/my-dot-files.sh

for file in  "${MYDOTFILES[@]}"
do
	echo "Backing up $file"
	mv ~/$file ~/$file.bak
	echo "Using dotfiles file instead"
	ln -sf $(realpath $file) ~/
done
