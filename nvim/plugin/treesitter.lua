require "nvim-treesitter.configs".setup {
    ensure_installed = {},
    autotag = {
        enable = true
    },
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    highlight = {
        enable = true,
        disable = {"bash"},
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm"
        }
    },
    refactor = {
        highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true
        },
        highlight_current_scope = {
            enable = true
        }
    }
}
