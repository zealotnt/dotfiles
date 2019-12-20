#!/bin/bash

# Sync my-dot-files.sh
. ~/dotfiles/my-dot-files.sh

BACKUP_FOLDER=~/dotfiles/backup/$(date +"%Y%m%d")-$(date +"%H%M%S")
mkdir -p $BACKUP_FOLDER
echo "Creating backup folder $BACKUP_FOLDER"

for file in  "${MYDOTFILES[@]}"
do
	[ -f ~/$file ] && printf "Backing up/" && mv ~/$file $BACKUP_FOLDER/$file.bak
  printf "Linking $file\n"
	ln -sf $(realpath $file) ~/
done
