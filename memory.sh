#!/bin/bash

# Get total and used memory
mem_info=$(free -m | awk '/Mem/ {print $3, $2}')
used=$(echo $mem_info | cut -d' ' -f1)
total=$(echo $mem_info | cut -d' ' -f2)

# Define colors
race_green="#32CD32"  # Race Green color (LimeGreen)
orange="#d79921"      # Orange color (matches Wi-Fi module)

# Set color based on used memory
if [ $used -lt 8192 ]; then
    color="$race_green"  # Race green for less than 8GB
else
    color="#FFA500"  # Dark orange for 8GB or more
fi

# Output formatted text with conditional color for used and fixed color for total
echo "%{F$color}$used MB%{F-} / %{F$orange}$total MB%{F-}"

