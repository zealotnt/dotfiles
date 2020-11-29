#!/usr/bin/env ruby
# require 'pry-byebug'

def toggle_room_light
  `curl -s http://192.168.31.232/toggle`
end

def toggle_balcony_light
  `curl -s http://192.168.31.159/toggle`
end

def toggle_bed_fan
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_bed.sh`
end

def toggle_fan
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_fan.sh`
end

def toggle_air_con
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_air_con.sh`
end

def toggle_audio_port
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_audio_port.sh`
end

def room_enter_scenario
  `curl -s http://192.168.31.232/control?relay=on`
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh 1`
  `/bin/bash ~/dotfiles/scripts/toggle_fan.sh 1`
  `pactl set-sink-mute 0 0`
end

def off_screen
  `DISPLAY=$(w | grep zealot | grep gdm | awk '{print $3}') xset dpms force off`
end

def off_air_con
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh 0`
end

def off_fan
  `/bin/bash ~/dotfiles/scripts/toggle_fan.sh 0`
end

def go_to_bed
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_fan.sh 0`
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_bed.sh 1`
end

def go_to_desk
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_fan.sh 1`
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_bed.sh 0`
end

def room_leave_scenario
  `curl -s http://192.168.31.232/control?relay=off`
  off_air_con
  off_fan
  `playerctl pause -a`
  `pactl set-sink-mute 0 1`
end

CONTROL_COMMANDS = [
  "Toggle Room Light",
  "Toggle Balcony Light",
  "Toggle Fan",
  "Toggle Bed (3an)",
  "Toggle Air Con",
  "Toggle Audio Output",
  "Enter Room Scenario",
  "Leave Room Scenario",
  "Turn off screen",
  "Turn off air con",
  "Turn off fan",
  "Go to bed",
  "Go to desk",
]

CONTROL_FUNC = [
  method(:toggle_room_light),
  method(:toggle_balcony_light),
  method(:toggle_fan),
  method(:toggle_bed_fan),
  method(:toggle_air_con),
  method(:toggle_audio_port),
  method(:room_enter_scenario),
  method(:room_leave_scenario),
  method(:off_screen),
  method(:off_air_con),
  method(:off_fan),
  method(:go_to_bed),
  method(:go_to_desk),
]

# FIRST
if ARGV.length != 1
  puts CONTROL_COMMANDS.join("\r\n")
  exit 0
end

`echo #{ARGV[0]} > /tmp/debug`
CONTROL_FUNC[CONTROL_COMMANDS.index(ARGV[0].chomp)].call


