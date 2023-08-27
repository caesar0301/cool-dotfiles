"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Languages:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" Code Format
" Plugins => vim-autoformat
""""""""""""""""""""""""""""""
nnoremap <silent> <leader>af :Autoformat<cr>
let g:autoformat_verbosemode=0
let g:autoformat_autoindent=0
let g:autoformat_retab=1
let g:autoformat_remove_trailing_spaces=1

let g:formatdef_gjf='"google-java-format-wrapper -"'
let g:formatters_java=['gjf']

let g:formatdef_cmakefmt='"cmake-format -"'
let g:formatters_cmake=['cmakefmt']

let g:formatdef_clangformat= '"clang-format -"'
let g:formatters_cpp=['clangformat']

let g:formatdef_gofmt_1='"gofmt"'

let g:formatdef_pyfmt='"black -"'
let g:formatters_python=['pyfmt']

let g:formatdef_latexindent = '"latexindent -"'

let g:formatdef_scmindent = '"scmindent -"'
let g:formatters_lisp=['scmindent']

let g:formatdef_shfmt = '"shfmt -bn -i 2 -"'
let g:formatters_sh=['shfmt']

" Autoformat on save
augroup autoformat
    :autocmd!
    " au BufWrite *.h,*.hpp,*.C,*.cc,*.cpp,*.CPP,*.c++ :Autoformat
    au BufWrite *.go,*.py,*.lua,*.rs :Autoformat
    au BufWrite *.md,*.cmake,*.sh,*.tex :Autoformat
    au BufWrite *.lisp,*.scm,*.ss :Autoformat
augroup END
doautoall autoformat BufWrite *

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

""""""""""""""""""""""""""""""
" Languages => LISP
""""""""""""""""""""""""""""""
" Plugin vlime
" <localleader>rr : start vlime server
" <localleader>rv : view console output
" <localleader>ss : evaluate expression under cursor
" <localleader>i  : interaction mode
" See more :help vlime-mappings-list
let g:vlime_leader='\'
let g:vlime_enable_autodoc = v:true

""""""""""""""""""""""""""""""
" Languages => EditorConfig
""""""""""""""""""""""""""""""
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

""""""""""""""""""""""""""""""
" Languages => TEX
""""""""""""""""""""""""""""""
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

map <F5> :call CompileRun()<cr>
imap <F5> <Esc>:call CompileRun()<cr>
vmap <F5> <Esc>:call CompileRun()<cr>
