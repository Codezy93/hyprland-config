#!/bin/bash
# ── Weather Module for Waybar ────────────────
# Set your city via WEATHER_CITY env var or edit below

CITY="${WEATHER_CITY:-}"  # e.g. export WEATHER_CITY="London"

if [ -z "$CITY" ]; then
    echo '{"text": " N/A", "tooltip": "Set WEATHER_CITY env var in your shell profile"}'
    exit 0
fi

weather=$(curl -s --max-time 5 "wttr.in/${CITY}?format=%c%t" 2>/dev/null)
tooltip=$(curl -s --max-time 5 "wttr.in/${CITY}?format=%l:+%c+%C+%t+%w+%h" 2>/dev/null)

if [ -n "$weather" ] && [ "$weather" != "Unknown" ]; then
    echo "{\"text\": \"$weather\", \"tooltip\": \"$tooltip\"}"
else
    echo "{\"text\": \" N/A\", \"tooltip\": \"Weather unavailable\"}"
fi
