#!/bin/bash

rm "$DOTFILES/git/gitconfig" >/dev/null
cp "$DOTFILES/git/gitconfig_template" "$DOTFILES/git/gitconfig"

if [ -z "$GIT_EMAIL" ]; then
	printf "Git config - Please enter your email address \n"
	echo "> "
	read -r GIT_EMAIL
	echo "GIT_EMAIL=$GIT_EMAIL" >>"$DOTFILES/zsh/zshenv"
fi

sed -i -e "s/<email>/${GIT_EMAIL}/g" "$DOTFILES/git/gitconfig"

if [ -z "$GIT_USER" ]; then
	printf "Git config - Please enter your name \n"
	echo "> "
	read -r GIT_USER
	echo "GIT_USER=$GIT_USER" >>"$DOTFILES/zsh/zshenv"
fi

sed -i -e "s/<name>/${GIT_USER}/g" "$DOTFILES/git/gitconfig"

ln -sfv "$DOTFILES"/git/gitconfig "$HOME"/.gitconfig
ln -sfv "$DOTFILES"/git/gitignore_global "$HOME"/.gitignore_global
ln -sfv "$DOTFILES"/git/gitattributes_global "$HOME"/.gitattributes_global

# Set the global hooks
# git config --global init.templatedir "$DOTFILES/git/templates"
# Change user.email locally for a single project
# git config user.email darko.tasevski@workmail.com 