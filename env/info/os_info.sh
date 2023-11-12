#!/usr/bin/env bash

echo 🖥OS Version: $(lsb_release -a 2>/dev/null | awk '/Description/ {print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}')