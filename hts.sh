#!/bin/bash

hts=$1

systemctl stop $1
apt-get remove --purge $1 -y
aptget autoremove -y
sudo find / -name '*$1*' -exec rm -rf {} +
sudo delgroup $1
