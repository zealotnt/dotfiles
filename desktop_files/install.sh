#!/bin/bash

for f in *.desktop
do
  ln -sf "$(realpath $f)" ~/.local/share/applications/
done
