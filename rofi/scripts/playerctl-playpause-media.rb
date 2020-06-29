#!/usr/bin/env ruby
# require 'pry-byebug'

def parse_app(choice)
  app = choice.match(/\d+: ([\.\w]+) - .*/)
  if !app.nil? && app.size == 2
    return app[1]
  else
    puts "Cant parse input #{app.size}"
    exit 1
  end
end

if ARGV.length != 1
  # first invoke
  # byebug
  list_media = `playerctl -l`
  list_media_arr = list_media.split("\n")
  status_media = `playerctl status -a`
  status_media_arr = status_media.split("\n")
  if status_media_arr.count("Playing") == 1
    media = list_media_arr[status_media_arr.index("Playing")]
    `playerctl play-pause -p #{media}`
    puts "Just toggle #{media} to Paused"
    exit 0
  else
    ret = ""
    list_media.split("\n").each_with_index do |media, idx|
      ret += "#{idx+1}: #{media} - #{status_media_arr[idx]}\n"
    end
    puts ret
    exit 0
  end
else
  # after choose a player, toggle it
  app = parse_app(ARGV[0])
  `playerctl play-pause -p #{app}`
  exit 0
end

