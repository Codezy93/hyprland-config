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
    sudo apt update
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
        waybar wofi dunst libnotify-bin \
        wl-clipboard \
        grim slurp wf-recorder \
        thunar thunar-archive-plugin thunar-volman

    log "Installing audio/media stack..."
    sudo apt install -y \
        pipewire pipewire-pulse pipewire-alsa wireplumber \
        playerctl pavucontrol

    log "Installing system utilities..."
    sudo apt install -y \
        brightnessctl \
        policykit-1-gnome \
        network-manager network-manager-gnome \
        blueman

    log "Installing fonts..."
    sudo apt install -y \
        fonts-jetbrains-mono \
        fonts-noto fonts-noto-color-emoji \
        fonts-font-awesome

    # Nerd Fonts (not in Ubuntu repos — install manually)
    # Bug fix: NF_VERSION declared before both if-blocks so it's always in scope
    local NF_VERSION="v3.3.0"
    local FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"

    if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
        log "Installing JetBrainsMono Nerd Font..."
        curl -fsSL -o /tmp/JetBrainsMono.tar.xz \
            "https://github.com/ryanoasis/nerd-fonts/releases/download/${NF_VERSION}/JetBrainsMono.tar.xz"
        tar -xf /tmp/JetBrainsMono.tar.xz -C "$FONT_DIR"
        rm -f /tmp/JetBrainsMono.tar.xz
        fc-cache -fv >> "$LOG_FILE" 2>&1
    fi

    if [ ! -f "$FONT_DIR/CaskaydiaCoveNerdFont-Regular.ttf" ]; then
        log "Installing CaskaydiaCove Nerd Font..."
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
    # gh (GitHub CLI) requires its own apt repo — not in Ubuntu default repos
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
        https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y \
        tmux zsh neovim python3-pip \
        build-essential gcc git gh curl wget jq \
        ripgrep fd-find fzf bat btop unzip \
        meson ninja-build

    log "Building mpvpaper from source (video wallpapers for Sway)..."
    # libmpv-dev is in the universe repo — enable it first
    sudo add-apt-repository universe -y
    sudo apt update
    sudo apt install -y libmpv-dev libwayland-dev wayland-protocols pkg-config rustup cargo
    # Build in a subshell so cd does not affect the rest of the script
    (
        rm -rf /tmp/mpvpaper-build
        git clone --depth=1 https://github.com/GhostNaN/mpvpaper.git /tmp/mpvpaper-build
        cd /tmp/mpvpaper-build
        meson setup build --prefix=/usr/local --buildtype=release
        ninja -C build
        sudo ninja -C build install
    )
    rm -rf /tmp/mpvpaper-build


    # Install cliphist (clipboard history for Wayland — not in Ubuntu repos)
    log "Installing cliphist..."
    if ! command -v cliphist &>/dev/null; then
        local CLIPHIST_URL
        CLIPHIST_URL=$(curl -fsSL "https://api.github.com/repos/sentriz/cliphist/releases/latest" \
            | jq -r '.assets[] | select(.name | test("linux.*(amd64|x86_64)")) | .browser_download_url' \
            | head -1)
        if [ -z "$CLIPHIST_URL" ]; then
            warn "Could not resolve cliphist download URL — skipping"
        else
            curl -fsSL -o /tmp/cliphist "$CLIPHIST_URL"
            chmod +x /tmp/cliphist
            sudo mv /tmp/cliphist /usr/local/bin/cliphist
        fi
    fi

    git clone https://github.com/elkowar/eww
    cd eww
    cargo build --release --no-default-features --features=wayland
    cd target/release
    chmod +x ./eww
    cd ..
    cd ..
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

    # Copy wallpapers (mp4/gif + static images)
    shopt -s nullglob
    wallpapers=("$SCRIPT_DIR/sway/wallpapers/"*.{mp4,gif,png,jpg,jpeg,webp,bmp})
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
    cp "$SCRIPT_DIR/eww-config/eww.yuck"         "$CONFIG_DIR/eww/"
    cp "$SCRIPT_DIR/eww-config/eww.scss"         "$CONFIG_DIR/eww/"

    # Create directories that keybinds assume exist
    mkdir -p "$HOME/Videos"

    # Ensure ~/.local/bin is in PATH (needed for kitty from official installer,
    # and any other user-local binaries). Sway inherits the login shell PATH,
    # so this must be in the profile, not just the current session.
    if ! grep -q '\.local/bin' "$HOME/.profile" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
    fi

    # Ensure snap app .desktop files are visible to wofi
    if ! grep -q "snapd/desktop" "$HOME/.profile" 2>/dev/null; then
        cat >> "$HOME/.profile" << 'EOF'

# Snap desktop files for wofi app launcher
if [ -d /var/lib/snapd/desktop ]; then
    export XDG_DATA_DIRS="/var/lib/snapd/desktop:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
fi
EOF
    fi

    # Bug fix 1: polkit rule so systemctl poweroff/reboot works without a password
    # dialog from the powermenu. Without this, systemctl silently fails for
    # non-root users even when a polkit agent is running.
    sudo tee /etc/polkit-1/rules.d/50-power.rules > /dev/null << 'EOF'
polkit.addRule(function(action, subject) {
    var powerActions = [
        "org.freedesktop.login1.power-off",
        "org.freedesktop.login1.power-off-multiple-sessions",
        "org.freedesktop.login1.reboot",
        "org.freedesktop.login1.reboot-multiple-sessions"
    ];
    if (powerActions.indexOf(action.id) !== -1 && subject.isInGroup("sudo")) {
        return polkit.Result.YES;
    }
});
EOF

    # Auto-start Sway on login at TTY1
    # The guard prevents starting inside an existing session (SSH, TTY2+, etc.)
    local SWAY_AUTOSTART='
# Auto-start Sway on TTY1
if [ -z "$WAYLAND_DISPLAY" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
    exec sway
fi'

    # Write to both bash and zsh login profiles (installer sets zsh as default
    # but the user may log in before chsh takes effect)
    for profile in "$HOME/.bash_profile" "$HOME/.zprofile"; do
        if ! grep -q "exec sway" "$profile" 2>/dev/null; then
            echo "$SWAY_AUTOSTART" >> "$profile"
        fi
    done
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
    echo "  • User apps (VS Code, Obsidian, Spotify, Docker, Node 24, Miniconda...)"
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
    deploy_configs
    enable_services

    echo ""
    log "Installation complete!"
    echo ""
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo "┃  Next steps:                                   ┃"
    echo "┃                                                ┃"
    echo "┃  1. Add a default wallpaper:                   ┃"
    echo "┃     cp wall.png ~/.config/sway/wallpapers/     ┃"
    echo "┃                   default.png                  ┃"
    echo "┃                                                ┃"
    echo "┃  2. Set weather city in ~/.zshrc:              ┃"
    echo "┃     export WEATHER_CITY=\"London\"             ┃"
    echo "┃                                                ┃"
    echo "┃  3. Log out and back in (Docker group, zsh)    ┃"
    echo "┃                                                ┃"
    echo "┃  4. Start Sway:                                ┃"
    echo "┃     exec sway                                  ┃"
    echo "┃                                                ┃"
    echo "┃  5. Enable eww from source:                    ┃"
    echo "┃     ./eww daemon                               |"
    echo "|    ./eww open <window_name>                    ┃"
    echo "┃                                                ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
}

main "$@"
