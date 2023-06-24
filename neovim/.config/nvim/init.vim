"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Xiaming Chen - @caesar0301
" Prerequisites:
"       vim-plug: https://github.com/junegunn/vim-plug
"       neovim: 0.8+
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Manager plugin by Packer
lua require('packer_plugins')


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Chinese line wrapping
set fo+=mM

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let maplocalleader = ","

" Fast saving
nmap <leader>w :w!<cr>

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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Add a bit extra margin to the left
set foldcolumn=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert
catch
endtry

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""
" Basics => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" You can select a paragraph by typing vip or vap

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <C-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Close other buffers but this one
map <leader>bo :%bd\|e#\|bd#<cr>\|'""'

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Goto line head and tail
map <C-a> <ESC>^
imap <C-a> <ESC>I
map <C-e> <ESC>$
imap <C-e> <ESC>A


""""""""""""""""""""""""""""""
" Basics => lightline
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
set noshowmode

" Plugin lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'gitbranch', 'filename', 'modified'] ],
      \   'right': [ ['lineinfo'], ['percent'], ['lspstatus'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}',
      \   'lspstatus': '%{exists("*LspStatus")?LspStatus():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

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

" FIXME by @caesar0301
autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.lisp :call CleanExtraSpaces()

" Highlight variable under cursor
"augroup highlight_current_word
"  au!
"  au CursorHold * :exec 'match Search /\V\<' . expand('<cword>') . '\>/'
"  set updatetime=1000
"augroup END

nnoremap gr :s/<c-r>///g<left><left>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Edit vimr configuration file
nnoremap <leader>ve :e $MYVIMRC<CR>

" Reload vimr configuration file
nnoremap <leader>vr :source $MYVIMRC<CR>

" Quickly quit terminal mode: <C-\><C-n>
tnoremap <leader>kt <C-\><C-n>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Languages:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" Languages => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f # --- <esc>a
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def

autocmd BufRead,BufNewFile SConstruct set filetype=python
autocmd BufRead,BufNewFile SConscript set filetype=python


""""""""""""""""""""""""""""""
" Languages => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript,typescript imap <C-t> console.log();<esc>hi
au FileType javascript,typescript imap <C-a> alert();<esc>hi

au FileType javascript,typescript inoremap <buffer> $r return
au FileType javascript,typescript inoremap <buffer> $f // --- PH<esc>FP2xi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction


""""""""""""""""""""""""""""""
" Languages => CoffeeScript section
"""""""""""""""""""""""""""""""
function! CoffeeScriptFold()
    setl foldmethod=indent
    setl foldlevelstart=1
endfunction
au FileType coffee call CoffeeScriptFold()

au FileType gitcommit call setpos('.', [0, 1, 1, 0])


""""""""""""""""""""""""""""""
" Languages => Shell section
""""""""""""""""""""""""""""""
if exists('$TMUX')
    set termguicolors
endif


""""""""""""""""""""""""""""""
" Languages => Twig section
""""""""""""""""""""""""""""""
autocmd BufRead *.twig set syntax=html filetype=html


""""""""""""""""""""""""""""""
" Languages => Markdown
""""""""""""""""""""""""""""""
let vim_markdown_folding_disabled = 1
au BufRead,BufNewFile *.md setlocal textwidth=80


""""""""""""""""""""""""""""""
" Languages => JSON
""""""""""""""""""""""""""""""
autocmd Filetype json setlocal ts=2 sw=2 expandtab


""""""""""""""""""""""""""""""
" Languages => XML
""""""""""""""""""""""""""""""
autocmd Filetype xml,html setlocal ts=2 sw=2 expandtab


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" Plugins => bufExplorer plugin
" \<Leader\>be normal open
" \<Leader\>bt toggle open / close
" \<Leader\>bs force horizontal split open
" \<Leader\>bv force vertical split open
""""""""""""""""""""""""""""""
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END
let g:rainbow#blacklist = [233, 234]
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>


""""""""""""""""""""""""""""""
" Plugins => vlime
" <localleader>rr : start vlime server
" <localleader>rv : view console output
" <localleader>ss : evaluate expression under cursor
" <localleader>i  : interaction mode
"
" See more :help vlime-mappings-list
""""""""""""""""""""""""""""""
let g:vlime_leader='\'
let g:vlime_enable_autodoc = v:true

""""""""""""""""""""""""""""""
" Plugins => slimv
""""""""""""""""""""""""""""""
let g:slimv_leader='\'
let g:slimv_lisp = '/usr/local/bin/sbcl'
let g:slimv_impl = 'sbcl'
let g:slimv_ctags = 'ctags'
let g:slimv_swank_cmd = '! xterm -e sbcl --load ~/.vim/plugged/slimv/slime/start-swank.lisp &'


""""""""""""""""""""""""""""""
" Plugins => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>


""""""""""""""""""""""""""""""
" Plugins => YankStack
""""""""""""""""""""""""""""""
let g:yankstack_yank_keys = ['y', 'd']

"nmap <C-p> <Plug>yankstack_substitute_older_paste
"nmap <C-n> <Plug>yankstack_substitute_newer_paste


""""""""""""""""""""""""""""""
" Plugins => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

" Quickly find and open a file in the current working directory
let g:ctrlp_map = '<C-f>'
map <leader>j :CtrlP<cr>

" Quickly find and open a buffer
map <leader>b :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'


""""""""""""""""""""""""""""""
" Plugins => ZenCoding
""""""""""""""""""""""""""""""
" Enable all functions in all modes
let g:user_zen_mode='a'


""""""""""""""""""""""""""""""
" Plugins => snipMate (beside <TAB> support <CTRL-j>)
""""""""""""""""""""""""""""""
ino <C-j> <C-r>=snipMate#TriggerSnippet()<cr>
snor <C-j> <esc>i<right><C-r>=snipMate#TriggerSnippet()<cr>
let g:snipMate = { 'snippet_version' : 1 }


""""""""""""""""""""""""""""""
" Plugins => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35

function NerdTreeToggleOrFind()
    if &filetype == 'nerdtree'
        :NERDTreeTabsToggle
    else
        :NERDTreeFind
    endif
endfunction

" vim-nerdtree-tabs enforces consistent nerdtree
map <F8> :NERDTreeTabsToggle<CR>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nn :call NerdTreeToggleOrFind()<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => surround.vim config
" Annotate strings with gettext
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => zenroom & goyo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => vim-autoformat
"
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
"   Lua: luafmt
"   SQL: pip install sqlformat
"   CMake: pip install cmake_format
"   LaTeX: brew install latexindent
"   OCaml: opam install ocamlformat
"   LISP/Scheme: npm install -g scmindent
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"au BufWrite *.h *.hpp *.C *.cc *.cpp *.CPP *.c++ *.go *.py :Autoformat
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
" Formatter user
let g:formatters_java=['gjf']
let g:formatters_cmake=['cmakefmt']
let g:formatters_cpp=['clangformat']
let g:formatters_python=['pyfmt']
let g:formatters_lisp=['scmindent']
let g:formatters_scheme=['scmindent']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=0
nnoremap <silent> <leader>gu :GitGutterToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => EditorConfig (project-specific EditorConfig rule)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EditorConfig_exclude_patterns = ['fugitive://.*']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => Fugitive
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy the link to the line of a Git repository to the clipboard
nnoremap <leader>v :.GBrowse!<CR>
xnoremap <leader>v :'<'>GBrowse!<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => tagbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>tb :TagbarToggle<CR>

let g:tagbar_position = 'right'
" Sort by positions in file
let g:tagbar_sort = 0
let g:tagbar_compact=1
let g:tagbar_show_data_type = 1
let g:tagbar_indent = 1
let g:tagbar_show_tag_linenumbers = 0
let g:tagbar_width = max([25, winwidth(0) / 5])
let g:tagbar_zoomwidth = 0
let g:tagbar_autofocus = 1
let g:tagbar_autopreview = 0
let g:tagbar_previewwin_pos = "splitabove"
" Haskell
let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'i:instance:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type',
        \ 'i' : 'instance'
    \ },
    \ 'scope2kind' : {
        \ 'module'   : 'm',
        \ 'class'    : 'c',
        \ 'data'     : 'd',
        \ 'type'     : 't',
        \ 'instance' : 'i'
    \ }
