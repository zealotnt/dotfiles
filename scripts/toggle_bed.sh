#!/usr/bin/bash

if [[ $# == 0 ]]; then
  LOCAL_BED_FAN=$(cat ~/.local_bed_fan)
  if [[ "$LOCAL_BED_FAN" == "0" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c ToggleBedFan
    echo 1 > ~/.local_fan
  else
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c ToggleBedFan
    echo 0 > ~/.local_fan
  fi
else
  if [[ "$1" == "0" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnBedFan
    sleep 2
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c ToggleBedFan
    echo 0 > ~/.local_fan
  else
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnBedFan
    echo 1 > ~/.local_fan
  fi
fi
