" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Eanble checking for textual files
"autocmd FileType markdown setlocal spell spelllang=en_us
"autocmd BufRead,BufNewFile *.md setlocal spell spelllang=en_us
