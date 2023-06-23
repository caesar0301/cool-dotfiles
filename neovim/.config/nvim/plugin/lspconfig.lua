local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
lsp_status.register_progress()
local nvim_cmp = require('cmp_nvim_lsp')
local goto_preview = require('goto-preview')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local common_caps = vim.lsp.protocol.make_client_capabilities()
common_caps = nvim_cmp.default_capabilities(common_caps)
common_caps = vim.tbl_extend('keep', common_caps, lsp_status.capabilities)

-- Use an on_attach function after the language server attaches to the current buffer
local common_on_attach = function(client, bufnr)
    vim.api.nvim_create_user_command("Format", function(opts) vim.lsp.buf.formatting() end, {})

    local bufopts = {
        noremap = true,
        silent = false,
        buffer = bufnr
    }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gpd', goto_preview.goto_preview_definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gpi', goto_preview.goto_preview_implementation, bufopts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'gpt', goto_preview.goto_preview_type_definition, bufopts)
    vim.keymap.set('n', 'gpr', goto_preview.goto_preview_references, bufopts)
    vim.keymap.set('n', 'gP', goto_preview.close_all_win, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, bufopts)

    -- vim.keymap.set('n', 'rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>rn", ":IncRename ", bufopts)

    -- vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'ca', ":CodeActionMenu<CR>", bufopts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>=', vim.lsp.buf.formatting, bufopts)
    vim.keymap.set('n', '<leader>ai', vim.lsp.buf.incoming_calls, bufopts)
    vim.keymap.set('n', '<leader>ao', vim.lsp.buf.outgoing_calls, bufopts)
    vim.keymap.set('n', '<leader>gw', vim.lsp.buf.document_symbol, bufopts)
    vim.keymap.set('n', '<leader>gW', vim.lsp.buf.workspace_symbol, bufopts)
    vim.keymap.set('n', '<leader>gl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

    -- Other plugins
    lsp_status.on_attach(client)
end

-- Mappings.
local opts = {
    noremap = true,
    silent = true
}
vim.keymap.set('n', '<leader>eq', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<leader>ee', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- General
local servers = { 'rust_analyzer', -- Rust
    'pyright',                     -- Python
    'r_language_server',           -- Rlang
    'clojure_lsp',                 -- Clojure
    'metals',                      -- Scala
    'gopls',                       -- Golang
    'cmake'                        -- CMake
}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = common_on_attach,
        capabilities = common_caps
    }
end

-- Clangd
lspconfig.clangd.setup {
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
    cmd = { "clangd", "--background-index=true" },
    capabilities = common_caps,
    on_attach = function(client, bufnr)
        common_on_attach(client, bufnr)
        vim.keymap.set('n', '<leader>sh', ":ClangdSwitchSourceHeader<CR>", bufopts)
    end
}

-- YAMl
lspconfig.yamlls.setup {
    on_attach = common_on_attach,
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml"
            }
        }
    }
}

-- Haskell
lspconfig.hls.setup {
    on_attach = common_on_attach,
    capabilities = common_caps,
    settings = {
        haskell = {
            formattingProvider = "stylish-haskell"
        }
    }
}
