#!/bin/bash
# ── Dunst Status for Waybar ──────────────────

paused=$(dunstctl is-paused)

if [ "$paused" == "true" ]; then
    echo '{"text": "󰂛", "tooltip": "Notifications paused", "class": "paused"}'
else
    count=$(dunstctl count waiting 2>/dev/null)
    if [ "${count:-0}" -gt 0 ] 2>/dev/null; then
        echo "{\"text\": \"󰂚 $count\", \"tooltip\": \"$count notifications\", \"class\": \"active\"}"
    else
        echo '{"text": "󰂜", "tooltip": "Notifications on", "class": "none"}'
    fi
fi
