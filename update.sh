#!/bin/bash
# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃    Dusk Garden — Config Updater                ┃
# ┃    Replaces existing configs with repo ones    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

set -euo pipefail

# ── Colors & Helpers ────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${GREEN}  ✓${NC} $1"; }
warn()    { echo -e "${YELLOW}  ⚠${NC} $1"; }
error()   { echo -e "${RED}  ✗${NC} $1"; }
section() { echo -e "\n${CYAN}━━━${NC} ${BOLD}$1${NC} ${CYAN}━━━${NC}"; }
ask()     { echo -e "${MAGENTA}  ?${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}   ${BOLD}Dusk Garden${NC} — Config Updater          ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

# ── Optional Backup ─────────────────────────────
ask "Back up existing configs before replacing? (y/n)"
read -p "  > " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    for dir in hypr waybar wofi dunst kitty; do
        if [ -d "$CONFIG_DIR/$dir" ]; then
            cp -r "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
            info "Backed up $dir → $BACKUP_DIR/$dir"
        fi
    done
fi

# ── Deploy Configs ──────────────────────────────
section "Deploying Configs"

# Hyprland
mkdir -p "$CONFIG_DIR/hypr/scripts" \
         "$CONFIG_DIR/hypr/themes" \
         "$CONFIG_DIR/hypr/wallpapers"

cp "$SCRIPT_DIR/hypr/hyprland.conf"      "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/monitors.conf"      "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/appearance.conf"    "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/keybinds.conf"      "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/rules.conf"         "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/autostart.conf"     "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/hyprlock.conf"      "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/hypridle.conf"      "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/themes/colors.conf" "$CONFIG_DIR/hypr/themes/"
cp "$SCRIPT_DIR/hypr/scripts/"*.sh       "$CONFIG_DIR/hypr/scripts/"
chmod +x "$CONFIG_DIR/hypr/scripts/"*.sh
info "Hyprland"

# Wallpapers
shopt -s nullglob
wallpapers=("$SCRIPT_DIR/hypr/wallpapers/"*.{png,jpg,jpeg,webp,gif})
shopt -u nullglob
if [ ${#wallpapers[@]} -gt 0 ]; then
    cp "${wallpapers[@]}" "$CONFIG_DIR/hypr/wallpapers/"
    info "Wallpapers (${#wallpapers[@]} file(s))"
fi

# Waybar
mkdir -p "$CONFIG_DIR/waybar"
cp "$SCRIPT_DIR/waybar/config.jsonc" "$CONFIG_DIR/waybar/"
cp "$SCRIPT_DIR/waybar/style.css"    "$CONFIG_DIR/waybar/"
info "Waybar"

# Wofi
mkdir -p "$CONFIG_DIR/wofi"
cp "$SCRIPT_DIR/wofi/config"     "$CONFIG_DIR/wofi/"
cp "$SCRIPT_DIR/wofi/style.css"  "$CONFIG_DIR/wofi/"
info "Wofi"

# Dunst
mkdir -p "$CONFIG_DIR/dunst"
cp "$SCRIPT_DIR/dunst/dunstrc" "$CONFIG_DIR/dunst/"
info "Dunst"

# Kitty
mkdir -p "$CONFIG_DIR/kitty"
cp "$SCRIPT_DIR/kitty/kitty.conf" "$CONFIG_DIR/kitty/"
info "Kitty"

# ── Reload Running Services ─────────────────────
section "Reloading"

hyprctl reload 2>/dev/null && info "Hyprland reloaded" || warn "Hyprland not running — skipped"
killall -SIGUSR2 waybar 2>/dev/null && info "Waybar reloaded" || warn "Waybar not running — skipped"
killall -SIGUSR1 dunst 2>/dev/null && info "Dunst reloaded" || warn "Dunst not running — skipped"

echo ""
echo -e "  ${GREEN}${BOLD}Done.${NC}"
echo ""
