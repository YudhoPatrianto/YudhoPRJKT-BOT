#!/usr/bin/env bash

echo "⚙️CPU Model: $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)"
