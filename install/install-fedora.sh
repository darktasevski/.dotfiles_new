#!/bin/sh

## Default dirs
mkdir -p "$HOME/Games" "$HOME/Code" "$HOME/Media"
mkdir -p "$HOME/Media/Screenshots" "$HOME/Media/Wallpapers" "$HOME/Media/Pictures" "$HOME/Media/Videos" "$HOME/Media/Screencasts"

sudo dnf -y upgrade --refresh
sudo dnf groupupdate core

sudo dnf -y shell "$DOTFILES"/fedora/packages.dnf

# Set default shell to zsh
# sudo chsh -s "$(which zsh)"
sudo usermod -s "$(which zsh)" "$USER"

sudo dnf -y copr enable t0xic0der/nvidia-auto-installer-for-fedora
sudo dnf -y install nvautoinstall

wget https://downloads.slack-edge.com/releases/linux/4.21.1/prod/x64/slack-4.21.1-0.1.fc21.x86_64.rpm
sudo dnf -y localinstall slack-4.21.1-0.1.fc21.x86_64.rpm

wget https://zoom.us/client/latest/zoom_x86_64.rpm
sudo dnf -y localinstall zoom_x86_64.rpm

wget https://download.cdn.viber.com/desktop/Linux/viber.rpm
sudo dnf -y localinstall viber.rpm

sudo dnf update --refresh

espanso service register # Register espanso as a systemd service (required only once)
espanso start            # Start espanso

pip3 install td-watson
pip3 install tmuxp
pip3 install Pygments
pip3 install caffeinate # awake
pip3 install PyQt6 --user
pip3 install fuzzywuzzy --user
pip3 install algoliasearch --user
pip3 install simpleeval --user
pip3 install pint --user
