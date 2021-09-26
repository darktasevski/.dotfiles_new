#!/bin/bash

if [ ! -d "$TMUXDIR" ]; then
	mkdir "$TMUXDIR"
fi

git clone https://github.com/tmux-plugins/tpm "$TMUXDIR/plugins/tpm"
ln -sf "$DOTFILES/tmux/tmux.conf" "$TMUXDIR"
tmux source "$TMUXDIR"/tmux.conf
# Fix for tmp crashing because TMUX_PLUGIN_MANAGER_PATH is not defined
# @see https://giters.com/Ynjxsjmh/dotfiles
export TMUX_PLUGIN_MANAGER_PATH="$TMUXDIR/plugins"
"$TMUXDIR/plugins/tpm/bin/install_plugins"

for file in "$DOTFILES"/tmux/*.proj; do
	ln -sfv "$file" "$TMUXDIR"
done
