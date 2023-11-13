#!/usr/bin/env bash

sudo apt-get install dos2unix -y > /dev/null 2>&1

dos2unix $(ls $PWD/env/info/uptime_info.sh) 

bash $(ls $PWD/env/info/uptime_info.sh)