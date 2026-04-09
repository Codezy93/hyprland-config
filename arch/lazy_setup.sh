#!/bin/bash

sudo pacman -S git base-devel kitty tmux zsh podman flatpak github-cli curl neovim
yay -S --needed --noconfirm localsend-bin

curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
curl -fsSL https://ollama.com/install.sh | sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 24
curl -fsS https://dl.brave.com/install.sh | sh

git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo ln -s /var/lib/snapd/snap /snap

sudo apt install snapd
sudo snap install snap-store
sudo snap install obsidian --classic
sudo snap install qalculate
sudo snap install dbgate
sudo snap install bitwarden
sudo snap install thunderbird
sudo snap install spotify
sudo snap install code --classic
sudo snap install proton-mail

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub io.podman_desktop.PodmanDesktop
flatpak install -y flathub app.zen_browser.zen

git config --global user.email "virajsparadkar@gmail.com"
git config --global user.name "Viraj"