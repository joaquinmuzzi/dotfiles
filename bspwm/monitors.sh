#!/usr/bin/env bash

if xrandr | grep -q "HDMI-1 connected"; then
    xrandr --output eDP-1 --mode 1920x1080 --output HDMI-1 --same-as eDP-1 --auto
    bspc monitor HDMI-1 -r 2>/dev/null
else
    bspc monitor HDMI-1 -r 2>/dev/null
    xrandr --output eDP-1 --auto
fi

bspc monitor eDP-1 -d I II III IV V VI VII VIII IX X

$HOME/.config/polybar/launch.sh &

feh --bg-fill ~/wallpapers/machinarium-wallpaper.jpg
