#!/usr/bin/env bash

# Insert Your Public IP 
IP=

echo 🌐ISP Name: $(whois $IP | grep -E "NetName|netname|descr" | awk -F': ' '{print $2}' | head -n 1)