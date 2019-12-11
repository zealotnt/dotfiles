#!/bin/bash

for f in *.service
do
  ./install_service.sh $f
done
