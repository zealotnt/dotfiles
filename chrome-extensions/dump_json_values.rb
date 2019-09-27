#!/usr/bin/env ruby

require 'json'
require 'colorize'

a = File.read('wasavi.json')
b = JSON.parse(a)

b.each do |k, v|
  puts "\r\n#{k}".red.bold
  puts v.gsub(/\\n/, "\r\n").
         gsub("\\\"", '"').
         gsub(/^\"/, '').
         gsub(/\"$/, '')
end
