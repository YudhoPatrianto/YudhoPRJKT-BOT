#!/bin/bash

# Get total disk space in kilobytes
total_disk_kb=$(df -k --total | awk '/total/ {print $2}')

# Convert kilobytes to gigabytes
total_disk_gb=$(awk "BEGIN {printf \"%.2f\n\", $total_disk_kb / 1024 / 1024}")

# Print the total disk space in GB
echo "💾Total Disk Space: $total_disk_gb GB"
