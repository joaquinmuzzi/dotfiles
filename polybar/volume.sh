#!/bin/sh

RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

if echo "$RAW" | grep -q "MUTED"; then
	echo "muted"
else
	VOL=$(echo "$RAW" | awk '{print int($2*100)}')
	echo "$VOL%"
fi

