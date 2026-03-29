#!/bin/bash
# ── Dark/Light Mode Toggle ───────────────────
# Toggles between Dusk Garden dark and light themes

STATE_FILE="$HOME/.config/sway/.theme-mode"
SWAY_COLORS="$HOME/.config/sway/themes/colors"
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

    # Sway colors
    cat > "$SWAY_COLORS" << 'EOF'
set $fg       #1E1B23
set $rose     #9E6B7A
set $cream    #D4A84B
set $mint     #5BAB9F
set $neon     #5BAB9F
set $plum     #5D576B
set $bg       #F5F2F0
set $bg_alt   #E8E4E1
set $surface  #DDD9D5
set $border   #D1CCC8
set $muted    #8A8494

client.focused          $rose     $bg_alt   $fg     $mint      $rose
client.focused_inactive $border   $bg       $muted  $border    $border
client.unfocused        $border   $bg       $muted  $border    $border
client.urgent           $rose     $rose     $fg     $rose      $rose
EOF

    swaymsg reload

    # GTK theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita' 2>/dev/null

    # Waybar colors
    sed -i \
        -e 's/@define-color bg      .*/@define-color bg      #F5F2F0;/' \
        -e 's/@define-color bg_alt  .*/@define-color bg_alt  #E8E4E1;/' \
        -e 's/@define-color surface .*/@define-color surface #DDD9D5;/' \
        -e 's/@define-color fg      .*/@define-color fg      #1E1B23;/' \
        -e 's/@define-color rose    .*/@define-color rose    #9E6B7A;/' \
        -e 's/@define-color cream   .*/@define-color cream   #D4A84B;/' \
        -e 's/@define-color mint    .*/@define-color mint    #5BAB9F;/' \
        -e 's/@define-color plum    .*/@define-color plum    #5D576B;/' \
        -e 's/@define-color border  .*/@define-color border  #D1CCC8;/' \
        -e 's/@define-color muted   .*/@define-color muted   #8A8494;/' \
        "$WAYBAR_STYLE"

    # Dunst colors
    sed -i \
        -e '/^\[urgency_low\]/,/^\[/{s/background = .*/background = "#F5F2F0DD"/;s/foreground = .*/foreground = "#1E1B23"/;s/highlight = .*/highlight = "#5BAB9F"/;s/frame_color = .*/frame_color = "#D1CCC866"/;}' \
        -e '/^\[urgency_normal\]/,/^\[/{s/background = .*/background = "#F5F2F0DD"/;s/foreground = .*/foreground = "#1E1B23"/;s/highlight = .*/highlight = "#5BAB9F"/;s/frame_color = .*/frame_color = "#D1CCC866"/;}' \
        -e '/^\[urgency_critical\]/,${s/background = .*/background = "#F5F2F0EE"/;s/foreground = .*/foreground = "#1E1B23"/;s/highlight = .*/highlight = "#9E6B7A"/;s/frame_color = .*/frame_color = "#9E6B7A66"/;}' \
        "$DUNST_CONF"

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

    notify-send -u low "Theme" "Switched to Light Mode"
else
    # ── Switch to Dark ───────────────────────
    NEW_MODE="dark"

    # Sway colors
    cat > "$SWAY_COLORS" << 'EOF'
set $fg       #FCFCFC
set $rose     #B48291
set $cream    #FFFAE3
set $mint     #99E1D9
set $neon     #99E1D9
set $plum     #5D576B
set $bg       #1C1C1E
set $bg_alt   #2C2C2E
set $surface  #3A3A3C
set $border   #48484A
set $muted    #8E8E93

client.focused          $rose     $bg_alt   $fg     $mint      $rose
client.focused_inactive $border   $bg       $muted  $border    $border
client.unfocused        $border   $bg       $muted  $border    $border
client.urgent           $rose     $rose     $fg     $rose      $rose
EOF

    swaymsg reload

    # GTK theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita:dark' 2>/dev/null

    # Waybar colors
    sed -i \
        -e 's/@define-color bg      .*/@define-color bg      #1C1C1E;/' \
        -e 's/@define-color bg_alt  .*/@define-color bg_alt  #2C2C2E;/' \
        -e 's/@define-color surface .*/@define-color surface #3A3A3C;/' \
        -e 's/@define-color fg      .*/@define-color fg      #FCFCFC;/' \
        -e 's/@define-color rose    .*/@define-color rose    #B48291;/' \
        -e 's/@define-color cream   .*/@define-color cream   #FFFAE3;/' \
        -e 's/@define-color mint    .*/@define-color mint    #99E1D9;/' \
        -e 's/@define-color plum    .*/@define-color plum    #5D576B;/' \
        -e 's/@define-color border  .*/@define-color border  #48484A;/' \
        -e 's/@define-color muted   .*/@define-color muted   #8E8E93;/' \
        "$WAYBAR_STYLE"

    # Dunst colors
    sed -i \
        -e '/^\[urgency_low\]/,/^\[/{s/background = .*/background = "#1C1C1EDD"/;s/foreground = .*/foreground = "#FCFCFC"/;s/highlight = .*/highlight = "#99E1D9"/;s/frame_color = .*/frame_color = "#48484A66"/;}' \
        -e '/^\[urgency_normal\]/,/^\[/{s/background = .*/background = "#1C1C1EDD"/;s/foreground = .*/foreground = "#FCFCFC"/;s/highlight = .*/highlight = "#99E1D9"/;s/frame_color = .*/frame_color = "#48484A66"/;}' \
        -e '/^\[urgency_critical\]/,${s/background = .*/background = "#1C1C1EEE"/;s/foreground = .*/foreground = "#FCFCFC"/;s/highlight = .*/highlight = "#B48291"/;s/frame_color = .*/frame_color = "#B4829166"/;}' \
        "$DUNST_CONF"

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

    notify-send -u low "Theme" "Switched to Dark Mode"
fi

# Save state
echo "$NEW_MODE" > "$STATE_FILE"

# Reload waybar and dunst
killall -SIGUSR2 waybar 2>/dev/null
killall -SIGUSR2 dunst 2>/dev/null
