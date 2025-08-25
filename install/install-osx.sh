#!/bin/bash

# Make sure everything under /usr/local belongs to the group admin; and
# Make sure anyone from the group admin can write to anything under /usr/local.  This is not the greatest solution though.
#    chgrp -R admin /usr/local
#    chmod -R g+w /usr/local
#    chgrp -R admin /Library/Caches/Homebrew
#    chmod -R g+w /Library/Caches/Homebrew

# This is a bit better one @see https://gist.github.com/irazasyed/7732946
# sudo chown -R "$(whoami)" /usr/local/Homebrew
# sudo mkdir -p /usr/local/sbin /usr/local/Frameworks
# sudo chown -R "$(whoami)" /usr/local/sbin /usr/local/Frameworks
# sudo install -d -o "$(whoami)" -g admin /usr/local/Frameworks

if ! command -v brew >/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
brew upgrade

if ! command -v volta >/dev/null; then
	curl https://get.volta.sh | bash
fi

# if ! command -v yarn >/dev/null; then
# 	curl -o- -L https://yarnpkg.com/install.sh | bash
# fi

brew bundle install --verbose --file="$DOTFILES"/osx/Brewfile

if ! command -v zsh >/dev/null; then
	brew install zsh
fi

# Remove outdated versions from the cellar.
brew cleanup

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

source "$HOME"/.cargo/env

# Save screenshots to the Pictures/Screenshots
mkdir -p "$HOME"/Pictures/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"
# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

### Safari

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

### Transmission

defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads"

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false
