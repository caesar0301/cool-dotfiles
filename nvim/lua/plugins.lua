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
        use "tpope/vim-surround"

        ---------------------------
        -- Navigation
        ---------------------------
        use {
            "nvim-tree/nvim-tree.lua",
            requires = {
                {"nvim-tree/nvim-web-devicons"},
                {"antosha417/nvim-lsp-file-operations", opt = true},
                {"echasnovski/mini.base16", opt = true}
            }
        }
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
        use "michaeljsmith/vim-indent-object"
        use "preservim/vim-indent-guides"
        use "vim-scripts/mru.vim"
        use {
            "m-demare/hlargs.nvim",
            config = function()
                require("hlargs").setup()
            end
        }

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
        use "jalvesaq/Nvim-R"
        use "kchmck/vim-coffee-script"
        use "leafgarland/typescript-vim"
        use "lervag/vimtex"
        -- use "mfussenegger/nvim-jdtls"
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
        use "onsails/lspkind.nvim"
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
        use "windwp/nvim-ts-autotag"
        use(
            {
                "kylechui/nvim-surround",
                tag = "*", -- Use for stability; omit to use `main` branch for the latest features
                config = function()
                    require("nvim-surround").setup({})
                end
            }
        )

        ---------------------------
        -- Themes
        ---------------------------
        use "dracula/vim"
        use "altercation/vim-colors-solarized"
        use "morhetz/gruvbox"
        use "therubymug/vim-pyte"
        use "vim-scripts/mayansmoke"
        use "tomasiser/vim-code-dark"
        use "junegunn/rainbow_parentheses.vim"
        use "itchyny/lightline.vim"
        use "nvim-lua/lsp-status.nvim"
        use "jlanzarotta/bufexplorer"
        use {
            "romgrk/barbar.nvim",
            requires = {
                {"nvim-tree/nvim-web-devicons"}
            }
        }

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
