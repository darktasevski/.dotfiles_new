#!/bin/bash

ln -sfv "$SECURE_STORAGE"/KEYS/ssh "$HOME"/.ssh
ln -sfv "$SECURE_STORAGE"/KEYS/gnupg "$HOME"/.gnupg

sudo chmod 755 "$HOME"/.ssh
sudo chmod 755 "$HOME"/.gnupg
