" Always show the status line
set laststatus=2
set noshowmode

"###### Plugin => lsp-status

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif
  return ''
endfunction

"###### Plugin => lightline

let g:lightline  = {'colorscheme': 'wombat'}
let g:lightline.enable = {'statusline': 1, 'tabline': 0} " tabline conflicts with barbar
let g:lightline.component = {
    \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
    \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
    \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}',
    \   'lspstatus': '%{exists("*LspStatus")?LspStatus():""}'
    \   }
let g:lightline.active = {
    \   'left': [ ['mode', 'paste'],
    \             ['fugitive', 'readonly', 'gitbranch', 'filename', 'modified'] ],
    \   'right': [ ['lineinfo'], ['percent'], ['lspstatus'] ]
    \   }
