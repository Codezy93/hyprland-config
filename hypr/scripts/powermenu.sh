#!/bin/bash
# ── Power Menu via Wofi ──────────────────────

entries="󰌾 Lock\n󰍃 Logout\n󰤄 Suspend\n󰜉 Reboot\n⏻ Shutdown"

selected=$(echo -e "$entries" | wofi --show dmenu --prompt "Power" --width 250 --height 300)

case "$selected" in
    "󰌾 Lock")
        hyprlock ;;
    "󰍃 Logout")
        hyprctl dispatch exit ;;
    "󰤄 Suspend")
        loginctl suspend ;;
    "󰜉 Reboot")
        loginctl reboot ;;
    "⏻ Shutdown")
        loginctl poweroff ;;
esac
