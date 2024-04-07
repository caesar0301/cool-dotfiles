" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
"let mapleader = ","
"let maplocalleader = ","

" Paste mode (conflicts with autopairs)
"set paste

" vim copy to clipboard
set clipboard+=unnamedplus

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" In case default invalid default python version
if $NVIM_PYTHON3 != ""
  let g:python3_host_prog = substitute(system('echo ${NVIM_PYTHON3}'), '\n', '', '') .. '/bin/python3'
endif