\ }
" golang
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => AnyJump
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:any_jump_disable_default_keybindings = 1
nnoremap <leader>aj :AnyJump<CR>
xnoremap <leader>aj :AnyJumpVisual<CR>
nnoremap <leader>ab :AnyJumpBack<CR>
nnoremap <leader>al :AnyJumpLastResults<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => fzf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" If installed using Homebrew
"set rtp+=/usr/local/opt/fzf
" If installed using git
set rtp+=~/.fzf
" map <Leader>+F to search in ag the word under the cursor
map <leader>F :call fzf#vim#ag(expand('<cword>'))<kEnter>
" map <Leader>+W to search in ag everywhere
map <leader>W :Ag<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => symbols-outline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>so :SymbolsOutline<CR>
map <F9> :SymbolsOutline<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins => vimtex
" Keymap:
"  <localleader>ll: compiling doc continuously
"  <localleader>lk: stop compiling
"  <localleader>lc: clear auxiliary files
"  <localleader>lv: forward search
"  <localleader>le: QuickFix
"  <localleader>lt: show content table
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended
"    -> GUI related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended => GUI related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font according to system
if has("mac") || has("macunix")
    set gfn=IBM\ Plex\ Mono:h14,Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
    set gfn=IBM\ Plex\ Mono:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
    set gfn=Monospace\ 11
