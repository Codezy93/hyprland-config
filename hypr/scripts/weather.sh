#!/bin/bash
# ── Weather Module for Waybar ────────────────
# Uses wttr.in — set your city below

CITY="Mumbai"  # Change to your city

weather=$(curl -s "wttr.in/${CITY}?format=%c%t" 2>/dev/null)
tooltip=$(curl -s "wttr.in/${CITY}?format=%l:+%c+%C+%t+%w+%h" 2>/dev/null)

if [ -n "$weather" ] && [ "$weather" != "Unknown" ]; then
    echo "{\"text\": \"$weather\", \"tooltip\": \"$tooltip\"}"
else
    echo "{\"text\": \"N/A\", \"tooltip\": \"Weather unavailable\"}"
fi
