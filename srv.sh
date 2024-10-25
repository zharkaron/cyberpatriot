#!/bin/bash

service=$1

systemctl stop $1 > /dev/null 2>&1
systemctl disable $1 > /dev/null 2>&1
systemctl mask $1 > /dev/null 2>&1
echo "$1 has been disabled"
