#!/bin/bash
# ── Dark/Light Mode Toggle ───────────────────
# Toggles between Dusk Garden dark and light themes

STATE_FILE="$HOME/.config/hypr/.theme-mode"
HYPR_THEME="$HOME/.config/hypr/themes/colors.conf"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
DUNST_CONF="$HOME/.config/dunst/dunstrc"

# Read current state
if [ -f "$STATE_FILE" ]; then
    MODE=$(cat "$STATE_FILE")
else
    MODE="dark"
fi

if [ "$MODE" = "dark" ]; then
    # ── Switch to Light ──────────────────────
    NEW_MODE="light"

    # Hyprland colors
    cat > "$HYPR_THEME" << 'EOF'
$fg       = rgba(1E1B23ee)
$fg_solid = rgba(1E1B23ff)
$rose     = rgba(9E6B7Aee)
$cream    = rgba(D4A84Bee)
$mint     = rgba(5BAB9Fee)
$neon     = rgba(5BAB9Fff)
$plum     = rgba(5D576Bee)
$bg       = rgba(F5F2F0ee)
$bg_alt   = rgba(E8E4E1ee)
$surface  = rgba(DDD9D5ee)
$border   = rgba(D1CCC8ee)
$muted    = rgba(8A8494ee)
EOF

    # Hyprland border colors
    hyprctl keyword general:col.active_border "rgba(9E6B7Aee) rgba(5BAB9Fee) 45deg"
    hyprctl keyword general:col.inactive_border "rgba(D1CCC8ee)"
    hyprctl keyword decoration:shadow:color "rgba(1E1B2322)"

    # GTK theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita' 2>/dev/null

    # Kitty
    kitty @ set-colors --all \
        foreground=#1E1B23 \
        background=#F5F2F0 \
        selection_foreground=#F5F2F0 \
        selection_background=#9E6B7A \
        color0=#E8E4E1 \
        color8=#D1CCC8 \
        color1=#9E6B7A \
        color9=#B48291 \
        color2=#5BAB9F \
        color10=#99E1D9 \
        color3=#D4A84B \
        color11=#FFFAE3 \
        color4=#5D576B \
        color12=#7A7389 \
        color5=#9E6B7A \
        color13=#B48291 \
        color6=#5BAB9F \
        color14=#99E1D9 \
        color7=#1E1B23 \
        color15=#111015 2>/dev/null

    notify-send -u low "Theme" "Switched to Light Mode ☀"
else
    # ── Switch to Dark ───────────────────────
    NEW_MODE="dark"

    # Hyprland colors
    cat > "$HYPR_THEME" << 'EOF'
$fg       = rgba(FCFCFCee)
$fg_solid = rgba(FCFCFCff)
$rose     = rgba(B48291ee)
$cream    = rgba(FFFAE3ee)
$mint     = rgba(99E1D9ee)
$neon     = rgba(99E1D9ff)
$plum     = rgba(5D576Bee)
$bg       = rgba(1E1B23ee)
$bg_alt   = rgba(2A2631ee)
$surface  = rgba(312C3Bee)
$border   = rgba(3D3847ee)
$muted    = rgba(8A8494ee)
EOF

    # Hyprland border colors
    hyprctl keyword general:col.active_border "rgba(B48291ee) rgba(99E1D9ee) 45deg"
    hyprctl keyword general:col.inactive_border "rgba(3D3847ee)"
    hyprctl keyword decoration:shadow:color "rgba(1E1B23ee)"

    # GTK theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita:dark' 2>/dev/null

    # Kitty
    kitty @ set-colors --all \
        foreground=#FCFCFC \
        background=#1E1B23 \
        selection_foreground=#1E1B23 \
        selection_background=#B48291 \
        color0=#1E1B23 \
        color8=#3D3847 \
        color1=#B48291 \
        color9=#C99AA8 \
        color2=#99E1D9 \
        color10=#B3EBE5 \
        color3=#FFFAE3 \
        color11=#FFFDF0 \
        color4=#5D576B \
        color12=#7A7389 \
        color5=#B48291 \
        color13=#C99AA8 \
        color6=#99E1D9 \
        color14=#B3EBE5 \
        color7=#FCFCFC \
        color15=#FFFFFF 2>/dev/null

    notify-send -u low "Theme" "Switched to Dark Mode 🌙"
fi

# Save state
echo "$NEW_MODE" > "$STATE_FILE"

# Reload waybar (picks up CSS changes via Hyprland reload)
killall -SIGUSR2 waybar 2>/dev/null
