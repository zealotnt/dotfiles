#!/bin/sh

# to restore, read from this
# https://github.com/linuxmint/Cinnamon/wiki/Backing-up-and-restoring-your-cinnamon-settings-(dconf)
dconf dump / > dconf.dump.conf
# or (untested)
# dconf load / < dconf.dump.conf
