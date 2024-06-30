-------------------------------------------------------------
-- Maintainer:
--       Xiaming Chen - @caesar0301
--
-- Prerequisites:
--       packer: https://github.com/wbthomason/packer.nvim
--       neovim: https://neovim.io/
--
-- Usage: :PackerInstall
-------------------------------------------------------------
-- Load all plugins
require("packerman")

-- Setup globals that I expect to be always available.
require("base")

-- Preferred settings
require("preference")

-- neovide client: https://neovide.dev/
if vim.g.neovide then
    require("neovide")
end

-- Load all user preferences
local paths = vim.split(vim.fn.glob("~/.config/nvim/vimscripts/**/*.vim"), "\n")
for i, file in pairs(paths) do
    vim.cmd("source " .. file)
end
