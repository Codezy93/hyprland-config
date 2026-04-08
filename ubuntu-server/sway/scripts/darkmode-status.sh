#!/bin/bash
# ── Dark Mode Status for Waybar ──────────────

STATE_FILE="$HOME/.config/sway/.theme-mode"

if [ -f "$STATE_FILE" ]; then
    MODE=$(cat "$STATE_FILE")
else
    MODE="dark"
fi

if [ "$MODE" = "light" ]; then
    echo '{"text": "󰖙", "tooltip": "Light mode — click to toggle", "class": "light"}'
else
    echo '{"text": "󰖔", "tooltip": "Dark mode — click to toggle", "class": "dark"}'
fi
