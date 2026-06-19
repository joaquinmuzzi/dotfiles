#!/usr/bin/env bash

BATTERY_PATH="/sys/class/power_supply/BAT0"
STATE_FILE="/tmp/battery_alert_10_sent"
CHECK_INTERVAL=30

send_alert() {
  local percentage="$1"
  local title="Batería crítica: ${percentage}%"

  if command -v dunstify >/dev/null 2>&1; then
    dunstify \
      -a "battery-alert" \
      -u critical \
      -r 9910 \
      -i battery-caution \
      "$title" \
      "$body"
  else
    notify-send \
      -a "battery-alert" \
      -u critical \
      -i battery-caution \
      "$title" \
      "Conectá el cargador."
  fi
}

while true; do
  if [ -d "$BATTERY_PATH" ]; then
    status="$(cat "$BATTERY_PATH/status" 2>/dev/null)"
    capacity="$(cat "$BATTERY_PATH/capacity" 2>/dev/null)"

    if [ "$status" = "Discharging" ] && [ -n "$capacity" ] && [ "$capacity" -le 10 ]; then
      if [ ! -f "$STATE_FILE" ]; then
        send_alert "$capacity"
        touch "$STATE_FILE"
      fi
    fi

    if [ "$status" != "Discharging" ] || { [ -n "$capacity" ] && [ "$capacity" -ge 15 ]; }; then
      rm -f "$STATE_FILE"
    fi
  fi

  sleep "$CHECK_INTERVAL"
done
