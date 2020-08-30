#!/usr/bin/bash


if [[ $# == 0 ]]; then
  LOCAL_AIR_CON=$(cat ~/.local_air_con)
  if [[ "$LOCAL_AIR_CON" == "0" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnAirCon
    echo 1 > ~/.local_air_con
  else
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOffAirCon
    echo 0 > ~/.local_air_con
  fi
else
  if [[ "$1" == "0" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOffAirCon
    echo 0 > ~/.local_air_con
  else
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnAirCon
    echo 1 > ~/.local_air_con
  fi
fi
