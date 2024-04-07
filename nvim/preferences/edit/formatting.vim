" with formatter.nvim
nnoremap <silent> <leader>af :Format<cr>

" format on save (disabled)
" coflicted with nvim-autopair
" augroup autoformat
"     :autocmd!
"     au BufWrite *.go :Format
"     au BufWrite *.lisp,*.scm,*.ss :Format
"     au BufWrite *.tex :Format
"     au BufWrite *.rs :Format
"     " au BufWrite *.sh :Format
"     " au BufWrite *.h,*.hpp,*.C,*.cc,*.cpp,*.CPP,*.c++ :Format
"     " au BufWrite *.cmake :Format
"     autocmd User FormatterPost lua print "autoformat group"
" augroup END
" doautoall autoformat BufWrite *
