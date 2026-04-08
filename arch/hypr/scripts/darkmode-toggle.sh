#!/bin/bash
# ── Dark/Light Mode Toggle ───────────────────
# Toggles between Tahoe-inspired dark and light themes

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
    $fg       = rgba(1A2430ee)
    $fg_solid = rgba(1A2430ff)
    $rose     = rgba(F07A96ee)
    $cream    = rgba(F5EFE6ee)
    $mint     = rgba(63D8CBee)
    $neon     = rgba(4FC6F0ff)
    $plum     = rgba(7D87B8ee)
    $bg       = rgba(F4F7FBee)
    $bg_alt   = rgba(E9EEF5ee)
    $surface  = rgba(DDE6F0ee)
    $border   = rgba(C9D4E2ee)
    $muted    = rgba(66758Aee)

    general {
        col.active_border = rgba(FFFFFF99) rgba(4FC6F0aa) 30deg
        col.inactive_border = rgba(C9D4E277)
    }
EOF

    hyprctl reload

    # GTK theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3' 2>/dev/null

    # Waybar colors
    sed -i \
        -e 's/@define-color bg      .*/@define-color bg      #F4F7FB;/' \
        -e 's/@define-color bg_alt  .*/@define-color bg_alt  #E9EEF5;/' \
        -e 's/@define-color surface .*/@define-color surface #DDE6F0;/' \
        -e 's/@define-color fg      .*/@define-color fg      #1A2430;/' \
        -e 's/@define-color rose    .*/@define-color rose    #F07A96;/' \
        -e 's/@define-color cream   .*/@define-color cream   #F5EFE6;/' \
        -e 's/@define-color mint    .*/@define-color mint    #63D8CB;/' \
        -e 's/@define-color plum    .*/@define-color plum    #7D87B8;/' \
        -e 's/@define-color border  .*/@define-color border  #C9D4E255;/' \
        -e 's/@define-color muted   .*/@define-color muted   #66758A;/' \
        -e 's/@define-color glow    .*/@define-color glow    #4FC6F0;/' \
        "$WAYBAR_STYLE"

    # Dunst colors
    sed -i \
        -e '/^\[urgency_low\]/,/^\[/{s/background = .*/background = "#F4F7FBDD"/;s/foreground = .*/foreground = "#1A2430"/;s/highlight = .*/highlight = "#4FC6F0"/;s/frame_color = .*/frame_color = "#C9D4E266"/;}' \
        -e '/^\[urgency_normal\]/,/^\[/{s/background = .*/background = "#F4F7FBDD"/;s/foreground = .*/foreground = "#1A2430"/;s/highlight = .*/highlight = "#4FC6F0"/;s/frame_color = .*/frame_color = "#C9D4E266"/;}' \
        -e '/^\[urgency_critical\]/,${s/background = .*/background = "#F4F7FBEE"/;s/foreground = .*/foreground = "#1A2430"/;s/highlight = .*/highlight = "#F07A96"/;s/frame_color = .*/frame_color = "#F07A9666"/;}' \
        "$DUNST_CONF"

    # Kitty
    kitty @ set-colors --all \
        foreground=#1A2430 \
        background=#F4F7FB \
        selection_foreground=#F4F7FB \
        selection_background=#4FC6F0 \
        color0=#E9EEF5 \
        color8=#C9D4E2 \
        color1=#F07A96 \
        color9=#FF9EB6 \
        color2=#63D8CB \
        color10=#8DEBE1 \
        color3=#F5EFE6 \
        color11=#FFF7EE \
        color4=#7D87B8 \
        color12=#9AA3CE \
        color5=#B786D1 \
        color13=#D5ACEC \
        color6=#4FC6F0 \
        color14=#8EDBE8 \
        color7=#1A2430 \
        color15=#0F1722 2>/dev/null

    notify-send -u low "Theme" "Switched to Light Mode ☀"
