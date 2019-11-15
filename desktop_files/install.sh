#!/bin/bash

for f in *.desktop
do
  echo "ln -sf \"$(realpath $f)\" ~/.local/share/applications/"
  ln -sf "$(realpath $f)" ~/.local/share/applications/
done
