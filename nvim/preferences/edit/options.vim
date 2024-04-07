" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.lisp :call CleanExtraSpaces()

" Turn persistent undo on
" means that you can undo even when you close a buffer/VIM
try
    set undodir=/tmp/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry
