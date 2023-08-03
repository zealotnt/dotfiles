#!/bin/bash

. /home/zealot/.zprofile
SCRIPT=$1

curl -X POST -H "Authorization: Bearer $HOMEASSISTANT_TOKEN" -H "Content-Type: application/json" -d "{\"entity_id\": \"script.$SCRIPT\"}" http://192.168.31.9:8123/api/services/script/turn_on
