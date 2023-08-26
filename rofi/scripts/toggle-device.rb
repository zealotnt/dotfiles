#!/usr/bin/env ruby
# require 'pry-byebug'

def toggle_room_light
  `curl 'http://192.168.31.232/switch/work_room_light_switch/toggle' -X POST`
end

def toggle_room_light2
  `curl 'http://192.168.31.209/switch/work_room_light_switch/toggle' -X POST`
end

def toggle_balcony_light
  `curl -s http://192.168.31.159/toggle`
end

def toggle_bed_fan
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_bed.sh`
end

def toggle_workroom_fan
  `curl 'http://192.168.31.164/switch/sonoff_basic_relay/toggle' -X POST`
end

def toggle_fan_aircon_only
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh fan`
end

def toggle_air_con_olddaikin_26
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh t26OldDaikin`
end

def set_air_con_olddaikin_26
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh 26OldDaikin`
end

def set_air_con_olddaikin_27
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh 27OldDaikin`
end

def set_air_con_olddaikin_28
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh 28OldDaikin`
end

def turn_on_air_con_comfort27
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh 27`
end

def turn_on_air_con_comfort28
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh 28`
end

def turn_on_air_con_comfort29
  `/bin/bash ~/dotfiles/scripts/toggle_air_con.sh 29`
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

def off_media
  `playerctl pause -a`
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
def cmp_suspend

CONTROL_COMMANDS = [
  "Toggle Work Room Light",
  "Toggle Work Room Light 2",
  # "Toggle Balcony Light",
  "Toggle Workroom Fan",
  "Toggle Old Daikin 26",
  "Set Old Daikin 26",
  "Set Old Daikin 27",
  "Set Old Daikin 28",
  # "Toggle Bed (3an)",
  # "Toggle Air Con",
  "Toggle Audio Output",
  # "Enter Room Scenario",
  # "Leave Room Scenario",
  # "Turn on aircon fan only",
  # "Turn on aircon comfort 27",
  # "Turn on aircon comfort 28",
  # "Turn on aircon comfort 29",
  "Turn off screen",
  # "Turn off air con",
  # "Turn off fan",
  "Turn off media",
  # "Go to bed",
  # "Go to desk",
  "Suspend/Sleep CMP machine"
]

CONTROL_FUNC = [
  method(:toggle_room_light),
  method(:toggle_room_light2),
  # method(:toggle_balcony_light),
  method(:toggle_workroom_fan),
  method(:toggle_air_con_olddaikin_26),
  method(:set_air_con_olddaikin_26),
  method(:set_air_con_olddaikin_27),
  method(:set_air_con_olddaikin_28),
  # method(:toggle_bed_fan),
  # method(:toggle_air_con),
  method(:toggle_audio_port),
  # method(:room_enter_scenario),
  # method(:room_leave_scenario),
  # method(:toggle_fan_aircon_only),
  # method(:turn_on_air_con_comfort27),
  # method(:turn_on_air_con_comfort28),
  # method(:turn_on_air_con_comfort29),
  method(:off_screen),
  # method(:off_air_con),
  # method(:off_fan),
  method(:off_media),
  # method(:go_to_bed),
  # method(:go_to_desk),
  method(:cmp_suspend),
]

# FIRST
if ARGV.length != 1
  puts CONTROL_COMMANDS.join("\r\n")
  exit 0
end

`echo #{ARGV[0]} > /tmp/debug`
CONTROL_FUNC[CONTROL_COMMANDS.index(ARGV[0].chomp)].call


