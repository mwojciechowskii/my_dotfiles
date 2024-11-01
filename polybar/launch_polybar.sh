#!/bin/bash

# Log output for debugging
LOGFILE="$HOME/.config/polybar/polybar.log"

MAX_LINES=250

# Trim the log file if it exceeds the maximum number of lines
if [ $(wc -l < "$LOGFILE") -gt $MAX_LINES ]; then
  # Keep only the last MAX_LINES lines
  tail -n $MAX_LINES "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"
fi

# Output the current date and time and log the Polybar launch
echo "$(date +"%Y-%m-%d %H:%M:%S") Launching Polybar..." | tee -a $LOGFILE

# Path to your Polybar configuration file
CONFIG="$HOME/.config/polybar/config.ini"

# Terminate already running Polybar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar using the "toph" bar and config file
if type "xrandr" > /dev/null 2>&1; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload --config=$CONFIG toph >> $LOGFILE 2>&1 &
  done
else
  polybar --reload --config=$CONFIG toph >> $LOGFILE 2>&1 &
fi

echo "Polybar launched on all monitors" | tee -a $LOGFILE

