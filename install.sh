#!/bin/bash
# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃    Dusk Garden — Arch Linux Installer          ┃
# ┃    Hyprland + Dev Environment                  ┃
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
LOG_FILE="/tmp/dusk-garden-install-$(date +%Y%m%d_%H%M%S).log"

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}   ${BOLD}Dusk Garden${NC} — Hyprland Rice Installer  ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}   macOS x Cyberpunk • Arch Linux         ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Log file: ${CYAN}$LOG_FILE${NC}"
echo ""

# ── Detect AUR Helper ──────────────────────────
detect_aur_helper() {
    if command -v paru &>/dev/null; then
        AUR_HELPER="paru"
    elif command -v yay &>/dev/null; then
        AUR_HELPER="yay"
    else
        echo ""
        warn "No AUR helper found."
        ask "Install paru? (y/n)"
        read -p "  > " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            info "Installing paru..."
            sudo pacman -S --needed --noconfirm git base-devel >> "$LOG_FILE" 2>&1
            git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin 2>> "$LOG_FILE"
            (cd /tmp/paru-bin && makepkg -si --noconfirm) >> "$LOG_FILE" 2>&1
            rm -rf /tmp/paru-bin
            AUR_HELPER="paru"
            info "paru installed."
        else
            error "AUR helper required. Exiting."
            exit 1
        fi
    fi
    info "Using ${BOLD}$AUR_HELPER${NC} as AUR helper."
}

