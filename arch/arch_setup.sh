#!/usr/bin/env bash
set -euo pipefail

log() { echo -e "\e[32m$1\e[0m"; }

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

install_config_dir() {
  local source_dir="$1"
  local target_dir="$2"

  mkdir -p "$target_dir"
  cp -r "$source_dir"/. "$target_dir"/
}

ensure_yay() {
  if command -v yay >/dev/null 2>&1; then
    return
  fi

  local tmp_dir
  tmp_dir="$(mktemp -d)"

  log "Installing yay"
  git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
  (
    cd "$tmp_dir/yay"
    makepkg -si --noconfirm
  )
  rm -rf "$tmp_dir"
}

log "Installing core Arch + Hyprland packages"
sudo pacman -S --needed --noconfirm \
  hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  greetd greetd-tuigreet \
  waybar wofi dunst hyprpaper hyprlock hypridle gvfs thunar \
  pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol \
  networkmanager network-manager-applet bluez bluez-utils blueman \
  grim slurp wl-clipboard wf-recorder \
  nwg-look qt6ct adw-gtk-theme noto-fonts ttf-font-awesome ttf-jetbrains-mono-nerd \
  polkit-gnome brightnessctl ddcutil playerctl cliphist libnotify xdg-utils \
  git base-devel kitty tmux zsh podman flatpak \
  github-cli curl neovim

mkdir -p "$CONFIG_DIR"

install_config_dir "$SCRIPT_DIR/dunst" "$CONFIG_DIR/dunst"
install_config_dir "$SCRIPT_DIR/eww-config" "$CONFIG_DIR/eww"
install_config_dir "$SCRIPT_DIR/hypr" "$CONFIG_DIR/hypr"
install_config_dir "$SCRIPT_DIR/kitty" "$CONFIG_DIR/kitty"
install_config_dir "$SCRIPT_DIR/waybar" "$CONFIG_DIR/waybar"
install_config_dir "$SCRIPT_DIR/wofi" "$CONFIG_DIR/wofi"
chmod +x "$CONFIG_DIR"/hypr/scripts/*.sh

ensure_yay

log "Installing AUR packages used by this setup"
yay -S --needed --noconfirm \
  mpvpaper \
  eww \
  localsend-bin

curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
curl -fsSL https://ollama.com/install.sh | sh

if command -v flatpak >/dev/null 2>&1; then
  log "Configuring Flatpak"
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install -y flathub io.podman_desktop.PodmanDesktop
  flatpak install -y flathub app.zen_browser.zen
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing Oh My Zsh"
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

log "Enabling services"
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

if command -v zsh >/dev/null 2>&1; then
  chsh -s "$(command -v zsh)"
fi

git config --global user.email "virajsparadkar@gmail.com"
git config --global user.name "Viraj"

log "Arch Hyprland setup complete"
