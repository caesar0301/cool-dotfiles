local cmp = require "cmp"

cmp.setup(
    {
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered()
        },
        mapping = cmp.mapping.preset.insert(
            {
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-y>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-Space>"] = cmp.mapping.confirm {
                    -- behavior = cmp.ConfirmBehavior.Replace,
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true
                },
                ["<Tab>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end,
                    {"i", "s"}
                ),
                ["<S-Tab>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end,
                    {"i", "s"}
                )
            }
        ),
        sources = cmp.config.sources(
            {
                {name = "nvim_lsp"},
                {name = "luasnip"}
            },
            {
                {name = "buffer"}
            }
        )
    }
)

-- Set configuration for specific filetype.
cmp.setup.filetype(
    "gitcommit",
    {
        sources = cmp.config.sources(
            {
                {name = "git"}
            },
            {
                {name = "buffer"}
            }
        )
    }
)

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
    {"/", "?"},
    {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            {name = "buffer"}
        }
    }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
    ":",
    {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
            {
                {name = "path"}
            },
            {
                {name = "cmdline"}
            }
        )
    }
)

-- autopairs
require("nvim-autopairs").setup(
    {
        disable_filetype = {"TelescopePrompt", "vim"}
    }
)

-- Insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local handlers = require("nvim-autopairs.completion.handlers")
cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done(
        {
            filetypes = {
                -- "*" is a alias to all filetypes
                ["*"] = {
                    ["("] = {
                        kind = {
                            cmp.lsp.CompletionItemKind.Function,
                            cmp.lsp.CompletionItemKind.Method
                        },
                        handler = handlers["*"]
                    }
                },
                lua = {
                    ["("] = {
                        kind = {
                            cmp.lsp.CompletionItemKind.Function,
                            cmp.lsp.CompletionItemKind.Method
                        },
                        ---@param char string
                        ---@param item table item completion
                        ---@param bufnr number buffer number
                        ---@param rules table
                        ---@param commit_character table<string>
                        handler = function(char, item, bufnr, rules, commit_character)
                            -- Your handler function. Inpect with print(vim.inspect{char, item, bufnr, rules, commit_character})
                        end
                    }
                },
                -- Disable for tex
                tex = false
            }
        }
    )
)
