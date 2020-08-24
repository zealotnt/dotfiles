#!/usr/bin/env ruby
# require 'pry-byebug'

def toggle_room_light
  `curl -s http://192.168.31.232/toggle`
end

def toggle_balcony_light
  `curl -s http://192.168.31.159/toggle`
end

def toggle_fan
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_fan.sh`
end

def toggle_air_con
  `/bin/bash /home/zealot/dotfiles/scripts/toggle_air_con.sh`
end

CONTROL_COMMANDS = [
  "Toggle Room Light",
  "Toggle Balcony Light",
  "Toggle Fan",
  "Toggle Air Con",
]

CONTROL_FUNC = [
  method(:toggle_room_light),
  method(:toggle_balcony_light),
  method(:toggle_fan),
  method(:toggle_air_con),
]

# FIRST
if ARGV.length != 1
  puts CONTROL_COMMANDS.join("\r\n")
  exit 0
end

`echo #{ARGV[0]} > /tmp/debug`
CONTROL_FUNC[CONTROL_COMMANDS.index(ARGV[0].chomp)].call


