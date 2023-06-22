local border_chars = {
    TOP_LEFT = '┌',
    TOP_RIGHT = '┐',
    MID_HORIZONTAL = '─',
    MID_VERTICAL = '│',
    BOTTOM_LEFT = '└',
    BOTTOM_RIGHT = '┘'
}
vim.g.lsp_utils_location_opts = {
    height = 20,
    mode = 'editor',
    list = {
        numbering = true,
        border = true,
        border_chars = border_chars
    },
    preview = {
        title = 'Location Preview',
        border = true,
        border_chars = border_chars
    },
    keymaps = {
        n = {
            ['<C-n>'] = 'j',
            ['<C-p>'] = 'k'
        }
    }
}
vim.g.lsp_utils_symbols_opts = {
    height = 20,
    mode = 'editor',
    list = {
        numbering = true,
        border = true,
        border_chars = border_chars
    },
    preview = {
        title = 'Symbols Preview',
        border = true,
        border_chars = border_chars
    },
    prompt = {}
}
local bufnr = vim.api.nvim_buf_get_number(0)
vim.lsp.handlers['textDocument/codeAction'] = function(_, _, actions)
    require('lsputil.codeAction').code_action_handler(nil, actions, nil, nil, nil)
end
vim.lsp.handlers['textDocument/references'] = function(_, _, result)
    require('lsputil.locations').references_handler(nil, result, {
        bufnr = bufnr
    }, nil)
end
vim.lsp.handlers['textDocument/definition'] = function(_, method, result)
    require('lsputil.locations').definition_handler(nil, result, {
        bufnr = bufnr,
        method = method
    }, nil)
end
vim.lsp.handlers['textDocument/declaration'] = function(_, method, result)
    require('lsputil.locations').declaration_handler(nil, result, {
        bufnr = bufnr,
        method = method
    }, nil)
end
vim.lsp.handlers['textDocument/typeDefinition'] = function(_, method, result)
    require('lsputil.locations').typeDefinition_handler(nil, result, {
        bufnr = bufnr,
        method = method
    }, nil)
end
vim.lsp.handlers['textDocument/implementation'] = function(_, method, result)
    require('lsputil.locations').implementation_handler(nil, result, {
        bufnr = bufnr,
        method = method
    }, nil)
end
vim.lsp.handlers['textDocument/documentSymbol'] = function(_, _, result, _, bufn)
    require('lsputil.symbols').document_handler(nil, result, {
        bufnr = bufn
    }, nil)
end
vim.lsp.handlers['textDocument/symbol'] = function(_, _, result, _, bufn)
    require('lsputil.symbols').workspace_handler(nil, result, {
        bufnr = bufn
    }, nil)
end
