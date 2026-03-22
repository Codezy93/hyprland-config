#!/bin/bash
# ── Keyboard Shortcuts Cheatsheet ────────────

cat <<'KEYS' | wofi --show dmenu --prompt "⌨ Shortcuts" --width 520 --height 650
──── Quick Launch ────
⌘ + Return           Terminal (Kitty)
⌘ + Space            Launcher (Wofi)
⌘ + B                Brave Browser
⌘ + E                Files (Thunar)
⌘ + V                Clipboard History
⌘ + /                This Cheatsheet

──── App Launchers (⌘+Alt) ────
⌘ + Alt + C          Cursor
⌘ + Alt + O          Obsidian
⌘ + Alt + S          Spotify
⌘ + Alt + T          Thunderbird
⌘ + Alt + P          Postman
⌘ + Alt + D          Docker Desktop
⌘ + Alt + B          Bitwarden
⌘ + Alt + Q          Qalculate
⌘ + Alt + M          MongoDB Compass
⌘ + Alt + G          Google Chrome

──── Screenshots ────
⌘ + Shift + S        Area Screenshot
⌘ + Shift + 3        Full Screenshot
⌘ + Shift + 4        Area Screenshot

──── Windows ────
⌘ + Q                Close Window
⌘ + F                Fullscreen
⌘ + M                Maximize
⌘ + T                Float/Tile Toggle
⌘ + C                Center Window
⌘ + P                Pseudo Tile
⌘ + J                Toggle Split

──── Focus ────
⌘ + ←/→/↑/↓         Move Focus
⌘ + H/L/K/J         Move Focus (Vim)
Alt + Tab             Cycle Windows

──── Move ────
⌘ + Shift + ←/→      Move Window
⌘ + Shift + H/L/K/J  Move Window (Vim)
⌘ + Mouse L          Drag Move
⌘ + Mouse R          Drag Resize

──── Resize ────
⌘ + Ctrl + ←/→/↑/↓  Resize Window

──── Workspaces ────
⌘ + 1  Terminal      ⌘ + 6  Docker
⌘ + 2  Code          ⌘ + 7  Notes
⌘ + 3  Browser       ⌘ + 8  Music
⌘ + 4  Email         ⌘ + 9  Misc
⌘ + 5  Database      ⌘ + 0  Extra
⌘ + Shift + 1-0      Move to Workspace
⌘ + S                Scratchpad

──── System ────
⌘ + D                Dark/Light Toggle
⌘ + W                Wallpaper Picker
⌘ + N                Notifications Toggle
⌘ + X                Power Menu
⌘ + Shift + Q        Exit Hyprland
KEYS
