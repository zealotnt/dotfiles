#!/bin/bash

#notify-send "chay roi ne"
URL=$(xclip -selection clipboard -o)
RES_URL=$(echo $URL | sed -r -n 's/(.*)\?.*$/\1/p')
if [[ -z $RES_URL ]]; then
  RES_URL=$URL
fi
echo $RES_URL | xsel -i -b
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
