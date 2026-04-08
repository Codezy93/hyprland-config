#/bin/bash
log() { echo -e "\e[32m$1\e[0m"; }

log "Installing packages from pacman"

sudo pacman -S --needed --noconfirm \
  hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  greetd greetd-tuigreet \
  waybar wofi dunst hyprpaper hyprlock hypridle gvfs \
  pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol \
  networkmanager bluez bluez-utils blueman \
  grim slurp wl-clipboard wf-recorder \
  nwg-look qt5ct noto-fonts ttf-font-awesome \
  polkit-gnome brightnessctl playerctl cliphist xdg-utils \
  git base-devel kitty tmux zsh thunar podman flatpak \
  ninja meson github-cli cmake curl neovim

sudo pacman -S --needed gtk3 gtk-layer-shell \
  pango gdk-pixbuf2 libdbusmenu-gtk3 cairo \
  glib2 gcc-libs glibc

mkdir -p "$HOME/.config"

cp -r dunst "$HOME/.config/dunst"
cp -r eww-config "$HOME/.config/eww"
cp -r gtklock "$HOME/.config/gtklock"
cp -r hypr "$HOME/.config/hypr"
cp -r kitty "$HOME/.config/kitty"
cp -r waybar "$HOME/.config/waybar"
cp -r wofi "$HOME/.config/wofi"

log "Downloading Yay"
git clone https://aur.archlinux.org/yay.git
log "Setting up Yay"
(
  cd yay
  makepkg -si
)

yay -S libmpv-git 

git clone https://aur.archlinux.org/snapd.git
(
  cd snapd
  makepkg -si
  sudo systemctl enable --now snapd.socket
  sudo ln -s /var/lib/snapd/snap /snap
)

git clone --single-branch https://github.com/GhostNaN/mpvpaper
(
  cd mpvpaper
  meson setup build --prefix=/usr/local
  ninja -C build
  ninja -C build install
)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
git clone https://github.com/elkowar/eww
(
  cd eww
  cargo build --release --no-default-features --features=wayland
  cd target/release
  chmod +x ./eww
  ./eww daemon
)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

sudo snap install snap-store
sudo snap install obsidian --classic
sudo snap install qalculate
sudo snap install dbgate
sudo snap install bitwarden
sudo snap install thunderbird
sudo snap install spotify
sudo snap install code --classic
sudo snap install libreoffice

yay -S localsend-bin

flatpak install flathub io.podman_desktop.PodmanDesktop
flatpak install flathub app.zen_browser.zen

mpvpaper ALL /path/to/video

sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

chsh -s "$(which zsh)"

git config --global user.email "virajsparadkar@gmail.com"
git config --global user.name "Viraj"