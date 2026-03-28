#!/bin/bash
# ── Power Menu via Wofi ──────────────────────

entries="󰌾 Lock\n󰍃 Logout\n󰤄 Suspend\n󰜉 Reboot\n⏻ Shutdown"

selected=$(echo -e "$entries" | wofi --show dmenu --prompt "Power" --width 250 --height 300)

case "$selected" in
    "󰌾 Lock")
        swaylock -C ~/.config/sway/swaylock.conf ;;
    "󰍃 Logout")
        swaymsg exit ;;
    "󰤄 Suspend")
        systemctl suspend ;;
    "󰜉 Reboot")
        systemctl reboot ;;
    "⏻ Shutdown")
        systemctl poweroff ;;
esac
