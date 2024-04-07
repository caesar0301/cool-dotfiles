" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
"let mapleader = ","
"let maplocalleader = ","

" Paste mode (conflicts with autopairs)
" set paste

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" vim copy to clipboard
set clipboard+=unnamedplus

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Detect OS type
if !exists("g:os_type")
  if has("win64") || has("win32") || has("win16")
    let g:os_type = "Windows"
  else
    let g:os_type = substitute(system('uname'), '\n', '', '')
  endif
endif

" In case default invalid default python version
if $NVIM_PYTHON3 != ""
  let g:python3_host_prog = substitute(system('echo ${NVIM_PYTHON3}'), '\n', '', '') .. '/bin/python3'
endif

" Edit vimr configuration file
nnoremap <leader>ve :e $MYVIMRC<cr>

" Reload vimr configuration file
nnoremap <leader>vr :source $MYVIMRC<cr>

" Quickly quit terminal mode: <C-\><C-n>
tnoremap <leader>kt <C-\><C-n>
