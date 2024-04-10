-- Use Telescope to search the provided path
vim.api.nvim_create_user_command(
    "FindDir",
    function(opts)
        local builtin = require("telescope.builtin")
        builtin.live_grep({prompt_title = "Search in " .. opts.fargs[1], cwd = opts.fargs[1]})
    end,
    {nargs = 1}
)
