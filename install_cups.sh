#!/bin/bash

# install deps
sudo apt install cups
sudo usermod -a -G lpadmin $(USER)
sudo apt-get install printer-driver-brlaser
sudo service cups restart

# config
cupsctl --share-printers --remote-any

# print info of local printers
lpstat -l -e