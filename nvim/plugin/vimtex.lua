-- Vimtex settings
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_view_method = "skim"

-- Or with a generic interface:
-- vim.g.vimtex_view_general_viewer = 'okular'
-- vim.g.vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

vim.g.vimtex_quickfix_mode = 2
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
vim.g.vimtex_quickfix_open_on_warning = 0
