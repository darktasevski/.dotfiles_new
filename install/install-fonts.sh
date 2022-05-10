#!/bin/bash

if [[ -d "$FONTSDIR" ]]; then
   if [[ "$(uname)" == "Linux" ]]; then
		sudo cp -R "$FONTSDIR"/* /usr/share/fonts/
		fc-cache -v
	elif [[ "$(uname)" == "Darwin" ]]; then
		# https://stackoverflow.com/a/33868938/7453363
		sudo cp -R "$FONTSDIR"/* "$HOME"/Library/Fonts/
	fi
fi
