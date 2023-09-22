" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
"let mapleader = ","
"let maplocalleader = ","

" Enable paste mode
set paste

" Sets how many lines of history VIM has to remember
set history=500

" Chinese line wrapping
set fo+=mM

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Show line number
set nu

" Detect OS type
if !exists("g:os_type")
  if has("win64") || has("win32") || has("win16")
    let g:os_type = "Windows"
  else
    let g:os_type = substitute(system('uname'), '\n', '', '')
  endif
endif

" In case default invalid default python version
" PYTHON_HOME in use with higher priority. Otherwise in PATH
if $PYTHON_HOME != ""
  let g:python3_host_prog = substitute(system('echo ${PYTHON_HOME}'), '\n', '', '') .. '/bin/python3'
endif

" vim copy to clipboard
set clipboard+=unnamedplus

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

"" Text, tab and indent related
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

""""""""""""""""""""""""""""""""""
" Git related
""""""""""""""""""""""""""""""""""

" Plugin Git gutter (Git diff)
let g:gitgutter_enabled=0
nnoremap <silent> <leader>gu :GitGutterToggle<cr>

""""""""""""""""""""""""""""""""""
" Misc
""""""""""""""""""""""""""""""""""

" Edit vimr configuration file
nnoremap <leader>ve :e $MYVIMRC<cr>

" Reload vimr configuration file
nnoremap <leader>vr :source $MYVIMRC<cr>

" Quickly quit terminal mode: <C-\><C-n>
tnoremap <leader>kt <C-\><C-n>
