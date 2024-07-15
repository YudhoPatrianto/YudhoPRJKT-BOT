#!/bin/bash

# Clear Screen
clear

# Check Curl
check_cURL=$(apt list --installed curl > /dev/null 2>&1)
if [[ ${check_cURL} == *"installed"* ]]; then
echo "cURL Installed Skipping Installing"
else
sudo apt install curl -y > /dev/null 2>&1
fi

# Check jq
check_jq=$(apt list --installed jq > /dev/null 2>&1)
if [[ ${check_jq} == *"installed"* ]]; then
echo "jq Installed Skipping Installing"
else
sudo apt install jq -y > /dev/null 2>&1
fi

# Create Folder
mkdir $(echo $(pwd)/.secret)

# Create .access_list
if [[ $(ls -l $(echo $(pwd)/.secret/.access_list) == *".access_list"* ) ]]; then
true
else
read -p "Input Your User ID In Telegram: " read_userid
echo ${read_userid} > $HOME/YudhoPRJKT-BOT/.secret/.access_list
fi