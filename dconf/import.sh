#!/bin/bash

if (dialog --title "Message" --yesno "This gonna overwrite machine's dconf, are you sure ?" 5 60)
# message box will have the size 25x6 characters
then
  dconf load / < dconf.dump.conf
fi
