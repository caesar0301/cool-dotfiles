" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

"###### Plugin => bufExplorer

"   <leader>be normal open
"   <leader>bt toggle open / close
"   <leader>bs force horizontal split open
"   <leader>bv force vertical split open
map <leader>bn :BufExplorer<cr>

let g:rainbow#blacklist = [233, 234]
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'

augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END
