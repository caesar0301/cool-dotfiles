-- Specify the behavior when switching between buffers
pcall(function()
    vim.opt.switchbuf:append("useopen", "usetab", "newtab")
    vim.opt.stal = 2
end)
