local api = vim.api

-- Use Telescope to search the provided path
api.nvim_create_user_command(
    "FindDir",
    function(opts)
        local builtin = require("telescope.builtin")
        builtin.live_grep({prompt_title = "Search in " .. opts.fargs[1], cwd = opts.fargs[1]})
    end,
    {nargs = 1}
)

-- Avoid accidental case changing
api.nvim_create_user_command("W", "w", {})
api.nvim_create_user_command("Q", "q", {})
api.nvim_create_user_command("Wq", "wq", {})
api.nvim_create_user_command("WQ", "wq", {})
api.nvim_create_user_command("Qa", "qa", {})
