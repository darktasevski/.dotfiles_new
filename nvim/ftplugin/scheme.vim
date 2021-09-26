set nospell

for file in split(glob($HOME . "/nvim/pluggedconf/lisp/*.nvimrc"), '\n')
    exe 'source' file
endfor
