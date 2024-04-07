" Remap VIM 0 to first non-blank character
map 0 ^

" Goto line head and tail
map <C-a> <ESC>^
imap <C-a> <ESC>I
map <C-e> <ESC>$
imap <C-e> <ESC>A

" Map <leader> to / (search) and Ctrl-<leader> to ? (backwards search)
map <space> /
map <C-space> ?
