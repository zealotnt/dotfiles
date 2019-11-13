#!/usr/bin/env ruby
require 'pry-byebug'

SCRIPT_PATH = File.expand_path(File.dirname(__FILE__))
BLACK_LIST_IDX = [1,2,3,4,6,7,9]

def all_apps
  apps = `gsettings get org.gnome.shell favorite-apps`
  all_apps = apps.
               gsub("]", '').
               gsub("['", '').
               gsub("'",'').
               gsub("\n", '').
               gsub(' ', '').
               split(',')
  all_apps
end

def print_debug(choice)
  `echo #{choice} > res.res`
end

def set_gnome_apps(apps)
  apps.map()
  apps.join(", ")
  `gsettings set org.gnome.shell favorite-apps \'#{apps}\'`
end

def swap_app(choice, cur_app_idx)
  # get index of favorite apps
  apps = all_apps
  choose_idx = apps.find_index(choice)

  # swap it with cur_app_idx app
  apps[choose_idx], apps[cur_app_idx] = apps[cur_app_idx], apps[choose_idx]
  set_gnome_apps(apps)
  exit 0
end

def check_arg(arg)
  res = arg.match(/Slot (\d).*/)
  if !res.nil? && res.size == 2
    return 0, res[1]
  end

  return 1, arg
end

def choose_slot
  apps = all_apps[0..10]
  str = ""
  10.times do |idx|
    if BLACK_LIST_IDX.include? idx+1
      next
    end
    str += "Slot #{idx+1}: #{apps[idx]}\r\n"
  end
  str
end

if ARGV.length != 1
  puts choose_slot
  exit 0
end

argType, argVal = check_arg(ARGV[0])

case argType
when 0
  File.write(SCRIPT_PATH + '/choice.res', argVal.to_i-1)
  apps = all_apps
  apps = apps.select.with_index {|app, idx| !BLACK_LIST_IDX.include? idx+1 }
  puts apps
  exit 0
when 1
  cur_pos = File.read(__dir__ + '/choice.res')
  swap_app(argVal, cur_pos.to_i)
  exit 0
else
  exit 1
end

