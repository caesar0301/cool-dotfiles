-------------------------------------------------------------
-- Maintainer:
--       Amir Salihefendic — @amix3k
--       Xiaming Chen - @caesar0301
--
-- Prerequisites:
--       packer: https://github.com/wbthomason/packer.nvim
--       neovim: https://neovim.io/
--
-- Usage: :PackerInstall
-------------------------------------------------------------
-- Setup globals that I expect to be always available.
require("globals")

-- Load all plugins
require("plugins")

-- Load all vim settings
local paths = vim.split(vim.fn.glob("~/.config/nvim/preferences/*.vim"), "\n")
for i, file in pairs(paths) do
    vim.cmd("source " .. file)
end