else
    # ── Switch to Dark ───────────────────────
    NEW_MODE="dark"

    # Hyprland colors
    cat > "$HYPR_THEME" << 'EOF'
    $fg       = rgba(F6F7FBea)
    $fg_solid = rgba(F6F7FBff)
    $rose     = rgba(FF9EB6e6)
    $cream    = rgba(F7F4EAe6)
    $mint     = rgba(97E7D6e6)
    $neon     = rgba(8EDBE8ff)
    $plum     = rgba(8A90B8e6)
    $bg       = rgba(12151Fee)
    $bg_alt   = rgba(182330ee)
    $surface  = rgba(2A3342ee)
    $border   = rgba(EEF3FF33)
    $muted    = rgba(B9C3D4dd)

    general {
        col.active_border = rgba(FFFFFF66) rgba(8EDBE8aa) 35deg
        col.inactive_border = rgba(EEF3FF22)
    }
EOF

    hyprctl reload

    # GTK theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' 2>/dev/null

    # Waybar colors
    sed -i \
        -e 's/@define-color bg      .*/@define-color bg      #12151F;/' \
        -e 's/@define-color bg_alt  .*/@define-color bg_alt  #1D2430;/' \
        -e 's/@define-color surface .*/@define-color surface #2A3342;/' \
        -e 's/@define-color fg      .*/@define-color fg      #F6F7FB;/' \
        -e 's/@define-color rose    .*/@define-color rose    #FF9EB6;/' \
        -e 's/@define-color cream   .*/@define-color cream   #F7F4EA;/' \
        -e 's/@define-color mint    .*/@define-color mint    #97E7D6;/' \
        -e 's/@define-color plum    .*/@define-color plum    #8A90B8;/' \
        -e 's/@define-color border  .*/@define-color border  #DDE7F233;/' \
        -e 's/@define-color muted   .*/@define-color muted   #B9C3D4;/' \
        -e 's/@define-color glow    .*/@define-color glow    #8EDBE8;/' \
        "$WAYBAR_STYLE"

    # Dunst colors
    sed -i \
        -e '/^\[urgency_low\]/,/^\[/{s/background = .*/background = "#1A2232DD"/;s/foreground = .*/foreground = "#F6F7FB"/;s/highlight = .*/highlight = "#8EDBE8"/;s/frame_color = .*/frame_color = "#F0F6FF2A"/;}' \
        -e '/^\[urgency_normal\]/,/^\[/{s/background = .*/background = "#1A2232DD"/;s/foreground = .*/foreground = "#F6F7FB"/;s/highlight = .*/highlight = "#8EDBE8"/;s/frame_color = .*/frame_color = "#F0F6FF2A"/;}' \
        -e '/^\[urgency_critical\]/,${s/background = .*/background = "#2B2030EE"/;s/foreground = .*/foreground = "#F6F7FB"/;s/highlight = .*/highlight = "#FF9EB6"/;s/frame_color = .*/frame_color = "#FF9EB655"/;}' \
        "$DUNST_CONF"

    # Kitty
    kitty @ set-colors --all \
        foreground=#F6F7FB \
        background=#141923 \
        selection_foreground=#141923 \
        selection_background=#8EDBE8 \
        color0=#141923 \
        color8=#5B6472 \
        color1=#FF9EB6 \
        color9=#FFB7C9 \
        color2=#97E7D6 \
        color10=#B2F0E2 \
        color3=#F7F4EA \
        color11=#FFF9ED \
        color4=#8A90B8 \
        color12=#B1B8DC \
        color5=#C497D8 \
        color13=#DCB6EA \
        color6=#8EDBE8 \
        color14=#B7EEF6 \
        color7=#F6F7FB \
        color15=#FFFFFF 2>/dev/null

    notify-send -u low "Theme" "Switched to Dark Mode 🌙"
fi

# Save state
echo "$NEW_MODE" > "$STATE_FILE"

# Reload waybar and dunst
killall -SIGUSR2 waybar 2>/dev/null
dunstctl reload 2>/dev/null
