local actions = require("telescope.actions")

require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-n>"] = actions.cycle_history_next
            }
        }
    },
    extensions = {
        file_browser = {
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true
        }
    }
}
