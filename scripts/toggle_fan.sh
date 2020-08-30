#!/usr/bin/bash

if [[ $# == 0 ]]; then
  LOCAL_FAN=$(cat ~/.local_fan)
  if [[ "$LOCAL_FAN" == "0" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnFan
    echo 1 > ~/.local_fan
  else
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOffFan
    echo 0 > ~/.local_fan
  fi
else
  if [[ "$1" == "0" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOffFan
    echo 0 > ~/.local_fan
  else
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnFan
    echo 1 > ~/.local_fan
  fi
fi
