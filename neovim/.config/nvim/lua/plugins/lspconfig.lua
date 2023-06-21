local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
lsp_status.register_progress()

-- Mappings.
local opts = {
    noremap = true,
    silent = true
}
vim.keymap.set('n', '<leader>eq', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<leader>ee', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Use an on_attach function after the language server attaches to the current buffer
local common_on_attach = function(client, bufnr)
    print("LSP started.");
    require'completion'.on_attach(client)
    -- Overwrite :Format command in lsp buffers
    -- vim.api.nvim_create_user_command("Format", function(opts) vim.lsp.buf.formatting() end, {})
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- keymap
    local bufopts = {
        noremap = true,
        silent = true,
        buffer = bufnr
    }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>=', vim.lsp.buf.formatting, bufopts)
    vim.keymap.set('n', '<leader>gw', vim.lsp.buf.document_symbol, bufopts)
    vim.keymap.set('n', '<leader>gW', vim.lsp.buf.workspace_symbol, bufopts)
    vim.keymap.set('n', '<leader>gl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>ai', vim.lsp.buf.incoming_calls, bufopts)
    vim.keymap.set('n', '<leader>ao', vim.lsp.buf.outgoing_calls, bufopts)
    -- lsp-status
    lsp_status.on_attach(client)
end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

-- General servers
local servers = {'rust_analyzer', -- Rust
'pyright', -- Python
'r_language_server', -- Rlang
'clojure_lsp', -- Clojure
'metals', -- Scala
'gopls', -- Golang
'cmake' -- CMake
}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = common_on_attach,
        capabilities = capabilities
    }
end

-- clangd server
local clangd_on_attach = function(client, bufnr)
    common_on_attach(client, bufnr)
    vim.keymap.set('n', '<leader>sh', ":ClangdSwitchSourceHeader<CR>", bufopts)
end
lspconfig.clangd.setup {
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
    cmd = {"clangd", "--background-index=false"},
    capabilities = capabilities,
    on_attach = clangd_on_attach
}

-- yaml server
require('lspconfig').yamlls.setup {
    on_attach = common_on_attach,
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml"
            }
        }
    }
}

-- haskell server
require('lspconfig').hls.setup {
    on_attach = common_on_attach,
    capabilities = capabilities,
    settings = {
        haskell = {
            formattingProvider = "stylish-haskell"
        }
    }
}

-- nvim-cmp setup
local cmp = require('cmp')
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        -- luasnip: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
        ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {'i', 's'})
    }),
    sources = {{
        name = 'nvim_lsp'
    }, {
        name = 'luasnip'
    }, {
        name = 'conjure'
    }},
    formatting = {
        format = require('lspkind').cmp_format({
            mode = 'symbol',
            maxwidth = 50
        })
    }
}
