#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt install -y tmux zsh neovim curl wget git gh gcc kitty ca-certificates

sudo snap install obsidian --classic
sudo snap install qalculate
sudo snap install dbgate
sudo snap install bitwarden
sudo snap install thunderbird
sudo snap install spotify
sudo snap install code --classic

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
wget -O docker.deb https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64
sudo apt-get update
sudo apt install ./docker.deb

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -fsS https://dl.brave.com/install.sh | sh

wget -O "miniconda.sh" https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x ./miniconda.sh
./miniconda.sh
rm miniconda.sh

chsh -s "$(which zsh)"

git config --global user.email "virajsparadkar@gmail.com"
git config --global user.name "Viraj"   