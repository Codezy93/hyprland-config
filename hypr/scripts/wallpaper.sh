#!/bin/bash
# ── Wallpaper Selector via Wofi ──────────────

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper" "Directory $WALLPAPER_DIR not found"
    exit 1
fi

shopt -s nullglob
images=("$WALLPAPER_DIR"/*.{png,jpg,jpeg,webp,gif})
shopt -u nullglob

if [ ${#images[@]} -eq 0 ]; then
    notify-send "Wallpaper" "No images found in $WALLPAPER_DIR"
    exit 1
fi

selected=$(printf '%s\n' "${images[@]##*/}" | wofi --show dmenu --prompt "Wallpaper")

if [ -n "$selected" ]; then
    swww img "$WALLPAPER_DIR/$selected" \
        --transition-type fade \
        --transition-duration 2 \
        --transition-fps 60
    notify-send "Wallpaper" "Set to $selected"
fi
