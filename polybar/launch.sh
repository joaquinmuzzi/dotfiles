#!/usr/bin/env bash

killall -q polybar 2>/dev/null
while pgrep -x polybar >/dev/null; do sleep 0.2; done

export MONITOR=eDP-1
polybar -c "$HOME/.config/polybar/config.ini" bar1 >/dev/null 2>&1 &

echo "Bars launched..."
