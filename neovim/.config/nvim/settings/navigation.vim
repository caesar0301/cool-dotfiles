""""""""""""""""""""""""""""""""""
" Zen Mode
""""""""""""""""""""""""""""""""""

" Plugin => ZenCoding
" Enable all functions in all modes
let g:user_zen_mode='a'

" Plugin => zenroom & goyo
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>

""""""""""""""""""""""""""""""""""
" Windodws
""""""""""""""""""""""""""""""""""

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" File browsing, nvim-tree
map <F8> :NvimTreeToggle<cr>
map <leader>nn :NvimTreeFindFile<cr>

""""""""""""""""""""""""""""""""""
" Buffers
""""""""""""""""""""""""""""""""""

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

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Close other buffers but this one
map <leader>bo :%bd\|e#\|bd#<cr>\|'""'

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Plugin => bufExplorer
"   <leader>be normal open
"   <leader>bt toggle open / close
"   <leader>bs force horizontal split open
"   <leader>bv force vertical split open
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END
let g:rainbow#blacklist = [233, 234]
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>bn :BufExplorer<cr>

""""""""""""""""""""""""""""""""""
" Tabs
""""""""""""""""""""""""""""""""""

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<cr>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

""""""""""""""""""""""""""""""""""
" File browser and structure
""""""""""""""""""""""""""""""""""

" Plugin => symbols-outline
nnoremap <leader>so :SymbolsOutline<cr>
map <F9> :SymbolsOutline<cr>

" Plugin => tagbar
nnoremap <leader>tb :TagbarToggle<cr>
let g:tagbar_position = 'right'
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


""""""""""""""""""""""""""""""""""
" Search and Find
""""""""""""""""""""""""""""""""""

" Remap VIM 0 to first non-blank character
map 0 ^

" Goto line head and tail
map <C-a> <ESC>^
imap <C-a> <ESC>I
map <C-e> <ESC>$
imap <C-e> <ESC>A

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <C-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

"" Plugin => fzf
" Search the word under the cursor
nnoremap <leader>fw <cmd>call fzf#vim#ag(expand('<cword>'))<cr>
" Search everywhere
nnoremap <leader>fW <cmd>Ag<cr>

"" Plugin => MRU
let MRU_Max_Entries = 400
nnoremap <leader>fr <cmd>MRU<cr>

"" Plugin => telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Plugins => AnyJump
let g:any_jump_disable_default_keybindings = 1
nnoremap <leader>aj :AnyJump<cr>
xnoremap <leader>aj :AnyJumpVisual<cr>
nnoremap <leader>ab :AnyJumpBack<cr>
nnoremap <leader>al :AnyJumpLastResults<cr>