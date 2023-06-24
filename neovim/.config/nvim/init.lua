-------------------------------------------------------------
-- Maintainer:
--       Amir Salihefendic — @amix3k
--       Xiaming Chen - @caesar0301
--
-- Prerequisites:
--       vim-plug: https://github.com/junegunn/vim-plug
--       neovim: (recommended) https://neovim.io/
-------------------------------------------------------------

-- Load all plugins
require("plugins")

-- Load all settings
local paths = vim.split(vim.fn.glob("~/.config/nvim/vim/*.vim"), "\n")
for i, file in pairs(paths) do
    vim.cmd("source " .. file)
end
