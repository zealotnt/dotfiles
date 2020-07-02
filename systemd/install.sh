#!/bin/bash

for f in *.service
do
  printf '*%.0s' {1..100}
  echo
  echo -e "\t\t\t${ANSI_LRED}Installing $f${ANSI_NRM}"
  ./install_service.sh $f
  printf '*%.0s' {1..100}
  echo
done
