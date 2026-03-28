#!/bin/bash
# ── Dunst Status for Waybar ──────────────────

paused=$(dunstctl is-paused)

if [ "$paused" == "true" ]; then
    echo '{"text": "󰂛", "tooltip": "Notifications paused", "class": "paused"}'
else
    count=$(dunstctl count waiting)
    if [ "$count" -gt 0 ]; then
        echo "{\"text\": \"󰂚 $count\", \"tooltip\": \"$count notifications\", \"class\": \"active\"}"
    else
        echo '{"text": "󰂜", "tooltip": "Notifications on", "class": "none"}'
    fi
fi
