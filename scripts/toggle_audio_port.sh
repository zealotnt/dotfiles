#!/bin/bash

CURRENT_PORT=$(pacmd list-sinks | grep 'active port' | grep 'analog' | sed -r -n 's/.*<(.*)>/\1/p')
# headphones is the port in front of machine
if [[ "$CURRENT_PORT" == "analog-output-headphones" ]]; then
  pacmd set-sink-port 2 analog-output-lineout
  echo "🎧" > ~/.local/audio_device
else
  pacmd set-sink-port 2 analog-output-headphones
  echo "🔊" > ~/.local/audio_device
fi

pkill -SIGRTMIN+10 i3blocks

