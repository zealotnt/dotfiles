#!/usr/bin/bash

BLACKBEAN_CONTROL_PATH=/home/zealot/workspace_misc/rm3_mini_controller
#BLACKBEAN_CONTROL_PATH=/root/dev/rm3_mini_controller

if [[ $# == 0 ]]; then
  LOCAL_AIR_CON=$(cat ~/.local_air_con)
  if [[ "$LOCAL_AIR_CON" == "0" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOnAirCon
    echo 1 > ~/.local_air_con
  else
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOffAirCon
    echo 0 > ~/.local_air_con
  fi
else
  if [[ "$1" == "0" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOffAirCon
    echo 0 > ~/.local_air_con
  elif  [[ "$1" == "t26OldDaikin" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c ToggleAirConOldDaikin26
  elif  [[ "$1" == "26OldDaikin" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c SetAirConOldDaikin26
  elif  [[ "$1" == "27OldDaikin" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c SetAirConOldDaikin27
  elif  [[ "$1" == "28OldDaikin" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c SetAirConOldDaikin28
  elif  [[ "$1" == "27" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOnAirConComfort27
    echo 1 > ~/.local_air_con
  elif  [[ "$1" == "28" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOnAirConComfort28
    echo 1 > ~/.local_air_con
  elif  [[ "$1" == "29" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOnAirConComfort29
    echo 1 > ~/.local_air_con
  elif  [[ "$1" == "fan" ]]; then
    python $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOnAirConFanOnly
    echo 1 > ~/.local_air_con
  else
    python  $BLACKBEAN_CONTROL_PATH/BlackBeanControl.py -c TurnOnAirCon
    echo 1 > ~/.local_air_con
  fi
fi
