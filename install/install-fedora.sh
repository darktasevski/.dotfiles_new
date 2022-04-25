#!/bin/sh

## Default dirs
mkdir -p "$HOME/Games" "$HOME/Code" "$HOME/Media"
mkdir -p "$HOME/Media/Screenshots" "$HOME/Media/Wallpapers" "$HOME/Media/Pictures" "$HOME/Media/Videos" "$HOME/Media/Screencasts"

sudo dnf -y upgrade --refresh
sudo dnf groupupdate core

# Import RPM Fusion Free
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
# Import RPM Fusion Nonfree
sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf -y install dnf-plugins-core
# extra Fedora repositories
sudo dnf -y install fedora-workstation-repositories

sudo dnf config-manager --set-enabled google-chrome
sudo dnf config-manager --add-repo=https://negativo17.org/repos/fedora-spotify.repo  
sudo dnf config-manager --set-enabled fedora-cisco-openh264

sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo dnf update --refresh

sudo dnf install \*-firmware\
sudo dnf -y install google-chrome-stable
sudo dnf -y install gstreamer1-plugin-openh264 mozilla-openh264

sudo dnf -y shell "$DOTFILES"/fedora/packages.dnf

# Set default shell to zsh
# sudo chsh -s "$(which zsh)"
sudo usermod -s "$(which zsh)" "$USER"

# Node.js version management
curl -L https://git.io/n-install | bash

sudo dnf -y copr enable atim/bandwhich
sudo dnf -y install bandwhich

sudo dnf -y copr enable kopfkrieg/diff-so-fancy
sudo dnf -y install diff-so-fancy

sudo dnf -y copr enable varlad/onefetch
sudo dnf -y install onefetch

sudo dnf -y copr enable bugzy/lector
sudo dnf -y install lector

sudo dnf -y copr enable t0xic0der/nvidia-auto-installer-for-fedora
sudo dnf -y install nvautoinstall

sudo dnf -y copr enable joseexposito/touchegg
sudo dnf -y install touchegg

# curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
# sudo dnf -y install yarn

wget https://downloads.slack-edge.com/releases/linux/4.21.1/prod/x64/slack-4.21.1-0.1.fc21.x86_64.rpm
sudo dnf -y localinstall slack-4.21.1-0.1.fc21.x86_64.rpm

wget https://zoom.us/client/latest/zoom_x86_64.rpm 
sudo dnf -y localinstall zoom_x86_64.rpm 

wget https://download.cdn.viber.com/desktop/Linux/viber.rpm
sudo dnf -y localinstall viber.rpm 

wget https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.10453-1.x86_64.rpm
sudo dnf -y localinstall teams-1.5.00.10453-1.x86_64.rpm

wget https://www.expressvpn.works/clients/linux/expressvpn-3.21.0.2-1.x86_64.rpm
sudo dnf -y localinstall expressvpn-3.21.0.2-1.x86_64.rpm

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf -y install code

sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf -y install 1password

sudo dnf update --refresh

sudo dnf -y install snapd
sudo ln -s /var/lib/snapd/snap /snap

sudo dnf clean all

sudo snap install ngrok
sudo snap install espanso --classic --channel=latest/edge
sudo snap install geogebra-discovery
sudo snap install postman
sudo snap install webstorm --classic
sudo snap install intellij-idea-ultimate --classic

espanso service register    # Register espanso as a systemd service (required only once)
espanso start 				# Start espanso

pip3 install td-watson
pip3 install tmuxp
pip3 install Pygments

# Switch to dark theme
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

ln -sfv "$DOTFILES"/fedora/set_screen.desktop "$HOME"/.config/autostart/set_screen.desktop
ln -sfv "$DOTFILES"/fedora/XCompose "$HOME"/.XCompose
