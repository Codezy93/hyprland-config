#!/bin/bash
# ── Wallpaper Selector via Wofi ──────────────
# Uses swaybg for static images (png, jpg, webp)

WALLPAPER_DIR="$HOME/.config/sway/wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper" "Directory $WALLPAPER_DIR not found"
    exit 1
fi

shopt -s nullglob
images=("$WALLPAPER_DIR"/*.{png,jpg,jpeg,webp,bmp})
shopt -u nullglob

if [ ${#images[@]} -eq 0 ]; then
    notify-send "Wallpaper" "No images found in $WALLPAPER_DIR"
    exit 1
fi

selected=$(printf '%s\n' "${images[@]##*/}" | wofi --show dmenu --prompt "Wallpaper")

if [ -n "$selected" ]; then
    killall swaybg 2>/dev/null
    sleep 0.3
    swaybg -i "$WALLPAPER_DIR/$selected" -m fill &
    disown
    notify-send "Wallpaper" "Set to $selected"
fi
