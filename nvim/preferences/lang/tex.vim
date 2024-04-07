" Plugin => vimtex
" Keymap:
"  <localleader>ll: compiling doc continuously
"  <localleader>lk: stop compiling
"  <localleader>lc: clear auxiliary files
"  <localleader>lv: forward search
"  <localleader>le: QuickFix
"  <localleader>lt: show content table
au BufRead,BufNewFile *.tex setlocal textwidth=80

" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_view_method = 'skim'
" Or with a generic interface:
"let g:vimtex_view_general_viewer = 'okular'
"let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_quickfix_mode = 2
let g:vimtex_quickfix_autoclose_after_keystrokes=1
let g:vimtex_quickfix_open_on_warning = 0
