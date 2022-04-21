#!/bin/bash

ln -sfv "$DOTFILES"/javascript/npmrc "$HOME"/.npmrc

[ ! -f "$NPM_PATH"/bin/bars ] && npm i -g https://github.com/jez/bars.git

[ ! -d "$NPM_PATH"/lib/node_modules/typescript ] && npm i -g typescript

curl -o- -L https://yarnpkg.com/install.sh | bash