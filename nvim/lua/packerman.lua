vim.cmd [[packadd packer.nvim]]

return require("packer").startup(
    function(use)
        -- Packer can manage itself
        use "wbthomason/packer.nvim"

        -- Comment out with gc/gcc/gcap
        use "tpope/vim-commentary"

        -- Enable repeating supported plugin maps with "."
        use "tpope/vim-repeat"

        -- Code style formatter
        use "mhartington/formatter.nvim"

        -- Folder and file tree view
        use {
            "nvim-tree/nvim-tree.lua",
            requires = {
                {"nvim-tree/nvim-web-devicons"},
                {"antosha417/nvim-lsp-file-operations", opt = true},
                {"echasnovski/mini.base16", opt = true}
            }
        }

        -- Displays tags in a window, ordered by scope
        use "preservim/tagbar"

        -- Visually select increasingly larger regions of text.
        -- Use +/- to expand/shrink.
        use "terryma/vim-expand-region"

        -- Multiple selection and edit
        use {"mg979/vim-visual-multi", branch = "master"}

        -- Zen coding
        use {
            "amix/vim-zenroom2",
            requires = {{"junegunn/goyo.vim"}}
        }

        -- Tabline with auto-sizing, clickable tabs, icons, highlighting etc.
        use {
            "romgrk/barbar.nvim",
            requires = {
                {"nvim-tree/nvim-web-devicons"},
                {"lewis6991/gitsigns.nvim"}
            }
        }

        -- Highly extendable fuzzy finder over file and symbols
        use {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.6",
            requires = {
                {"nvim-lua/plenary.nvim"},
                {"BurntSushi/ripgrep"},
                {"nvim-telescope/telescope-fzf-native.nvim"},
                {"sharkdp/fd", opt = true},
                {"nvim-treesitter/nvim-treesitter", opt = true},
                {"nvim-tree/nvim-web-devicons", opt = true}
            }
        }

        -- Find and replace
        use {
            "nvim-pack/nvim-spectre",
            requires = {
                {"nvim-tree/nvim-web-devicons"},
                {"nvim-lua/plenary.nvim"}
            }
        }

        -- File open history with Most Recently Used
        use "vim-scripts/mru.vim"

        -- Configure neovim statusline
        use {
            "nvim-lualine/lualine.nvim",
            requires = {
                {"nvim-tree/nvim-web-devicons", opt = true},
                {"nvim-lua/lsp-status.nvim"}
            }
        }

        -- Themes
        use "dracula/vim"
        use "morhetz/gruvbox"
        use "tomasiser/vim-code-dark"
        use "Mofiqul/vscode.nvim"

        -- Quickstart configs for Nvim LSP
        use "neovim/nvim-lspconfig"

        -- Make the LSP client use FZF
        -- use {
        --     "ojroques/nvim-lspfuzzy",
        --     requires = {
        --         {"junegunn/fzf"},
        --         {"junegunn/fzf.vim"} -- to enable preview (optional)
        --     }
        -- }

        -- Previewing native LSP's goto definition etc. in floating window
        use {
            "rmagatti/goto-preview",
            config = function()
                require("goto-preview").setup()
            end
        }

        -- vscode-like lightbulb in the sign column
        use {
            "kosayoda/nvim-lightbulb",
            config = function()
                require("nvim-lightbulb").setup({autocmd = {enabled = true}})
            end
        }

        -- winbar/statusline plugin that shows current code context
        use {
            "SmiteshP/nvim-navic",
            requires = "neovim/nvim-lspconfig"
        }

        -- Finding defs/refs/impls using regexp engines like ripgrep/ag.
        use "pechorin/any-jump.vim"

        -- Code completion for Nvim LSP
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

        -- vscode-like pictograms for neovim LSP completion items
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

        -- Nvim interface to configure tree-sitter and syntax highlighting
        use "nvim-treesitter/nvim-treesitter"
        use {
            "nvim-treesitter/nvim-treesitter-refactor",
            requires = {
                {"nvim-treesitter/nvim-treesitter"}
            }
        }

        -- Highlight arguments' definitions and usages, using Treesitter
        use {
            "m-demare/hlargs.nvim",
            config = function()
                require("hlargs").setup()
            end,
            requires = {
                {"nvim-treesitter/nvim-treesitter"}
            }
        }

        -- Autopairs supporting multiple characters
        use "windwp/nvim-autopairs"

        -- Rainbow delimiters for Neovim with Tree-sitter
        use {
            "HiPhish/rainbow-delimiters.nvim",
            requires = {
                {"nvim-treesitter/nvim-treesitter"}
            }
        }

        -- Add/change/delete surrounding delimiter pairs with ease
        use(
            {
                "kylechui/nvim-surround",
                tag = "*", -- Use for stability; omit to use `main` branch for the latest features
                config = function()
                    require("nvim-surround").setup({})
                end
            }
        )

        -- nvim-cmp source for conjure
        use "PaterJason/cmp-conjure"

        -- Indent clojure and lisp code using parinfer
        use "bhurlow/vim-parinfer"

        -- Interactive evaluation Conjure and lisp code
        use "Olical/conjure"

        -- CMake integration comparable to vscode-cmake-tools
        use {
            "Civitasv/cmake-tools.nvim",
            requires = {
                {"nvim-lua/plenary.nvim"}
            }
        }

        -- Syntax highlighting for Nginx
        use "chr4/nginx.vim"

        -- Syntax highlighting for Pug (formerly Jade) templates
        use "digitaltoad/vim-pug"

        -- Synatx highlighting for EditorConfig
        use "editorconfig/editorconfig-vim"

        -- Synatx highlighting for LESS
        use "groenewege/vim-less"

        -- CoffeeScript support for vim, syntax/indenting/compiling
        use "kchmck/vim-coffee-script"

        -- Synatx highlighting for TypeScript
        use "leafgarland/typescript-vim"

        -- Javascript indentation and syntax support
        use "pangloss/vim-javascript"

        -- Rlang support for vim
        use {
            "jalvesaq/Nvim-R",
            requires = {
                {"jalvesaq/cmp-nvim-r"},
                {"jalvesaq/colorout"}
                -- {"jalvesaq/zotcite"},
                -- {"jalvesaq/cmp-zotcite"}
            }
        }

        -- Synatx highlighting for LaTeX
        use "lervag/vimtex"

        -- Rust support for vim
        use "rust-lang/rust.vim"

        -- Synatx highlighting for Haskell
        use "neovimhaskell/haskell-vim"

        -- Python indentation style to comply with PEP8
        use "Vimjas/vim-python-pep8-indent"

        -- Python static syntax and style checker using Flake8
        use "nvie/vim-flake8"

        -- Synatx highlighting for Mako
        use "sophacles/vim-bundle-mako"

        -- Synatx highlighting for Ruby
        use "vim-ruby/vim-ruby"

        -- Common Lisp dev environment for Vim
        use {"vlime/vlime", rtp = "vim/"}

        -- CSV filetype integration
        use "chrisbra/csv.vim"

        -- Markdown support in vim
        use "plasticboy/vim-markdown"

        -- Preview Markdown in modern browser
        use(
            {
                "iamcco/markdown-preview.nvim",
                run = function()
                    vim.fn["mkdp#util#install"]()
                end
            }
        )

        -- Show git diff markers in the sign column
        use "airblade/vim-gitgutter"

        -- Git command wrapper
        use "tpope/vim-fugitive"

        -- A vimscript for creating gists
        use "mattn/vim-gist"

        -- Generating .gitignore files
        use(
            {
                "wintermute-cell/gitignore.nvim",
                requires = {
                    "nvim-telescope/telescope.nvim" -- optional: for multi-select
                }
            }
        )

        -- Wrapper of some vim/neovim's :terminal functions
        use "kassio/neoterm"

        -- Debug Adapter Protocol client implementation for Neovim
        use "mfussenegger/nvim-dap"
    end
)
