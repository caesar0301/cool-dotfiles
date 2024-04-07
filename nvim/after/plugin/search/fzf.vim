" Search the word under the cursor
nnoremap <leader>fw <cmd>call fzf#vim#ag(expand('<cword>'))<cr>

" Search everywhere
nnoremap <leader>fW <cmd>Ag<cr>
