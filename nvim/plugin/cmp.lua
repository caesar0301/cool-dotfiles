local cmp = require "cmp"
local luasnip = require("luasnip")
local lspkind = require("lspkind")

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10 -- Maximum number of items to show in the popup menu

local formatForTailwindCSS = function(entry, vim_item)
    if vim_item.kind == "Color" and entry.completion_item.documentation then
        local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
        if r then
            local color = string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
            local group = "Tw_" .. color
            if vim.fn.hlID(group) < 1 then
                vim.api.nvim_set_hl(0, group, {fg = "#" .. color})
            end
            vim_item.kind = "●" -- or "■" or anything
            vim_item.kind_hl_group = group
            return vim_item
        end
    end
    -- vim_item.kind = icons[vim_item.kind] and (icons[vim_item.kind] .. vim_item.kind) or vim_item.kind
    -- or just show the icon
    vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
    return vim_item
end

cmp.setup(
    {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        mapping = cmp.mapping.preset.insert(
            {
                ["<Tab>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            -- cmp.select_next_item()
                            cmp.confirm(
                                {
                                    behavior = cmp.ConfirmBehavior.Replace, -- e.g. console.log -> console.inlog -> console.info
                                    select = true -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                                }
                            )
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
                ),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-u>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
                ["<C-y>"] = cmp.config.disable,
                ["<C-e>"] = cmp.mapping(
                    {
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close()
                    }
                ),
                ["<CR>"] = cmp.mapping.confirm({select = true})
            }
        ),
        sources = cmp.config.sources(
            {
                -- ordering is matter
                {name = "nvim_lsp"},
                {name = "luasnip"},
                {name = "path"},
                {name = "buffer", keyword_length = 5} -- show buffer's completion only if type more then keyword_length
            }
        ),
        window = {
            -- border style
            completion = cmp.config.window.bordered(
                {
                    col_offset = -3, -- align the abbr and word on cursor (due to fields order below)
                    side_padding = 0
                }
            ),
            -- documentation = {
            --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None"
            -- },
            documentation = cmp.config.window.bordered()
        },
        formatting = {
            fields = {"kind", "abbr", "menu"},
            format = lspkind.cmp_format(
                {
                    mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    menu = ({
                        -- showing type in menu
                        nvim_lsp = "(LSP)",
                        path = "(Path)",
                        buffer = "(Buffer)",
                        luasnip = "(LuaSnip)"
                    }),
                    before = function(entry, vim_item)
                        vim_item.menu = "(" .. vim_item.kind .. ")"
                        vim_item.dup =
                            ({
                            nvim_lsp = 0,
                            path = 0
                        })[entry.source.name] or 0
                        vim_item = formatForTailwindCSS(entry, vim_item) -- for tailwind css autocomplete
                        return vim_item
                    end
                }
            )
        }
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

cmp.setup.cmdline(
    {"/", "?"},
    {
        mapping = cmp.mapping.preset.cmdline(
            {
                ["<C-p>"] = cmp.mapping(
                    {
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.select_prev_item()
                            end
                            fallback()
                        end
                    }
                ),
                ["<C-n>"] = cmp.mapping(
                    {
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.select_next_item()
                            end
                            fallback()
                        end
                    }
                ),
                ["<Tab>"] = cmp.mapping(
                    {
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.confirm(
                                    {
                                        behavior = cmp.ConfirmBehavior.Replace,
                                        select = true
                                    }
                                )
                            else
                                return fallback()
                            end
                        end
                    }
                )
            }
        ),
        sources = {
            {name = "buffer"}
        },
        formatting = {
            fields = {"abbr", "kind"},
            format = lspkind.cmp_format(
                {
                    mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    before = function(_, vim_item)
                        if vim_item.kind == "Text" then
                            vim_item.kind = ""
                            return vim_item
                        end
                        -- just show the icon
                        vim_item.kind =
                            lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
                        return vim_item
                    end
                }
            )
        }
    }
)

cmp.setup.cmdline(
    ":",
    {
        completion = {
            autocomplete = false
        },
        mapping = cmp.mapping.preset.cmdline(
            {
                ["<C-p>"] = cmp.mapping(
                    {
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.select_prev_item()
                            end
                            fallback()
                        end
                    }
                ),
                ["<C-n>"] = cmp.mapping(
                    {
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.select_next_item()
                            end
                            fallback()
                        end
                    }
                ),
                ["<Tab>"] = cmp.mapping(
                    {
                        c = function()
                            if cmp.visible() then
                                return cmp.select_next_item()
                            else
                                cmp.complete()
                                cmp.select_next_item()
                                return
                            end
                        end
                    }
                ),
                ["<S-Tab>"] = cmp.mapping(
                    {
                        c = function()
                            if cmp.visible() then
                                return cmp.select_prev_item()
                            else
                                cmp.complete()
                                cmp.select_next_item()
                                return
                            end
                        end
                    }
                )
            }
        ),
        sources = {
            {name = "path"},
            {
                name = "cmdline",
                option = {
                    ignore_cmds = {"Man", "!"}
                }
            }
        },
        formatting = {
            fields = {"abbr", "kind"},
            format = lspkind.cmp_format(
                {
                    mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    before = function(_, vim_item)
                        if vim_item.kind == "Variable" then
                            vim_item.kind = ""
                            return vim_item
                        end
                        -- just show the icon
                        vim_item.kind =
                            lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
                        return vim_item
                    end
                }
            )
        }
    }
)
