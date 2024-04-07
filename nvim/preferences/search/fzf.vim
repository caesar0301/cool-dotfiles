" Plugin => fzf.vim

" Initialize configuration dictionary
let g:fzf_vim = {}

" Preview window is hidden by default. You can toggle it with ctrl-/.
"let g:fzf_vim.preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']
let g:fzf_vim.preview_window = ['right,50%,<70(up,40%)', 'ctrl-/']

" [Buffers] Jump to the existing window if possible
let g:fzf_vim.buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_vim.commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_vim.tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_vim.commands_expect = 'alt-enter,ctrl-x'

" Hide status line of terminal buffer
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:terminal_ansi_colors = [
  \ '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
  \ '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
  \ '#626262', '#d75f87', '#87af87', '#ffd787',
  \ '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4'
\ ]

"Ag: Start ag in the specified directory e.g. :Agdir ~/foo
function! s:ag_in(bang, ...)
    if !isdirectory(a:1)
        throw 'not a valid directory: ' .. a:1
    endif
    " Press `?' to enable preview window.
    call fzf#vim#ag(join(a:000[1:], ' '),
                \ fzf#vim#with_preview({'dir': a:1}, 'right:50%', '?'), a:bang)
endfunction
command! -bang -nargs=+ -complete=dir Agdir call s:ag_in(<bang>0, <f-args>)

" Search the word under the cursor
nnoremap <leader>fw <cmd>call fzf#vim#ag(expand('<cword>'), fzf#vim#with_preview())<cr>

" Search everywhere, requires the-silver-searcher
nnoremap <leader>fW <cmd>Ag<cr>
