#!/usr/bin/env ruby
require 'pry-byebug'

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

def choose_apps(choice)
  # get index of favorite apps
  apps = all_apps
  choose_idx = apps.find_index(choice)

  # swap it with 10th app
  apps[choose_idx], apps[9] = apps[9], apps[choose_idx]
  set_gnome_apps(apps)
  exit 0
end

if ARGV.length != 1
  unsorted_apps = all_apps[9..all_apps.size]
  puts unsorted_apps
  exit 0
end

choose_apps(ARGV[0])

