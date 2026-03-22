#!/bin/bash
# ── Wallpaper Selector via Wofi ──────────────

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper" "Directory $WALLPAPER_DIR not found"
    exit 1
fi

selected=$(ls "$WALLPAPER_DIR" | wofi --show dmenu --prompt "Wallpaper")

if [ -n "$selected" ]; then
    swww img "$WALLPAPER_DIR/$selected" \
        --transition-type fade \
        --transition-duration 2 \
        --transition-fps 60
    notify-send "Wallpaper" "Set to $selected"
fi
