-- Paste mode (conflicts with autopairs)
-- vim.opt.paste = true

-- vim copy to clipboard and via ssh
-- for nvim 0.10.0+, enable auto osc52. see :help clipboard-osc52
-- vim.opt.clipboard:append {"unnamed", "unnamedplus"}
if (os.getenv("SSH_TTY") == nil) then
    vim.opt.clipboard:append("unnamedplus")
else
    vim.opt.clipboard:append("unnamedplus")
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*")
        },
        paste = {
            ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
            ["*"] = require("vim.ui.clipboard.osc52").paste("*")
        }
    }
end

-- Sets how many lines of history VIM has to remember
vim.opt.history = 500

-- Turn backup off, since most stuff is in SVN, git etc. anyway...
vim.opt.backup = false
vim.opt.wb = false
vim.opt.swapfile = false

-- Enable spell checking, excluding Chinese char
vim.opt.spelllang = vim.opt.spelllang + "en_us" + "cjk"
vim.opt.spell = false

-- In case of invalid default Python3 version
local nvimpy = os.getenv("NVIM_PYTHON3")
if nvimpy ~= nil and python_path ~= "" then
    vim.g.python3_host_prog = nvimpy .. "/bin/python3"
end
