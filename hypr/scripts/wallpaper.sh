#!/bin/bash
# ── Wallpaper Selector via Wofi ──────────────

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper" "Directory $WALLPAPER_DIR not found"
    exit 1
fi

shopt -s nullglob
videos=("$WALLPAPER_DIR"/*.{mp4,gif})
shopt -u nullglob

if [ ${#videos[@]} -eq 0 ]; then
    notify-send "Wallpaper" "No videos found in $WALLPAPER_DIR"
    exit 1
fi

selected=$(printf '%s\n' "${videos[@]##*/}" | wofi --show dmenu --prompt "Wallpaper")

if [ -n "$selected" ]; then
    killall mpvpaper 2>/dev/null
    sleep 0.5
    mpvpaper -o "loop" '*' "$WALLPAPER_DIR/$selected" &
    notify-send "Wallpaper" "Set to $selected"
fi
