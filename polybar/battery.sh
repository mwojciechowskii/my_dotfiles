#!/bin/bash
# battery.sh - Replicates internal battery module functionality
# Requires: acpi

# Get battery information (adjust the grep/awk as needed for your system)
battery_info=$(acpi -b)
if [ -z "$battery_info" ]; then
    echo "N/A"
    exit 0
fi

# Extract battery percentage
percentage=$(echo "$battery_info" | grep -oP '\d+(?=%)' | head -1)
percentage=${percentage:-0}

# Choose icon based on percentage (in 20% increments)
if [ "$percentage" -le 20 ]; then
    icon=""
    label="BATTERY LOW ($percentage%)"
    color="#A54242"  # Red for low battery
elif [ "$percentage" -le 40 ]; then
    icon=""
    label="$percentage%"
    color="#5294e2"
elif [ "$percentage" -le 60 ]; then
    icon=""
    label="$percentage%"
    color="#5294e2"
elif [ "$percentage" -le 80 ]; then
    icon=""
    label="$percentage%"
    color="#5294e2"
else
    icon=""
    label="$percentage%"
    color="#5294e2"
fi

# Output using Font Awesome (assumed to be loaded as font-1)
# The %{T1} and %{T-} tokens switch to and from the Font Awesome font.
echo "%{T1}$icon%{T-} %{F$color}$label%{F-}"
