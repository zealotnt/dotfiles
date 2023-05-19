#!/bin/bash

CLICK_LEFT=1
CLICK_RIGHT=3

xdotool click $CLICK_LEFT
sleep 0.1
/usr/bin/env ruby /home/zealot/dotfiles/scripts/mouse-move-position-window.rb
xdotool click $CLICK_RIGHT
sleep 0.1
xdotool mousemove_relative --sync 100 80
sleep 0.1
xdotool click $CLICK_LEFT
xdotool key Escape

URL=$(xclip -selection clipboard -o)
RES_URL=$(echo $URL | sed -r -n 's/(.*)\?.*$/\1/p')
if [[ -z $RES_URL ]]; then
  RES_URL=$URL
fi
echo $RES_URL | xclip -sel clip

sleep 0.1
i3-msg "workspace 1"
sleep 0.1
i3-msg "focus right"
sleep 0.1
/usr/bin/env ruby /home/zealot/dotfiles/scripts/mouse-move-position-window.rb
xdotool click $CLICK_LEFT
sleep 0.1
xdotool getactivewindow key ctrl+t
sleep 0.1
xdotool getactivewindow key ctrl+l
sleep 0.1
xdotool getactivewindow key ctrl+v
sleep 0.1
xdotool getactivewindow key KP_Enter

notify-send "
origin: $URL
then:   $RES_URL"
