#!/bin/bash

# ref https://askubuntu.com/questions/149054/how-to-change-lcd-brightness-from-command-line-or-via-script

function main_menu
{
    sudo clear
    cursetting=$(cat /sys/class/backlight/intel_backlight/brightness)
    maxsetting=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    powersave=$((maxsetting/6))
    conservative=$((powersave))
    medium=$((powersave*2))
    performance=$((powersave*3))
    echo ""
    echo "----------------------- Brightness -----------------------"
    echo " 1. Set Display to Minimum (Powersave) brightness setting."
    echo " 2. Set Display to Low (Conservative) brightness setting."
    echo " 3. Set Display to Medium brightness setting."
    echo " 4. Set Display to High (Performance) brightness setting."
    echo " 5. Set Display to Maximum brightness setting."
    echo " 6. Exit."
    echo "----------------------------------------------------------"
    if [ $cursetting -eq $powersave ]; then
     cursetting='Minimum'
    else
     if [ $cursetting -eq $conservative ]; then
      cursetting='Conservative'
     else
      if [ $cursetting -eq $medium ]; then
       cursetting='Medium'
      else
       if [ $cursetting -eq $performance ]; then
        cursetting='Performance'
       else
        if [ $cursetting -eq $maxsetting ]; then
         cursetting='Maximum'
        fi
       fi
      fi
     fi
    fi
    echo "        Current Display Setting - "$cursetting;
    choice=7
    echo ""
    echo -e "Please enter your choice: \c"
}

function press_enter
{
    echo ""
    echo -n "Press Enter to continue."
    read
    main_menu
}

main_menu
while [ $choice -eq 7 ]; do
read choice

if [ $choice -eq 1 ]; then
 echo $powersave | sudo tee /sys/class/backlight/intel_backlight/brightness
 main_menu
else
 if [ $choice -eq 2 ]; then
  echo $conservative | sudo tee /sys/class/backlight/intel_backlight/brightness
  main_menu
 else
  if [ $choice -eq 3 ]; then
   echo $medium | sudo tee /sys/class/backlight/intel_backlight/brightness
   main_menu
  else
   if [ $choice -eq 4 ]; then
    echo $performance | sudo tee /sys/class/backlight/intel_backlight/brightness
    main_menu
   else
    if [ $choice -eq 5 ]; then
     echo $maxsetting | sudo tee /sys/class/backlight/intel_backlight/brightness
     main_menu
    else
     if [ $choice -eq 6 ]; then
      exit;
     else
      echo -e "Please enter the NUMBER of your choice: \c"
      choice = 7
     fi
    fi
   fi
  fi
 fi
fi
done
