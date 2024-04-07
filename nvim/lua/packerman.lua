vim.cmd [[packadd packer.nvim]]

return require("packer").startup(
    function(use)
        -- Packer can manage itself
        use "wbthomason/packer.nvim"

        ---------------------------
        -- Editing
        ---------------------------

        use "maxbrunsfeld/vim-yankstack"
        use "tpope/vim-commentary"
        use "tpope/vim-repeat"

        ---------------------------
        -- Navigation
        ---------------------------

        -- folder view
        use {
            "nvim-tree/nvim-tree.lua",
            requires = {
                {"nvim-tree/nvim-web-devicons"},
                {"antosha417/nvim-lsp-file-operations", opt = true},
                {"echasnovski/mini.base16", opt = true}
            }
        }
        -- tabline
        use {
            "romgrk/barbar.nvim",
            requires = {
                {"nvim-tree/nvim-web-devicons"},
                {"lewis6991/gitsigns.nvim"}
            }
        }
        -- file structure
        use "preservim/tagbar"
        use {
            "junegunn/fzf.vim",
            requires = {"junegunn/fzf", run = ":call fzf#install()"},
            rtp = "~/.fzf"
        }
        use {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.1",
            requires = {{"nvim-lua/plenary.nvim"}}
        }
        use "amix/vim-zenroom2"
        use "junegunn/goyo.vim"
        use "pechorin/any-jump.vim"
        use "terryma/vim-expand-region" -- Usage: +/- to expand/shrink
        use {"mg979/vim-visual-multi", branch = "master"}
        use "vim-scripts/mru.vim"
        use {
            "m-demare/hlargs.nvim",
            config = function()
                require("hlargs").setup()
            end
        }
        -- buffer
        use "jlanzarotta/bufexplorer"
        -- statusline
        use "itchyny/lightline.vim"
        use "nvim-lua/lsp-status.nvim"

        ---------------------------
        -- Languages
        ---------------------------

        use "mhartington/formatter.nvim"
        use "Olical/conjure"
        use "bhurlow/vim-parinfer"
        use "Vimjas/vim-python-pep8-indent"
        use "cdelledonne/vim-cmake"
        use "chr4/nginx.vim"
        use "chrisbra/csv.vim"
        use "digitaltoad/vim-pug"
        use "editorconfig/editorconfig-vim"
        use "groenewege/vim-less"
        use {
            "jalvesaq/Nvim-R",
            requires = {
                {"jalvesaq/cmp-nvim-r"},
                {"jalvesaq/colorout"}
                -- {"jalvesaq/zotcite"},
                -- {"jalvesaq/cmp-zotcite"}
            }
        }
        use "kchmck/vim-coffee-script"
        use "leafgarland/typescript-vim"
        use "lervag/vimtex"
        use "pangloss/vim-javascript"
        use "plasticboy/vim-markdown"
        use "rust-lang/rust.vim"
        use "neovimhaskell/haskell-vim"
        use "nvie/vim-flake8"
        use "vim-ruby/vim-ruby"
        use "tarekbecker/vim-yaml-formatter"
        use "sophacles/vim-bundle-mako"
        use {"vlime/vlime", rtp = "vim/"}

        -- preview markdown
        use(
            {
                "iamcco/markdown-preview.nvim",
                run = function()
                    vim.fn["mkdp#util#install"]()
                end
            }
        )

        ---------------------------
        -- LSP and improvement
        ---------------------------

        use "neovim/nvim-lspconfig"
        use "ojroques/nvim-lspfuzzy"
        -- vscode-like pictograms
        use {
            "onsails/lspkind-nvim",
            config = function()
                require("lspkind").init(
                    {
                        preset = "codicons"
                    }
                )
            end
        }
        use {
            "rmagatti/goto-preview",
            config = function()
                require("goto-preview").setup()
            end
        }
        use "weilbith/nvim-code-action-menu"
        use {
            "kosayoda/nvim-lightbulb",
            config = function()
                require("nvim-lightbulb").setup({autocmd = {enabled = true}})
            end
        }
        use "antoinemadec/FixCursorHold.nvim"

        ---------------------------
        -- Completion
        ---------------------------

        use {
            "hrsh7th/nvim-cmp",
            requires = {
                {"neovim/nvim-lspconfig"},
                {"hrsh7th/cmp-nvim-lsp", branch = "main"},
                {"hrsh7th/cmp-buffer"},
                {"hrsh7th/cmp-path"},
                {"hrsh7th/cmp-cmdline"},
                {"L3MON4D3/LuaSnip"},
                {"saadparwaiz1/cmp_luasnip"},
                {"lukas-reineke/cmp-under-comparator", opt = true}
            }
        }
        use {
            "SmiteshP/nvim-navic",
            requires = "neovim/nvim-lspconfig"
        }
        use "PaterJason/cmp-conjure"
        use "nvim-treesitter/nvim-treesitter"
        use "nvim-treesitter/nvim-treesitter-refactor"
        use "windwp/nvim-autopairs"
        use "junegunn/rainbow_parentheses.vim"

        ---------------------------
        -- Themes
        ---------------------------

        use "dracula/vim"
        use "morhetz/gruvbox"
        use "tomasiser/vim-code-dark"
        use "Mofiqul/vscode.nvim"

        ---------------------------
        -- Misc
        ---------------------------

        use "airblade/vim-gitgutter"
        use "tpope/vim-fugitive"
        use "mattn/vim-gist"
        use "amix/open_file_under_cursor.vim"
        use "kassio/neoterm"
        use "mfussenegger/nvim-dap" --  Debug Adapter Protocol client
        use {
            "https://gist.github.com/caesar0301/29d5af8cd360e0ff9bf443bf949a179b",
            as = "peepopen.vim",
            run = "mkdir -p plugin; cp -f *.vim plugin/"
        }
    end
)
