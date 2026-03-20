#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 0.2; done

# Launch bar1
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar -c "$HOME/.config/polybar/config.ini" bar1 2>&1 | tee -a /tmp/polybar1.log & disown

echo "Bars launched..."
