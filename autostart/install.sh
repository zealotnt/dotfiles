#!/bin/bash

mkdir -p ~/.config/autostart

for f in *.desktop
do
  echo "ln -sf \"$(realpath $f)\" ~/.config/autostart"
  ln -sf "$(realpath $f)" ~/.config/autostart
done