install_pkgs() {
    local desc="$1"
    shift
    local pkgs=("$@")
    local to_install=()

    for pkg in "${pkgs[@]}"; do
        if ! $AUR_HELPER -Qi "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -eq 0 ]; then
        info "$desc — all already installed."
        return
    fi

    info "$desc — installing ${#to_install[@]} package(s)..."
    $AUR_HELPER -S --needed --noconfirm "${to_install[@]}" >> "$LOG_FILE" 2>&1 || {
        warn "Some packages in '$desc' may have failed. Check $LOG_FILE"
    }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PHASE 1: System Packages
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
section "Phase 1 — System Packages"

detect_aur_helper

# ── Core Hyprland ──────────────────────────────
install_pkgs "Hyprland core" \
    hyprland hyprlock hypridle hyprutils hyprpaper \
    xdg-desktop-portal-hyprland

# ── Bar, Launcher, Notifications ───────────────
install_pkgs "UI components" \
    waybar wofi dunst libnotify

# ── Terminal ───────────────────────────────────
install_pkgs "Terminal" \
    kitty

# ── Wallpaper ──────────────────────────────────
install_pkgs "Wallpaper engine" \
    swww

# ── File Manager ───────────────────────────────
install_pkgs "File manager" \
    thunar thunar-archive-plugin thunar-volman

# ── Clipboard & Screenshots ────────────────────
install_pkgs "Clipboard & screenshots" \
    wl-clipboard cliphist grimblast-git

# ── System Utilities ───────────────────────────
install_pkgs "System utilities" \
    brightnessctl playerctl pavucontrol \
    polkit-kde-agent

# ── Network & Bluetooth ───────────────────────
install_pkgs "Network & Bluetooth" \
    network-manager-applet blueman

# ── Audio (PipeWire) ──────────────────────────
install_pkgs "Audio stack" \
    pipewire pipewire-pulse pipewire-alsa wireplumber

# ── Fonts ─────────────────────────────────────
install_pkgs "Fonts" \
    ttf-jetbrains-mono-nerd ttf-caskaydia-cove-nerd \
    noto-fonts noto-fonts-emoji \
    ttf-font-awesome otf-font-awesome

# ── Cursor Theme ──────────────────────────────
install_pkgs "Cursor theme" \
    apple-cursor

# ── GTK/Qt Theming ────────────────────────────
install_pkgs "Theming" \
    nwg-look qt5ct qt6ct

# ── Weather Script Dependency ──────────────────
install_pkgs "Weather dependencies" \
    jq curl

# ── Shell Extras ───────────────────────────────
install_pkgs "Shell extras" \
    pokemon-colorscripts-git fastfetch

# ── Screen Recording ─────────────────────────
install_pkgs "Screen recording" \
    wf-recorder slurp

# ── Desktop Widgets ────────────────────────────
install_pkgs "Desktop widgets" \
    eww-wayland

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PHASE 2: App Installations
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
section "Phase 2 — App Installations"

# ── Add your app installations here ────────────
# Example:
#   install_pkgs "My Apps" \
#       firefox discord spotify-launcher

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PHASE 3: Backup Existing Configs
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
section "Phase 3 — Config Deployment"

DIRS_TO_DEPLOY=("hypr" "waybar" "wofi" "dunst" "kitty" "eww")
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
need_backup=false

for dir in "${DIRS_TO_DEPLOY[@]}"; do
    if [ -d "$CONFIG_DIR/$dir" ]; then
        need_backup=true
        break
    fi
done

if [ "$need_backup" = true ]; then
    warn "Existing configs found."
    ask "Back up before overwriting? (y/n)"
    read -p "  > " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$BACKUP_DIR"
        for dir in "${DIRS_TO_DEPLOY[@]}"; do
            if [ -d "$CONFIG_DIR/$dir" ]; then
                cp -r "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
                info "Backed up $dir → $BACKUP_DIR/$dir"
            fi
        done
    else
        warn "Skipping backup."
    fi
fi

# ── Deploy Configs ─────────────────────────────
echo ""

# Hyprland
mkdir -p "$CONFIG_DIR/hypr/scripts" \
         "$CONFIG_DIR/hypr/themes" \
         "$CONFIG_DIR/hypr/wallpapers"

cp "$SCRIPT_DIR/hypr/hyprland.conf"     "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/monitors.conf"     "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/appearance.conf"   "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/keybinds.conf"     "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/rules.conf"        "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/autostart.conf"    "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/hyprlock.conf"     "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/hypridle.conf"     "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/themes/colors.conf" "$CONFIG_DIR/hypr/themes/"
[ -f "$SCRIPT_DIR/hypr/nvidia.conf" ] && cp "$SCRIPT_DIR/hypr/nvidia.conf" "$CONFIG_DIR/hypr/"
cp "$SCRIPT_DIR/hypr/scripts/"*.sh      "$CONFIG_DIR/hypr/scripts/"
chmod +x "$CONFIG_DIR/hypr/scripts/"*.sh

# Wallpapers
shopt -s nullglob
wallpapers=("$SCRIPT_DIR/hypr/wallpapers/"*.{png,jpg,jpeg,webp,gif})
shopt -u nullglob
if [ ${#wallpapers[@]} -gt 0 ]; then
    cp "${wallpapers[@]}" "$CONFIG_DIR/hypr/wallpapers/"
    info "Wallpapers deployed (${#wallpapers[@]} file(s))."
    # Set the first wallpaper as default if no default.* exists
    shopt -s nullglob
    existing_defaults=("$CONFIG_DIR/hypr/wallpapers/default".{png,jpg,jpeg,webp,gif})
    shopt -u nullglob
    if [ ${#existing_defaults[@]} -eq 0 ]; then
        ext="${wallpapers[0]##*.}"
        cp "${wallpapers[0]}" "$CONFIG_DIR/hypr/wallpapers/default.${ext}"
        info "Set '$(basename "${wallpapers[0]}")' as default wallpaper."
    fi
else
    warn "No wallpapers found in repo. Add images to hypr/wallpapers/ or set one manually:"
    warn "  cp your-wallpaper.png ~/.config/hypr/wallpapers/default.png"
fi

info "Hyprland config deployed."

# Waybar
mkdir -p "$CONFIG_DIR/waybar"
cp "$SCRIPT_DIR/waybar/config.jsonc"    "$CONFIG_DIR/waybar/"
cp "$SCRIPT_DIR/waybar/style.css"       "$CONFIG_DIR/waybar/"
info "Waybar config deployed."

# Wofi
mkdir -p "$CONFIG_DIR/wofi"
cp "$SCRIPT_DIR/wofi/config"            "$CONFIG_DIR/wofi/"
cp "$SCRIPT_DIR/wofi/style.css"         "$CONFIG_DIR/wofi/"
info "Wofi config deployed."

# Dunst
mkdir -p "$CONFIG_DIR/dunst"
cp "$SCRIPT_DIR/dunst/dunstrc"          "$CONFIG_DIR/dunst/"
info "Dunst config deployed."

# Kitty
mkdir -p "$CONFIG_DIR/kitty"
cp "$SCRIPT_DIR/kitty/kitty.conf"       "$CONFIG_DIR/kitty/"
info "Kitty config deployed."

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PHASE 4: NVIDIA Configuration (Optional)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
section "Phase 4 — NVIDIA Setup"

ask "Do you have an NVIDIA GPU? (y/n)"
read -p "  > " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then

    # Install NVIDIA packages
    install_pkgs "NVIDIA drivers" \
        nvidia-dkms nvidia-utils nvidia-settings \
        lib32-nvidia-utils egl-wayland

    # Enable nvidia.conf in hyprland config
    sed -i 's|^# source = ~/.config/hypr/nvidia.conf|source = ~/.config/hypr/nvidia.conf|' "$CONFIG_DIR/hypr/hyprland.conf"
    info "NVIDIA env vars enabled in hyprland.conf"

    # Check kernel params
    if grep -q "nvidia_drm.modeset=1" /proc/cmdline 2>/dev/null; then
        info "nvidia_drm.modeset=1 is set."
    else
        warn "nvidia_drm.modeset=1 NOT found in kernel params."
        echo ""
        echo -e "  Add to your bootloader:"
        echo -e "  ${CYAN}GRUB:${NC} Edit /etc/default/grub"
        echo -e "        GRUB_CMDLINE_LINUX_DEFAULT=\"... nvidia_drm.modeset=1\""
        echo -e "        Then run: sudo grub-mkconfig -o /boot/grub/grub.cfg"
        echo ""
        echo -e "  ${CYAN}systemd-boot:${NC} Edit /boot/loader/entries/*.conf"
        echo -e "        options ... nvidia_drm.modeset=1"
        echo ""
    fi

    # Check mkinitcpio modules
    if grep -q "nvidia" /etc/mkinitcpio.conf 2>/dev/null; then
        info "NVIDIA modules found in mkinitcpio.conf."
    else
        warn "NVIDIA modules not in mkinitcpio.conf."
        echo -e "  Add to MODULES: ${CYAN}(nvidia nvidia_modeset nvidia_uvm nvidia_drm)${NC}"
        echo -e "  Then run: ${CYAN}sudo mkinitcpio -P${NC}"
        echo ""
    fi

    # pacman hook for NVIDIA
    HOOK_DIR="/etc/pacman.d/hooks"
    if [ ! -f "$HOOK_DIR/nvidia.hook" ]; then
        ask "Create pacman hook for auto-rebuilding NVIDIA modules on kernel update? (y/n)"
        read -p "  > " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo mkdir -p "$HOOK_DIR"
            sudo tee "$HOOK_DIR/nvidia.hook" > /dev/null << 'HOOKEOF'
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia-dkms
Target=linux
Target=linux-headers

[Action]
Description=Rebuilding NVIDIA module for new kernel
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'
HOOKEOF
            info "NVIDIA pacman hook created."
        fi
    fi

else
    info "Skipping NVIDIA setup."
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PHASE 5: Enable Services
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
section "Phase 5 — Services"

# Bluetooth
if systemctl list-unit-files | grep -q bluetooth.service; then
    sudo systemctl enable --now bluetooth.service >> "$LOG_FILE" 2>&1 || true
    info "Bluetooth service enabled."
fi

# NetworkManager
if systemctl list-unit-files | grep -q NetworkManager.service; then
    sudo systemctl enable --now NetworkManager.service >> "$LOG_FILE" 2>&1 || true
    info "NetworkManager service enabled."
fi

# PipeWire
systemctl --user enable --now pipewire.service >> "$LOG_FILE" 2>&1 || true
systemctl --user enable --now pipewire-pulse.service >> "$LOG_FILE" 2>&1 || true
systemctl --user enable --now wireplumber.service >> "$LOG_FILE" 2>&1 || true
info "PipeWire audio stack enabled."

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PHASE 6: Final Setup
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
section "Phase 6 — Final Setup"

# Set cursor theme system-wide
if [ -d /usr/share/icons/macOS-Monterey ] || [ -d /usr/share/icons/macOS ] || pacman -Qi apple-cursor &>/dev/null; then
    mkdir -p "$HOME/.icons/default"
    cat > "$HOME/.icons/default/index.theme" << 'EOF'
[Icon Theme]
Inherits=macOS-Monterey
EOF
    info "Cursor theme set to macOS-Monterey."
else
    warn "macOS cursor theme not found. You may need to set it manually."
fi

# Set default shell hint
if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
    ask "Your shell is $SHELL. Install & switch to zsh? (y/n)"
    read -p "  > " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_pkgs "Zsh" zsh
        chsh -s /usr/bin/zsh
        info "Default shell changed to zsh. Takes effect on next login."
    fi
fi

# ── Pokemon Colorscripts ────────────────────────
if command -v pokemon-colorscripts &>/dev/null; then
    RC_FILE=""
    if [ -f "$HOME/.zshrc" ]; then
        RC_FILE="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        RC_FILE="$HOME/.bashrc"
    fi

    if [ -n "$RC_FILE" ]; then
        if ! grep -q "pokemon-colorscripts" "$RC_FILE"; then
            echo "" >> "$RC_FILE"
            echo "# Dusk Garden — random pokemon on shell start" >> "$RC_FILE"
            echo "pokemon-colorscripts -r --no-title" >> "$RC_FILE"
            info "Pokemon colorscripts added to $RC_FILE"
        else
            info "Pokemon colorscripts already in $RC_FILE — skipped."
        fi
    else
        warn "No .zshrc or .bashrc found. Add manually: pokemon-colorscripts -r --no-title"
    fi
fi

# ── Eww Widgets ────────────────────────────────
mkdir -p "$CONFIG_DIR/eww"
cp "$SCRIPT_DIR/eww/eww.yuck" "$CONFIG_DIR/eww/"
cp "$SCRIPT_DIR/eww/eww.scss" "$CONFIG_DIR/eww/"
info "Eww widget config deployed."

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DONE
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}   ${GREEN}${BOLD}✓ Installation Complete!${NC}                  ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo ""
echo -e "  ${CYAN}1.${NC} Add a wallpaper:"
echo -e "     cp your-wallpaper.png ${CYAN}~/.config/hypr/wallpapers/default.png${NC}"
echo ""
echo -e "  ${CYAN}2.${NC} Set your weather city:"
echo -e "     Edit ${CYAN}~/.config/hypr/scripts/weather.sh${NC}"
echo ""
echo -e "  ${CYAN}3.${NC} NVIDIA — verify kernel params (see warnings above)"
echo ""
echo -e "  ${CYAN}4.${NC} Log out and select ${BOLD}Hyprland${NC} from your display manager"
echo ""
echo -e "  ${CYAN}5.${NC} Once in Hyprland, press ${BOLD}SUPER + /${NC} to see all shortcuts"
echo ""
echo -e "  Full log: ${CYAN}$LOG_FILE${NC}"
echo ""
