#!/bin/sh

dconf dump / > dconf.dump.conf
gsettings list-recursively > gsettings.list-recursively.conf

