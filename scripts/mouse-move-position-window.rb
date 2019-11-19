#!/usr/bin/env ruby
# ref: https://unix.stackexchange.com/questions/14159/how-do-i-find-the-window-dimensions-and-position-accurately-including-decoration

# require 'pry-byebug'

# 123
# 456
# 789
def calculate_point(pos)
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

  # binding.pry
  step=0.25
  mappings = [[-step,-step],        #1
              [0,-step],            #2
              [step,-step],         #3
              [-step,0],            #4
              [0,0],                #5
              [step,0],             #6
              [-step,step],         #7
              [0,step],             #8
              [step,step]]          #9
  posX, posY = winPosStr[1], winPosStr[2]

  centerPointX = posX.to_i+sizeX.to_i/2
  centerPointY = posY.to_i+sizeY.to_i/2

  if pos == 4
    centerPointX = posX.to_i+sizeX.to_i/2
    centerPointY = posY.to_i+sizeY.to_i/2
    return centerPointX, centerPointY
  else
    # binding.pry
    rangeX = centerPointX + sizeX.to_i*mappings[pos][0]
    rangeY = centerPointY + sizeY.to_i*mappings[pos][1]
    return rangeX, rangeY
  end
end

if ARGV.length != 1
  pointX, pointY = calculate_point(5)
else
  pointX, pointY = calculate_point(ARGV[0].to_i-1)
end

`xdotool mousemove #{pointX} #{pointY}`
`find-cursor -s 200 -d 25 -l 2 -w 200 -g -c blue`
