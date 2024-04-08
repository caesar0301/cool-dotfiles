-- Paste mode (conflicts with autopairs)
-- vim.opt.paste = true

-- vim copy to clipboard
vim.opt.clipboard:append {"unnamed", "unnamedplus"}

-- Sets how many lines of history VIM has to remember
vim.opt.history = 500

-- Turn backup off, since most stuff is in SVN, git etc. anyway...
vim.opt.backup = false
vim.opt.wb = false
vim.opt.swapfile = false

-- In case of invalid default python3 version
local nvimpy = os.getenv("NVIM_PYTHON3")
if nvimpy ~= nil and python_path ~= "" then
    vim.g.python3_host_prog = nvimpy .. "/bin/python3"
end
