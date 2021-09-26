" use real tabs in .go files, not spaces
setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab

" source every plugin configs
for file in split(glob($HOME . "/nvim/pluggedconf/go/*.nvimrc"), '\n')
    exe 'source' file
endfor
