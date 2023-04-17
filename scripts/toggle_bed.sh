#!/bin/bash

if [[ "$1" == "toggle" ]]; then
    broadlink_cli --type 0x520d --host <host> --mac <mac> --send @/home/zealot/Old-Home/zealot/workspace_misc/python-broadlink/fan-toggle.ircode
elif [[ "$1" == "1" ]]; then
    broadlink_cli --type 0x520d --host <host> --mac <mac> --send @/home/zealot/Old-Home/zealot/workspace_misc/python-broadlink/fan-1.ircode
elif [[ "$1" == "2" ]]; then
    broadlink_cli --type 0x520d --host <host> --mac <mac> --send @/home/zealot/Old-Home/zealot/workspace_misc/python-broadlink/fan-2.ircode
elif [[ "$1" == "3" ]]; then
    broadlink_cli --type 0x520d --host <host> --mac <mac> --send @/home/zealot/Old-Home/zealot/workspace_misc/python-broadlink/fan-3.ircode
else
  echo 'no action, ignore'
fi
