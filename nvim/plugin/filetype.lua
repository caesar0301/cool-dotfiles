-- In init.lua or filetype.nvim's config file
require("filetype").setup(
    {
        overrides = {
            extensions = {
                mako = "mako",
                twig = "html"
            },
            literal = {
                Sconscript = "python",
                Sconstruct = "python"
            },
            complex = {
                [".*git/config"] = "gitconfig"
            },
            function_extensions = {
                ["jinja"] = function()
                    vim.cmd("set syntax=htmljinja")
                end,
                ["tex"] = function()
                    vim.opt_local.textwidth = 80
                    -- This is necessary for VimTeX to load properly. The "indent" is optional.
                    -- Note that most plugin managers will do this automatically.
                    vim.cmd("filetype plugin indent on")
                    -- This enables Vim's and neovim's syntax-related features. Without this, some
                    -- VimTeX features will not work (see ":help vimtex-requirements" for more info).
                    vim.cmd("syntax on")
                end,
                ["md"] = function()
                    vim.opt_local.textwidth = 80
                end,
                ["js"] = function()
                    vim.opt_local.foldmethod = "syntax"
                    vim.opt_local.foldlevelstart = 1
                    vim.api.nvim_command("syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend")
                    function FoldText()
                        return vim.fn.substitute(vim.fn.getline(vim.v.foldstart), "{.*", "{...}", "")
                    end
                    vim.opt_local.foldtext = "v:lua.FoldText()"
                    vim.opt_local.expandtab = true
                    vim.opt_local.cindent = false
                end,
                ["coffee"] = function()
                    vim.opt_local.foldmethod = "indent"
                    vim.opt_local.foldlevelstart = 1
                end,
                ["xml"] = function()
                    vim.opt.shiftwidth = 2
                    vim.opt.tabstop = 2
                    vim.opt.expandtab = true
                end,
                ["html"] = function()
                    vim.opt.shiftwidth = 2
                    vim.opt.tabstop = 2
                    vim.opt.expandtab = true
                end,
                ["json"] = function()
                    vim.opt.shiftwidth = 2
                    vim.opt.tabstop = 2
                    vim.opt.expandtab = true
                end
            },
            function_literal = {
                Brewfile = function()
                    vim.cmd("syntax off")
                end
            },
            function_complex = {
                ["*.math_notes/%w+"] = function()
                    vim.cmd("iabbrev $ $$")
                end
            },
            shebang = {
                dash = "sh",
                zsh = "sh"
            }
        }
    }
)
