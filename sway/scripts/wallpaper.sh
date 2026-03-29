#!/bin/bash
# ── Wallpaper Selector via Wofi ──────────────
# Uses mpvpaper — supports mp4, gif, and static images

WALLPAPER_DIR="$HOME/.config/sway/wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper" "Directory $WALLPAPER_DIR not found"
    exit 1
fi

shopt -s nullglob
files=("$WALLPAPER_DIR"/*.{mp4,gif,png,jpg,jpeg,webp})
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    notify-send "Wallpaper" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

selected=$(printf '%s\n' "${files[@]##*/}" | wofi --show dmenu --prompt "Wallpaper")

if [ -n "$selected" ]; then
    killall mpvpaper 2>/dev/null
    sleep 0.3
    mpvpaper -o "loop" '*' "$WALLPAPER_DIR/$selected" &
    disown
    notify-send "Wallpaper" "Set to $selected"
fi
