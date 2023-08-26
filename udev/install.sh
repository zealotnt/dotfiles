#!/bin/bash

CUR_DIR=$(realpath `dirname $0`)

sudo cp ./${CUR_DIR}/*.rules /etc/udev/rules.d


