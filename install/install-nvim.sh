#!/bin/bash

# rm $VIMCONFIG/pluggedconf &>/dev/null
# rm $VIMCONFIG/ftplugin &>/dev/null

# Create all necessary folders for neovim
if [ ! -d "$VIMCONFIG" ]; then
	mkdir "$VIMCONFIG"
	# install neovim plugin manager
	curl -fLo ~/.dotfiles/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# install vim session folder
mkdir -p "$VIMCONFIG/sessions"

# install nvim config
ln -sfv "$DOTFILES/nvim/init.vim" "$VIMCONFIG"
ln -sfv "$DOTFILES/nvim/init_plugins.vim" "$VIMCONFIG"

# Install all mandatory folders if they don't exist already
mkdir -p "$VIMCONFIG/plugged"
mkdir -p "$VIMCONFIG/backup"
mkdir -p "$VIMCONFIG/undo"
mkdir -p "$VIMCONFIG/swap"
mkdir -p "$VIMCONFIG/after"

# Install Godoctor for vim
if [ ! -d "$VIMCONFIG/godoctor.vim" ]; then
	git clone "https://github.com/godoctor/godoctor.vim" "$VIMCONFIG/godoctor.vim"
fi

# If no projects configured create an empty file
if [ ! -f "$VIMCONFIG/projects.nvimrc" ]; then
	touch "$VIMCONFIG/projects.nvimrc"
fi

# configuration of different plugins
ln -sfv "$DOTFILES/nvim/pluggedconf" "$VIMCONFIG"

# configuration of coc
ln -sfv "$DOTFILES/nvim/coc-settings.json" "$VIMCONFIG/coc-settings.json"

# color schemes
ln -sfv "$DOTFILES/nvim/colors" "$VIMCONFIG"

# indentation
rm -rfv "$VIMCONFIG/after/indent"
ln -sfv "$DOTFILES/nvim/after/indent" "$VIMCONFIG/after"

# lua
rm -rfv "$VIMCONFIG/lua"
ln -sfv "$DOTFILES/nvim/lua" "$VIMCONFIG"

# snippets
rm -rfv "$VIMCONFIG/UltiSnips"
ln -sfv "$DOTFILES/nvim/UltiSnips" "$VIMCONFIG"

# :help ftplugin
ln -sfv "$DOTFILES/nvim/ftplugin" "$VIMCONFIG"

# :help ftdetect
ln -sfv "$DOTFILES/nvim/ftdetect" "$VIMCONFIG"

# :help autoload
ln -sfv "$DOTFILES/nvim/autoload" "$VIMCONFIG"

# thesaurus
rm -rfv "$VIMCONFIG/thesaurus"
ln -sfv "$DOTFILES/nvim/thesaurus" "$VIMCONFIG"

# spell files
ln -sfv "$DOTFILES/nvim/spell" "$VIMCONFIG"
