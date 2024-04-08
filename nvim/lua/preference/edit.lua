-- Delete trailing whitespace on save
function CleanExtraSpaces()
    local save_cursor = vim.fn.getpos(".")
    local old_query = vim.fn.getreg("/")
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
    vim.fn.setreg("/", old_query)
end
vim.api.nvim_exec(
    [[
  augroup CleanExtraSpaces
    autocmd!
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.lisp lua CleanExtraSpaces()
  augroup END
]],
    true
)

-- Turn on persistent undo
local status, result =
    pcall(
    function()
        vim.o.undodir = "/tmp/.vim_runtime/temp_dirs/undodir"
        vim.o.undofile = true
    end
)
