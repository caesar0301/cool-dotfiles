-- remove add single quote on filetype scheme or lisp
require("nvim-autopairs").get_rules("'")[1].not_filetypes = {"scheme", "lisp"}
require("nvim-autopairs").get_rules("'")[1]:with_pair(cond.not_after_text("["))
require('nvim-autopairs').setup({
    enable_check_bracket_line = false
})
