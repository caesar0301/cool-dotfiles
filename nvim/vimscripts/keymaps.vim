" insert the current date and time
nmap <leader>ts i<C-R>=strftime("%Y-%m-%dT%H:%M:%S%z")<CR><Esc>
imap <leader>ts <C-R>=strftime("%Y-%m-%dT%H:%M:%S%z")<CR>
