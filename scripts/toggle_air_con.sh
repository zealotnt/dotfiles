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
  elif  [[ "$1" == "27" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnAirConComfort27
    echo 1 > ~/.local_air_con
  elif  [[ "$1" == "28" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnAirConComfort28
    echo 1 > ~/.local_air_con
  elif  [[ "$1" == "29" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnAirConComfort29
    echo 1 > ~/.local_air_con
  elif  [[ "$1" == "fan" ]]; then
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnAirConFanOnly
    echo 1 > ~/.local_air_con
  else
    python /home/zealot/workspace_misc/rm3_mini_controller/BlackBeanControl.py -c TurnOnAirCon
    echo 1 > ~/.local_air_con
  fi
fi
