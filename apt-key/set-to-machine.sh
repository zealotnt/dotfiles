#!/bin/bash

. ~/dotfiles/apt-key/target.sh

for target in "${TARGETS[@]}"
do
  echo "sudo cp -rp ~/dotfiles/apt-key/$target /etc/apt/sources.list.d/$target"
done

