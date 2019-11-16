#!/bin/bash

# refs
# https://askubuntu.com/questions/712517/how-to-switch-between-headphones-and-speakers-without-unplugging-headphones
# https://superuser.com/questions/431079/how-to-disable-auto-mute-mode

FILES=(analog-output-headphones.conf analog-output-lineout.conf)
for file in "${FILES[@]}"
do
  sudo cp ~/dotfiles/pulseaudio/$file /usr/share/pulseaudio/alsa-mixer/paths/$file
done

amixer -c0 sset 'Auto-Mute Mode' Disabled
sudo alsactl store
pulseaudio -k
pulseaudio --start
