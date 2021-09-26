" source every plugin configs
for file in split(glob($HOME . "/nvim/pluggedconf/csv/*.nvimrc"), '\n')
    exe 'source' file
endfor
