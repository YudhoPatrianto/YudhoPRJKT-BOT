#!/bin/bash

# Get total memory in kilobytes
total_memory_kb=$(free -k | awk '/^Mem:/ {print $2}')

# Convert kilobytes to gigabytes
total_memory_gb=$(awk "BEGIN {printf \"%.2f\n\", $total_memory_kb / 1024 / 1024}")

# Print the total memory in GB
echo "💾Total Memory: $total_memory_gb GB"