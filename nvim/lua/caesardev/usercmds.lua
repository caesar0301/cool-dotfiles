local api = vim.api

-- Avoid accidental case changing
api.nvim_create_user_command("W", "wa", {})
api.nvim_create_user_command("Q", "qa", {})
api.nvim_create_user_command("Wq", "waq", {})
api.nvim_create_user_command("WQ", "waqa", {})
api.nvim_create_user_command("Qa", "qa", {})

-- Use Telescope to search the provided path
api.nvim_create_user_command(
    "GrepDir",
    function(opts)
        local builtin = require("telescope.builtin")
        builtin.live_grep({prompt_title = "Search in " .. opts.fargs[1], cwd = opts.fargs[1]})
    end,
    {nargs = 1}
)

-- Find and replace with cdo
vim.api.nvim_create_user_command(
    "FindAndReplace",
    function(opts)
        vim.api.nvim_command(string.format("cdo s/%s/%s", opts.fargs[1], opts.fargs[2]))
        vim.api.nvim_command("cfdo update")
    end,
    {nargs = "*"}
)
