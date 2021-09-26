#!/bin/bash

mkdir -p "$ZDOTDIR"

ln -sfv "$DOTFILES"/zsh/zshenv "$HOME"/.zshenv
ln -sfv "$DOTFILES"/zsh/zshrc "$ZDOTDIR"/.zshrc
ln -sfv "$DOTFILES"/zsh/dircolors "$ZDOTDIR"/dircolors
