#!/bin/bash

if [[ -d "$SECURE_STORAGE" ]]; then
	ln -sfv "$SECURE_STORAGE"/ssh "$HOME"/.ssh
	ln -sfv "$SECURE_STORAGE"/gnupg "$HOME"/.gnupg

	sudo chmod 755 "$HOME"/.ssh
	sudo chmod 755 "$HOME"/.gnupg
else
	echo "No secure storage found"
fi
