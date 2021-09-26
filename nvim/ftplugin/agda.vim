" source every plugin configs
for file in split(glob($HOME . "/nvim/pluggedconf/agda/*.nvimrc"), '\n')
    exe 'source' file
endfor
