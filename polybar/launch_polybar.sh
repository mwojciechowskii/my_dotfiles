#!/bin/bash

LOGFILE="$HOME/.config/polybar/polybar.log"
MAX_LINES=250

# Trim the log file if needed
if [ -f "$LOGFILE" ] && [ $(wc -l < "$LOGFILE") -gt $MAX_LINES ]; then
  tail -n $MAX_LINES "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"
fi

echo "$(date +"%Y-%m-%d %H:%M:%S") Launching Polybar..." | tee -a "$LOGFILE"

CONFIG="$HOME/.config/polybar/config.ini"
BAR="toph"

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr" > /dev/null 2>&1; then
  # List all connected monitors
  MONITORS=($(xrandr --query | grep " connected" | cut -d" " -f1))

  # Find external monitor (not eDP-1 or LVDS-1)
  TRAY_MONITOR=""
  for m in "${MONITORS[@]}"; do
    if [[ "$m" != "eDP-1" && "$m" != "LVDS-1" ]]; then
      TRAY_MONITOR="$m"
      break
    fi
  done

  # Fallback to first monitor if no external detected
  [ -z "$TRAY_MONITOR" ] && TRAY_MONITOR="${MONITORS[0]}"

  # Launch Polybar with tray on external monitor first
  MONITOR="$TRAY_MONITOR" polybar --reload --config="$CONFIG" "$BAR" >> "$LOGFILE" 2>&1 &

  # Launch Polybar on all other monitors
  for m in "${MONITORS[@]}"; do
    if [ "$m" != "$TRAY_MONITOR" ]; then
      MONITOR="$m" polybar --reload --config="$CONFIG" "$BAR" >> "$LOGFILE" 2>&1 &
    fi
  done
else
  polybar --reload --config="$CONFIG" "$BAR" >> "$LOGFILE" 2>&1 &
fi

echo "Polybar launched on all monitors, tray on $TRAY_MONITOR" | tee -a "$LOGFILE"
