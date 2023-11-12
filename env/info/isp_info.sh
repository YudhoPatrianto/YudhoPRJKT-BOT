#!/usr/bin/env bash


echo 🌐ISP Name: $(whois 117.20.48.16 | grep -E "netname|descr" | awk -F': ' '{print $2}' | head -n 1)