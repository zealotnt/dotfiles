#!/usr/bin/env ruby

require 'pry-byebug'

# to debug, just type `xwininfo`, then select the window by mouse
# the info will be printed, then we will have id of windows from the result
activeWindowInfo = `xwininfo -id $(xdotool getactivewindow)`

# not so useful, deprecated
# winPosStr = activeWindowInfo.match(/\-geometry (.*)/)[1]
# res = winPosStr.match(/(\d+)x(\d+)[\+\-](\d+)[\+\-](\d+)/)
# sizeX, sizeY = res[1], res[2]

winPosStr = activeWindowInfo.match /Corners:\s+\+(\d+)\+(\d+)\s+.*/
sizeX = activeWindowInfo.match(/Width: (\d+)/)[1]
sizeY = activeWindowInfo.match(/Height: (\d+)/)[1]

posX, posY = winPosStr[1], winPosStr[2]
centerPointX = posX.to_i+sizeX.to_i/2
centerPointY = posY.to_i+sizeY.to_i/2

`xdotool mousemove #{centerPointX} #{centerPointY}`
`find-cursor -s 200 -d 25 -l 2 -w 200 -g -c blue`
