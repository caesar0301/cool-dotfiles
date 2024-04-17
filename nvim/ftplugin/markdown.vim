let g:vim_markdown_no_default_key_mappings = 1

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1

" concealing bold, italic bold, and italic bold respectively
set conceallevel=2
let g:vim_markdown_conceal=1
let g:vim_markdown_math = 0
let g:vim_markdown_conceal_code_blocks = 0

" Automatically inserting bulletpoints can lead to problems when wrapping text
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

" Open in-file link in new tab 
let g:vim_markdown_edit_url_in = 'tab'

" format borderless table automatically
let g:vim_markdown_borderless_table = 1
