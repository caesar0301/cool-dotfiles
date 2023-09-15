local lspconfig = require("lspconfig")
local navic = require("nvim-navic")
local nvim_cmp = require("cmp_nvim_lsp")

local lsp_status = require("lsp-status")
lsp_status.register_progress()

local goto_preview = require("goto-preview")
goto_preview.setup {}

-- turn off logging by default; options: debug, error...
vim.lsp.set_log_level("off")

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local common_caps = vim.lsp.protocol.make_client_capabilities()
common_caps = nvim_cmp.default_capabilities(common_caps)
common_caps = vim.tbl_extend("keep", common_caps, lsp_status.capabilities)

local lsp_keymaps = function(client, bufnr)
    local opts = {
        noremap = true,
        silent = true
    }
    local bufopts = {
        noremap = true,
        silent = true,
        buffer = bufnr
    }
    local print_wf = function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gpd", goto_preview.goto_preview_definition, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "gpi", goto_preview.goto_preview_implementation, bufopts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "gpt", goto_preview.goto_preview_type_definition, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "gpr", goto_preview.goto_preview_references, bufopts)
    vim.keymap.set("n", "gP", goto_preview.close_all_win, bufopts)
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "rn", vim.lsp.buf.rename, bufopts)
    -- vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "ca", ":CodeActionMenu<CR>", bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<leader>=", vim.lsp.buf.format, bufopts)
    vim.keymap.set("n", "<leader>ai", vim.lsp.buf.incoming_calls, bufopts)
    vim.keymap.set("n", "<leader>ao", vim.lsp.buf.outgoing_calls, bufopts)
    vim.keymap.set("n", "<leader>gw", vim.lsp.buf.document_symbol, bufopts)
    vim.keymap.set("n", "<leader>gW", vim.lsp.buf.workspace_symbol, bufopts)
    vim.keymap.set("n", "<leader>gl", print_wf, bufopts)
    vim.keymap.set("n", "<leader>eq", vim.diagnostic.setloclist, opts)
    vim.keymap.set("n", "<leader>ee", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
end

-- Use an on_attach function after the language server attaches to the current buffer
local common_on_attach = function(client, bufnr)
    -- shared keymap
    lsp_keymaps(client, bufnr)
    -- lsp-status.nvim
    lsp_status.on_attach(client)
    -- nvim-navic
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

-- General language servers
local servers = {
    "rust_analyzer",
    "pyright",
    "r_language_server",
    "clojure_lsp",
    "metals",
    "cmake"
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
    cmd = {"clangd", "--background-index=true"},
    capabilities = common_caps,
    on_attach = function(client, bufnr)
        local bufopts = {
            noremap = true,
            silent = true,
            buffer = bufnr
        }
        vim.keymap.set("n", "<leader>sh", ":ClangdSwitchSourceHeader<CR>", bufopts)
        common_on_attach(client, bufnr)
    end
}

-- YAMl
lspconfig.yamlls.setup {
    capabilities = common_caps,
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

-- Golang
local lastRootPath = nil
local gomodpath = vim.trim(vim.fn.system("go env GOPATH")) .. "/pkg/mod"

lspconfig.gopls.setup {
    on_attach = common_on_attach,
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = function(fname)
        local fullpath = vim.fn.expand(fname, ":p")
        if string.find(fullpath, gomodpath) and lastRootPath ~= nil then
            return lastRootPath
        end
        local root = lspconfig.util.root_pattern("go.mod", ".git")(fname)
        if root ~= nil then
            lastRootPath = root
        end
        return root
    end,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true
            },
            staticcheck = true
        }
    }
}

vim.api.nvim_create_autocmd(
    "BufWritePre",
    {
        pattern = "*.go",
        callback = function()
            vim.lsp.buf.code_action({context = {only = {"source.organizeImports"}}, apply = true})
        end
    }
)
