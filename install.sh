#!/bin/bash

# Copy the default config file if not present already

############
# includes #
############

source ./colors.sh
source ./install_functions.sh
source ./zsh/zshenv

################
# presentation #
################

echo -e "
${yellow}
          _ ._  _ , _ ._
        (_ ' ( \`  )_  .__)
      ( (  (    )   \`)  ) _)
     (__ (_   (_ . _) _) ,__)
           ~~\ ' . /~~
         ,::: ;   ; :::,
        ':::::::::::::::'
 ____________/_ __ \______________
|                                 |
| Welcome to Puritanic's dotfiles |
|_________________________________|
"

echo -e "${yellow}!!! ${red}WARNING${yellow} !!!"
echo -e "${light_red}This script will delete all your configuration files!"
echo -e "${light_red}Use it at your own risks."

if [ $# -ne 1 ] || [ "$1" != "-y" ]; then
	echo -e "${yellow}Press a key to continue...\n"
	read -r key
fi

###########
# INSTALL #
###########

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

# Install
dot_sub_install "$DOTFILES"/install/install-zsh.sh
dot_sub_install "$DOTFILES"/install/install-fonts.sh
dot_sub_install "$DOTFILES"/install/install-keys.sh
dot_sub_install "$DOTFILES"/install/install-osx.sh

dot_is_installed git && dot_install git
dot_is_installed nvim && dot_install nvim
dot_is_installed tmux && dot_install tmux
dot_is_installed npm && dot_install javascript
