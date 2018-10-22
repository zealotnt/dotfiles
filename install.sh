#!/bin/bash

# Make sure $MYDOTFILES is exported at .zshrc

for file in  "${MYDOTFILES[@]}"
do
	echo "Backing up $file"
	mv ~/$file ~/$file.bak
	echo "Using dotfiles file instead"
	ln -sf $(realpath $file) ~/
done
