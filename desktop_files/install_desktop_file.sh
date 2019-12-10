#!/bin/bash

if [[ $? != 0 ]]; then
  echo "Usage:"
  echo " install_desktop_file.sh <desktop to install to current user's desktop files>"
  return
fi

echo "ln -sf \"$(realpath $1)\" ~/.local/share/applications/"
ln -sf "$(realpath $1)" ~/.local/share/applications/

