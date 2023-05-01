#!/usr/bin/bash

BLACKBEAN_CONTROL_PATH=/home/zealot/workspace_misc/rm3_mini_controller
#BLACKBEAN_CONTROL_PATH=/root/dev/rm3_mini_controller

if [[ $# == 0 ]]; then
  LOCAL_FAN=$(cat ~/.local_fan)
  if [[ "$LOCAL_FAN" == "0" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOnFan
    echo 1 > ~/.local_fan
  else
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOffFan
    echo 0 > ~/.local_fan
  fi
else
  if [[ "$1" == "0" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOffFan
    echo 0 > ~/.local_fan
  else
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOnFan
    echo 1 > ~/.local_fan
  fi
fi
