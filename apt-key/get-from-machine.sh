#!/bin/bash

. ~/dotfiles/apt-key/target.sh

for target in "${TARGETS[@]}"
do
  echo "sudo cp -rp /etc/apt/sources.list.d/$target ~/dotfiles/apt-key/$target"
done

