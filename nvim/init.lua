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
require("caesardev")

-- Preferred settings
require("preference")

-- Load all user preferences
local paths = vim.split(vim.fn.glob("~/.config/nvim/vimscripts/**/*.vim"), "\n")
for i, file in pairs(paths) do
    vim.cmd("source " .. file)
end
