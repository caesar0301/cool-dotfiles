""""""""""""""""""""""""""""""
" Copy & Paste
""""""""""""""""""""""""""""""
let g:yankstack_yank_keys = ['y', 'd']

"nmap <C-p> <Plug>yankstack_substitute_older_paste
"nmap <C-n> <Plug>yankstack_substitute_newer_paste

""""""""""""""""""""""""""""""""""
" Spell checking
""""""""""""""""""""""""""""""""""

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Eanble checking for textual files
autocmd FileType markdown setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell

""""""""""""""""""""""""""""""""""
" Code Format
""""""""""""""""""""""""""""""""""

" Plugins => vim-autoformat
" Some dependencies:
"   Python: sudo pip install black
"   JS & JSON: npm install -g js-beautify
"   HTTP: npm install -g js-beautify
"   CSS: npm install -g js-beautify
"   Ruby: gem install ruby-beautify
"   Golang: gofmt
"   Rust: rustfmt
"   Perl: cpanm Perl::Tidy
"   Haskell: stylish-haskell
"   Markdown: npm install -g remark-cli
"   Shell: shfmt
"   Lua: npm install lua-fmt
"   SQL: pip install sqlformat
"   CMake: pip install cmake_format
"   LaTeX: brew install latexindent
"   OCaml: opam install ocamlformat
"   LISP/Scheme: npm install -g scmindent
nnoremap <silent> <leader>af :Autoformat<cr>
let g:autoformat_verbosemode=1
let g:autoformat_autoindent=0
let g:autoformat_retab=1
let g:autoformat_remove_trailing_spaces=1
" Formatter definer
let g:formatdef_gjf='"java -jar ~/.local/bin/google-java-format-1.15.0-all-deps.jar -"'
let g:formatdef_gofmt_1='"gofmt"'
let g:formatdef_cmakefmt='"cmake-format -"'
let g:formatdef_clangformat= '"clang-format -"'
let g:formatdef_pyfmt='"black -"'
let g:formatdef_latexindent = '"latexindent -"'
let g:formatdef_scmindent = '"scmindent -"'
let g:formatdef_luafmt = '"luafmt --stdin"'
" Formatter user
let g:formatters_java=['gjf']
let g:formatters_cmake=['cmakefmt']
let g:formatters_cpp=['clangformat']
let g:formatters_python=['pyfmt']
let g:formatters_lisp=['scmindent']
let g:formatters_scheme=['scmindent']
let g:formatters_lua=['luafmt']

" Autoformat on save
au BufWrite *.h *.hpp *.C *.cc *.cpp *.CPP *.c++ *.go *.py *.lua :Autoformat

""""""""""""""""""""""""""""""""""
" Edit misc
""""""""""""""""""""""""""""""""""

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

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
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

" Plugin => surround.vim
" Annotate strings with gettext
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>
