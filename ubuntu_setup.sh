#!/bin/bash
# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃  Dusk Garden — Ubuntu Server + Sway Installer  ┃
# ┃  Target: Ubuntu 24.04 LTS (headless → GUI)     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOG_FILE="/tmp/dusk-garden-ubuntu-$(date +%Y%m%d_%H%M%S).log"

log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
warn() { echo "[$(date '+%H:%M:%S')] WARNING: $*" | tee -a "$LOG_FILE" >&2; }

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 1: System Update
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
install_system_updates() {
    log "Updating system packages..."
    sudo apt update -y
    sudo apt upgrade -y
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 2: Core Sway + Wayland Stack
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
install_sway_stack() {
    log "Installing Sway/Wayland compositor stack..."
    sudo apt install -y \
        sway swaybg swaylock swayidle \
        xwayland xdg-desktop-portal-wlr \
        waybar wofi dunst libnotify-bin mako-notifier \
        wl-clipboard \
        grim slurp wf-recorder \
        kitty thunar thunar-archive-plugin thunar-volman

    log "Installing audio/media stack..."
    sudo apt install -y \
        pipewire pipewire-pulse pipewire-alsa wireplumber \
        playerctl pavucontrol

    log "Installing system utilities..."
    sudo apt install -y \
        brightnessctl \
        policykit-1-gnome \
        network-manager \
        blueman

    log "Installing fonts..."
    sudo apt install -y \
        fonts-jetbrains-mono \
        fonts-noto fonts-noto-color-emoji \
        fonts-font-awesome

    # JetBrainsMono Nerd Font (not in Ubuntu repos — install manually)
    log "Installing JetBrainsMono Nerd Font..."
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
        NF_VERSION="v3.3.0"
        curl -fsSL -o /tmp/JetBrainsMono.tar.xz \
            "https://github.com/ryanoasis/nerd-fonts/releases/download/${NF_VERSION}/JetBrainsMono.tar.xz"
        tar -xf /tmp/JetBrainsMono.tar.xz -C "$FONT_DIR"
        rm -f /tmp/JetBrainsMono.tar.xz
        fc-cache -fv >> "$LOG_FILE" 2>&1
    fi

    # CaskaydiaCove Nerd Font (used by kitty)
    if [ ! -f "$FONT_DIR/CaskaydiaCoveNerdFont-Regular.ttf" ]; then
        curl -fsSL -o /tmp/CascadiaCode.tar.xz \
            "https://github.com/ryanoasis/nerd-fonts/releases/download/${NF_VERSION}/CascadiaCode.tar.xz"
        tar -xf /tmp/CascadiaCode.tar.xz -C "$FONT_DIR"
        rm -f /tmp/CascadiaCode.tar.xz
        fc-cache -fv >> "$LOG_FILE" 2>&1
    fi
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 3: CLI Tools & Shell
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
install_cli_tools() {
    log "Installing CLI tools..."
    sudo apt install -y \
        tmux zsh neovim python3-pip \
        build-essential gcc git gh curl wget jq \
        ripgrep fd-find fzf bat btop unzip

    # Install oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing oh-my-zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install kitty via official installer (latest version)
    log "Installing latest Kitty terminal..."
    curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

    git clone --single-branch https://github.com/GhostNaN/mpvpaper
    cd mpvpaper
    meson setup build --prefix=/usr/local
    ninja -C build
    ninja -C build install
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 4: User Applications (snap)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
install_apps() {
    log "Installing user applications via snap..."

    # Ensure snapd is available
    if ! command -v snap &>/dev/null; then
        sudo apt install -y snapd
    fi

    sudo snap install obsidian --classic
    sudo snap install qalculate
    sudo snap install dbgate
    sudo snap install bitwarden
    sudo snap install thunderbird
    sudo snap install spotify
    sudo snap install code --classic

    # Add Docker's official GPG key:
    sudo apt update
    sudo apt install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    sudo apt update
    wget https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64
    sudo apt install ./*.sh
    rm ./*.sh
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
    \. "$HOME/.nvm/nvm.sh"
    nvm install 24
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x ./*.sh
    ./*.sh
    rm ./*.sh
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 5: Deploy Configs
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
deploy_configs() {
    log "Deploying Dusk Garden configs..."

    # Sway
    mkdir -p "$CONFIG_DIR/sway/scripts" "$CONFIG_DIR/sway/themes" "$CONFIG_DIR/sway/wallpapers"
    cp "$SCRIPT_DIR/sway/config"          "$CONFIG_DIR/sway/"
    cp "$SCRIPT_DIR/sway/keybinds"        "$CONFIG_DIR/sway/"
    cp "$SCRIPT_DIR/sway/autostart"       "$CONFIG_DIR/sway/"
    cp "$SCRIPT_DIR/sway/rules"           "$CONFIG_DIR/sway/"
    cp "$SCRIPT_DIR/sway/outputs"         "$CONFIG_DIR/sway/"
    cp "$SCRIPT_DIR/sway/inputs"          "$CONFIG_DIR/sway/"
    cp "$SCRIPT_DIR/sway/appearance"      "$CONFIG_DIR/sway/"
    cp "$SCRIPT_DIR/sway/swaylock.conf"   "$CONFIG_DIR/sway/"
    cp "$SCRIPT_DIR/sway/themes/colors"   "$CONFIG_DIR/sway/themes/"
    cp "$SCRIPT_DIR/sway/scripts/"*.sh    "$CONFIG_DIR/sway/scripts/"
    chmod +x "$CONFIG_DIR/sway/scripts/"*.sh

    # Copy static wallpapers if any exist
    shopt -s nullglob
    wallpapers=("$SCRIPT_DIR/sway/wallpapers/"*.{mp4, png,jpg,jpeg,webp,bmp})
    shopt -u nullglob
    if [ ${#wallpapers[@]} -gt 0 ]; then
        cp "${wallpapers[@]}" "$CONFIG_DIR/sway/wallpapers/"
    fi

    # Waybar
    mkdir -p "$CONFIG_DIR/waybar"
    cp "$SCRIPT_DIR/waybar/config.jsonc"  "$CONFIG_DIR/waybar/"
    cp "$SCRIPT_DIR/waybar/style.css"     "$CONFIG_DIR/waybar/"

    # Wofi
    mkdir -p "$CONFIG_DIR/wofi"
    cp "$SCRIPT_DIR/wofi/config"          "$CONFIG_DIR/wofi/"
    cp "$SCRIPT_DIR/wofi/style.css"       "$CONFIG_DIR/wofi/"

    # Dunst
    mkdir -p "$CONFIG_DIR/dunst"
    cp "$SCRIPT_DIR/dunst/dunstrc"        "$CONFIG_DIR/dunst/"

    # Kitty
    mkdir -p "$CONFIG_DIR/kitty"
    cp "$SCRIPT_DIR/kitty/kitty.conf"     "$CONFIG_DIR/kitty/"

    # Eww (configs only — requires eww binary built from source)
    mkdir -p "$CONFIG_DIR/eww"
    cp "$SCRIPT_DIR/eww/eww.yuck"        "$CONFIG_DIR/eww/"
    cp "$SCRIPT_DIR/eww/eww.scss"        "$CONFIG_DIR/eww/"

    # Set zsh as default shell
    if command -v zsh &>/dev/null; then
        chsh -s "$(which zsh)"
    fi
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 6: Enable Services
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
enable_services() {
    log "Enabling system services..."

    if systemctl list-unit-files | grep -q bluetooth.service; then
        sudo systemctl enable --now bluetooth.service >> "$LOG_FILE" 2>&1 || true
    fi

    if systemctl list-unit-files | grep -q NetworkManager.service; then
        sudo systemctl enable --now NetworkManager.service >> "$LOG_FILE" 2>&1 || true
    fi

    systemctl --user enable --now pipewire.service >> "$LOG_FILE" 2>&1 || true
    systemctl --user enable --now pipewire-pulse.service >> "$LOG_FILE" 2>&1 || true
    systemctl --user enable --now wireplumber.service >> "$LOG_FILE" 2>&1 || true
    systemctl --user start docker-desktop
    systemctl --user enable docker-desktop
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Main
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
main() {
    echo ""
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo "┃  Dusk Garden — Ubuntu + Sway Installer         ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
    echo ""
    echo "This will install:"
    echo "  • Sway compositor + Wayland stack"
    echo "  • Waybar, Wofi, Dunst, Kitty"
    echo "  • CLI tools (tmux, zsh, neovim, ripgrep, fzf...)"
    echo "  • User apps (VS Code, Obsidian, Spotify...)"
    echo "  • Dusk Garden theme configs"
    echo ""
    echo "Log: $LOG_FILE"
    echo ""
    read -rp "Continue? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi

    install_system_updates
    install_sway_stack
    install_cli_tools
    install_apps
    deploy_configs
    enable_services

    echo ""
    log "Installation complete!"
    echo ""
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo "┃  Next steps:                                   ┃"
    echo "┃                                                ┃"
    echo "┃  1. Add a wallpaper:                           ┃"
    echo "┃     cp wall.png ~/.config/sway/wallpapers/     ┃"
    echo "┃     cp wall.png ~/.config/sway/wallpapers/     ┃"
    echo "┃           default.png                          ┃"
    echo "┃                                                ┃"
    echo "┃  2. Set weather city in ~/.zshrc:              ┃"
    echo "┃     export WEATHER_CITY=\"London\"                ┃"
    echo "┃                                                ┃"
    echo "┃  3. Start Sway:                                ┃"
    echo "┃     exec sway                                  ┃"
    echo "┃                                                ┃"
    echo "┃  4. (Optional) Build eww from source for       ┃"
    echo "┃     desktop widgets:                           ┃"
    echo "┃     github.com/elkowar/eww                     ┃"
    echo "┃                                                ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
}

main "$@"
