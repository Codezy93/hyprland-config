#!/bin/bash
# ── Keyboard Shortcuts Cheatsheet ────────────

cat <<'KEYS' | wofi --show dmenu --prompt "⌨ Shortcuts" --width 520 --height 580
──── Quick Launch ────
⌘ + Return           Terminal (Kitty)
⌘ + Space            Launcher (Wofi)
⌘ + E                Files (Thunar)
⌘ + V                Clipboard History
⌘ + /                This Cheatsheet

──── Screenshots ────
⌘ + Shift + S        Area Screenshot
⌘ + Shift + 3        Full Screenshot
⌘ + Shift + 4        Area Screenshot

──── Recording ────
⌘ + Shift + R        Toggle Screen Recording

──── Windows ────
⌘ + Q                Close Window
⌘ + F                Fullscreen
⌘ + T                Float/Tile Toggle
⌘ + P                Cycle Layout
⌘ + J                Toggle Split
⌘ + R                Resize Mode

──── Focus ────
⌘ + ←/→/↑/↓         Move Focus
⌘ + H/L/K/J         Move Focus (Vim)
Alt + Tab             Cycle Windows

──── Move ────
⌘ + Shift + ←/→      Move Window
⌘ + Shift + H/L/K/J  Move Window (Vim)
⌘ + Mouse L          Drag Move
⌘ + Mouse R          Drag Resize

──── Resize Mode ────
←/→/↑/↓ or H/L/K/J  Resize Window
Escape / Return      Exit Resize Mode

──── Workspaces ────
⌘ + 1  Terminal      ⌘ + 6  WS 6
⌘ + 2  WS 2          ⌘ + 7  WS 7
⌘ + 3  WS 3          ⌘ + 8  WS 8
⌘ + 4  WS 4          ⌘ + 9  WS 9
⌘ + 5  WS 5          ⌘ + 0  Extra
⌘ + Shift + 1-0      Move to Workspace
⌘ + S                Scratchpad Toggle
⌘ + Alt + S          Move to Scratchpad

──── System ────
⌘ + D                Dark/Light Toggle
⌘ + W                Wallpaper Picker
⌘ + N                Notifications Toggle
⌘ + X                Power Menu
⌘ + Ctrl + L         Lock Screen
⌘ + Shift + Q        Exit Sway
KEYS
