#!/bin/bash

PWD=$(dirname "$BASH_SOURCE")
sudo cp -rp $PWD/etc/apt/* /etc/apt/