endif

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

set background=dark
colorscheme codedark

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Map ½ to something useful
map ½ $
cmap ½ $
imap ½ $


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended => Parenthesis/bracket
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a`<esc>`<i`<esc>

" Map auto complete of (, ", ', [
" FIXME by @caesar0301
" inoremap $1 ()<esc>i
" inoremap $2 []<esc>i
" inoremap $3 {}<esc>i
" inoremap $4 {<esc>o}<esc>O
" inoremap $q ''<esc>i
" inoremap $e ""<esc>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <C-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" Auto complete with tab
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

"inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
"inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>g :Ack

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"=================================================================================
"
"   Following file contains the commands on how to run the currently open code.
"   The default mapping is set to F5 like most code editors.
"   Change it as you feel comfortable with, keeping in mind that it does not
"   clash with any other keymapping.
"
"   NOTE: Compilers for different systems may differ. For example, in the case
"   of C and C++, we have assumed it to be gcc and g++ respectively, but it may
"   not be the same. It is suggested to check first if the compilers are installed
"   before running the code, or maybe even switch to a different compiler.
"
"   NOTE: Adding support for more programming languages
"
"   Just add another elseif block before the 'endif' statement in the same
"   way it is done in each case. Take care to add tabbed spaces after each
"   elseif block (similar to python). For example:
"
"   elseif &filetype == '<your_file_extension>'
"       exec '!<your_compiler> %'
"
"   NOTE: The '%' sign indicates the name of the currently open file with extension.
"         The time command displays the time taken for execution. Remove the
"         time command if you dont want the system to display the time
"
"=================================================================================

map <F5> :call CompileRun()<CR>
imap <F5> <Esc>:call CompileRun()<CR>
vmap <F5> <Esc>:call CompileRun()<CR>

func! CompileRun()
exec "w"
if &filetype == 'c'
    exec "!gcc % -o %<"
    exec "!time ./%<"
elseif &filetype == 'cpp'
    exec "!g++ % -o %<"
    exec "!time ./%<"
elseif &filetype == 'java'
    exec "!javac %"
    exec "!time java %"
elseif &filetype == 'sh'
    exec "!time bash %"
elseif &filetype == 'python'
    exec "!time python3 %"
elseif &filetype == 'html'
    exec "!google-chrome % &"
elseif &filetype == 'go'
    exec "!go build %<"
    exec "!time go run %"
elseif &filetype == 'matlab'
    exec "!time octave %"
endif
endfunc
