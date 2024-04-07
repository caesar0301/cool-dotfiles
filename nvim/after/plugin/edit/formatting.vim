" with formatter.nvim
nnoremap <silent> <leader>af :FormatLock<cr>

" format on save
augroup autoformat
    :autocmd!
    au BufWrite *.go :FormatLock
    au BufWrite *.lisp,*.scm,*.ss :FormatLock
    au BufWrite *.tex :FormatLock
    au BufWrite *.rs :FormatLock
    " au BufWrite *.sh :FormatLock
    " au BufWrite *.h,*.hpp,*.C,*.cc,*.cpp,*.CPP,*.c++ :FormatLock
    " au BufWrite *.cmake :FormatLock
    autocmd User FormatterPost lua print "autoformat group performed"
augroup END
doautoall autoformat BufWrite *

