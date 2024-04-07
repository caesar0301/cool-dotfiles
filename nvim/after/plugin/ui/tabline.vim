" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

"###### Plugin => barar

" Move to previous/next
nnoremap <silent> <A-,> <cmd>BufferPrevious<cr>
nnoremap <silent> <A-.> <cmd>BufferNext<cr>

" Re-order to previous/next
nnoremap <silent> <A-<> <cmd>BufferMovePrevious<cr>
nnoremap <silent> <A->> <cmd>BufferMoveNext<cr>

" Goto buffer in position...
nnoremap <silent> <leader><A-1> <cmd>BufferGoto 1<cr>
nnoremap <silent> <leader><A-2> <cmd>BufferGoto 2<cr>
nnoremap <silent> <leader><A-3> <cmd>BufferGoto 3<cr>
nnoremap <silent> <leader><A-4> <cmd>BufferGoto 4<cr>
nnoremap <silent> <leader><A-5> <cmd>BufferGoto 5<cr>
nnoremap <silent> <leader><A-6> <cmd>BufferGoto 6<cr>
nnoremap <silent> <leader><A-7> <cmd>BufferGoto 7<cr>
nnoremap <silent> <leader><A-8> <cmd>BufferGoto 8<cr>
nnoremap <silent> <leader><A-9> <cmd>BufferGoto 9<cr>
nnoremap <silent> <leader><A-0> <cmd>BufferLast<cr>

" Pin/unpin buffer
nnoremap <silent> <leader><A-p> <cmd>BufferPin<cr>

" Close buffer
nnoremap <silent> <leader><A-x> <cmd>BufferClose<cr>

" Restore buffer
nnoremap <silent> <leader><A-X> <cmd>BufferRestore<cr>

" Close all but current
nnoremap <silent> <leader><A-c> <cmd>BufferCloseAllButCurrent<cr>
