#!/bin/bash

mkdir -p "$BASHDIR"

ln -sfv "$DOTFILES"/bash/profile "$HOME"/.profile
ln -sfv "$DOTFILES"/bash/bashrc "$HOME"/.bashrc
