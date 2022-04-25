#!/bin/bash

if [ ! -d "$TMUXDIR" ]; then
	mkdir "$TMUXDIR"
fi

rm "$DOTFILES/tmux/tmux.conf" >/dev/null
cp "$DOTFILES/tmux/tmuxconfig_template" "$DOTFILES/tmux/tmux.conf"
sed -i "s|__TMUXDIR__|${TMUXDIR}|g" "$DOTFILES"/tmux/tmux.conf
ln -sf "$DOTFILES/tmux/tmux.conf" "$TMUXDIR"

git clone https://github.com/tmux-plugins/tpm "$TMUXDIR/plugins/tpm"

tmux source "$TMUXDIR"/tmux.conf
# Fix for tmp crashing because TMUX_PLUGIN_MANAGER_PATH is not defined
# @see https://giters.com/Ynjxsjmh/dotfiles
# export TMUX_PLUGIN_MANAGER_PATH="$TMUXDIR/plugins"
"$TMUXDIR"/plugins/tpm/bin/install_plugins

for file in "$DOTFILES"/tmux/*.proj; do
	ln -sfv "$file" "$TMUXDIR"
done
