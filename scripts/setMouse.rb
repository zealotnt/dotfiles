#!/usr/bin/env ruby
# coding: utf-8

# require 'pry-byebug'

input_dev = /ROCCAT/u

def get_rgx(device_regex)
  rgx = Regexp.new(/^.*↳\s.*/u.source + device_regex.source + /.*id=(\d+).*$/u.source)
end

def get_device_id(device_regex)
  res = `xinput list | grep Mouse`
  res = res.match(get_rgx(device_regex))
  (!res.nil? and res.size == 2) ? res[1] : -1
end

dev_id = get_device_id(input_dev)

def usage
  "Not have docs yet, please read the code"
end

if ARGV.length != 1
  puts usage
  exit 0
end

if dev_id == -1
  puts "Cant find device /#{input_dev.source}/, exit..."
  exit 0
end

case ARGV[0]
when 'e'
  `xinput --set-prop #{dev_id} "Device Enabled" 1`
when 'd'
  `xinput --set-prop #{dev_id} "Device Enabled" 0`
else
  puts "Invalid argument: #{ARGV[0]}"
  usage
end

