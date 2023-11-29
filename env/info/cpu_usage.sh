#!/usr/bin/env bash

top -bn1 | grep "Cpu(s)" | awk '{print "📊CPU Usage: " $2 "%"}'