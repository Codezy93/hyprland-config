#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOG_FILE="/tmp/dusk-garden-install-$(date +%Y%m%d_%H%M%S).log"

write_file(){
    local current="$1"
    local next=$((current + 1))
    echo "$next" > "${SCRIPT_DIR}/checkpoint"
}

install_package_manager(){
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    git clone https://aur.archlinux.org/snapd.git
    cd snapd
    makepkg -si
    sudo systemctl enable --now snapd.socket
    sudo ln -s /var/lib/snapd/snap /snap
    cd ..
    sudo pacman -S podman
    write_file 0
    sudo reboot now
}

install_from_binary(){
    local url="$1"
    curl -O "$url"
    IFS='/' read -ra name <<< "$url"
    name="${name[-1]}"
    sudo tar -C /opt -xzf "${name}"
    IFS='.' read -ra app <<< "$name"
    app="${app[0]}"
    export PATH="$PATH:/opt/$app/bin"
}

install_from_script(){
    curl -O "$1"
    IFS='/' read -ra name <<< "$1"
    local name="${name[-1]}"
    chmod +x "${name}"
    ./"${name}"
    rm ./"${name}"
}

install_hyprland(){
    sudo pacman -S hyprland hyprlock hypridle hyprutils hyprpaper \
    xdg-desktop-portal-hyprland waybar wofi dunst libnotify kitty mpvpaper \
    thunar thunar-archive-plugin thunar-volman apple-cursor eww-wayland \
    pipewire pipewire-pulse pipewire-alsa wireplumber network-manager-applet blueman\
    nwg-look qt5ct qt6ct wl-clipboard cliphist grimblast-git jq curl \
    wf-recorder slurp ttf-jetbrains-mono-nerd ttf-caskaydia-cove-nerd \
    noto-fonts noto-fonts-emoji ttf-font-awesome otf-font-awesome \
    brightnessctl playerctl pavucontrol polkit-kde-agent
}

install_apps(){
    sudo pacman -S tmux zsh neovim github-cli
    yay -S brave-bin
    sudo snap install obsidian --classic
    sudo snap install qalculate
    sudo snap install dbgate
    sudo snap install bitwarden
    sudo snap install thunderbird
    sudo snap install spotify
    sudo snap install code --classic
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    install_from_script https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    install_from_binary https://github.com/Kitware/CMake/releases/download/v4.3.0/cmake-4.3.0-linux-x86_64.tar.gz
    install_from_binary https://download.oracle.com/java/26/latest/jdk-26_linux-x64_bin.tar.gz
    install_from_binary https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.46-src.tar.gz
    install_from_binary https://dl.pstmn.io/download/latest/linux_64
    install_from_binary https://cran.rstudio.com/src/base/R-4/R-4.5.3.tar.gz
}

deploy_config(){
    mkdir "$CONFIG_DIR/hypr/scripts"
    mkdir "$CONFIG_DIR/hypr/themes"
    mkdir "$CONFIG_DIR/hypr/wallpapers"
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
    shopt -s nullglob
    wallpapers=("$SCRIPT_DIR/hypr/wallpapers/"*.{mp4,gif})
    shopt -u nullglob
    cp "${wallpapers[@]}" "$CONFIG_DIR/hypr/wallpapers/"
    mkdir -p "$CONFIG_DIR/waybar"
    cp "$SCRIPT_DIR/waybar/config.jsonc"    "$CONFIG_DIR/waybar/"
    cp "$SCRIPT_DIR/waybar/style.css"       "$CONFIG_DIR/waybar/"
    mkdir -p "$CONFIG_DIR/wofi"
    cp "$SCRIPT_DIR/wofi/config"            "$CONFIG_DIR/wofi/"
    cp "$SCRIPT_DIR/wofi/style.css"         "$CONFIG_DIR/wofi/"
    mkdir -p "$CONFIG_DIR/dunst"
    cp "$SCRIPT_DIR/dunst/dunstrc"          "$CONFIG_DIR/dunst/"
    mkdir -p "$CONFIG_DIR/kitty"
    cp "$SCRIPT_DIR/kitty/kitty.conf"       "$CONFIG_DIR/kitty/"
    mkdir -p "$CONFIG_DIR/eww"
    cp "$SCRIPT_DIR/eww/eww.yuck" "$CONFIG_DIR/eww/"
    cp "$SCRIPT_DIR/eww/eww.scss" "$CONFIG_DIR/eww/"
    chsh -s /usr/bin/zsh
    if [ -d /usr/share/icons/macOS-Monterey ] || [ -d /usr/share/icons/macOS ] || pacman -Qi apple-cursor &>/dev/null; then
        mkdir -p "$HOME/.icons/default"
        cat > "$HOME/.icons/default/index.theme" << 'EOF'
[Icon Theme]
Inherits=macOS-Monterey
EOF
    fi
}

install_nvidia(){
    sudo pacman -S nvidia-dkms nvidia-utils nvidia-settings lib32-nvidia-utils egl-wayland
    sed -i 's|^# source = ~/.config/hypr/nvidia.conf|source = ~/.config/hypr/nvidia.conf|' "$CONFIG_DIR/hypr/hyprland.conf"
    if grep -q "nvidia_drm.modeset=1" /proc/cmdline 2>/dev/null; then
        echo "nvidia_drm.modeset=1 is set."
    else
        echo ""
        echo -e "  Add to your bootloader:"
        echo -e "  GRUB: Edit /etc/default/grub"
        echo -e "        GRUB_CMDLINE_LINUX_DEFAULT=\"... nvidia_drm.modeset=1\""
        echo -e "        Then run: sudo grub-mkconfig -o /boot/grub/grub.cfg"
        echo ""
        echo -e "  systemd-boot: Edit /boot/loader/entries/*.conf"
        echo -e "        options ... nvidia_drm.modeset=1"
        echo ""
    fi
    if grep -q "nvidia" /etc/mkinitcpio.conf 2>/dev/null; then
        echo "NVIDIA modules found in mkinitcpio.conf."
    else
        echo -e "  Add to MODULES: (nvidia nvidia_modeset nvidia_uvm nvidia_drm)"
        echo -e "  Then run: sudo mkinitcpio -P"
        echo ""
    fi

    # pacman hook for NVIDIA
    HOOK_DIR="/etc/pacman.d/hooks"
    if [ ! -f "$HOOK_DIR/nvidia.hook" ]; then
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
    fi
}

enable_services(){
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

while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%$'\r'}"
    if [[ "$line" == "0" ]]; then
        install_package_manager
        write_file "1"
    fi
    if [[ "$line" == "1" ]]; then
        install_hyprland
        write_file "2"
    fi
    if [[ "$line" == "2" ]]; then
        install_apps
        write_file "3"
    fi
    if [[ "$line" == "3" ]]; then
        deploy_config
        write_file "4"
    fi
    if [[ "$line" == "4" ]]; then
        install_nvidia
        write_file "5"
    fi
    if [[ "$line" == "5" ]]; then
        enable_services
        write_file "6"
    fi
done < "${SCRIPT_DIR}/checkpoint"