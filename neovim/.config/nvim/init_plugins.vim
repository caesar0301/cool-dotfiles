"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Xiaming Chen - @caesar0301
" Prerequisites:
"       vim-plug: https://github.com/junegunn/vim-plug
"       neovim: 0.8+
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-plug
call plug#begin()

" Make sure you use single quotes

Plug 'L3MON4D3/LuaSnip'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Olical/conjure'
Plug 'PaterJason/cmp-conjure'
Plug 'RishabhRD/nvim-lsputils'
Plug 'RishabhRD/popfix'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'amix/open_file_under_cursor.vim'
Plug 'amix/vim-zenroom2'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'bhurlow/vim-parinfer'
Plug 'cdelledonne/vim-cmake'
Plug 'chr4/nginx.vim'
Plug 'chrisbra/csv.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'digitaltoad/vim-pug'
Plug 'dracula/vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'garbas/vim-snipmate'
Plug 'groenewege/vim-less'
Plug 'honza/vim-snippets'
Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
Plug 'hrsh7th/nvim-cmp'
Plug 'itchyny/lightline.vim'
Plug 'jalvesaq/Nvim-R'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'jlanzarotta/bufexplorer'
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'kassio/neoterm'
Plug 'kchmck/vim-coffee-script'
Plug 'kosayoda/nvim-lightbulb'
Plug 'leafgarland/typescript-vim'
Plug 'lervag/vimtex'
Plug 'mattn/vim-gist'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-jdtls'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mileszs/ack.vim'
Plug 'morhetz/gruvbox'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'neovim/nvim-lspconfig'
Plug 'neovimhaskell/haskell-vim'
Plug 'nvie/vim-flake8'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'onsails/lspkind.nvim'
Plug 'pangloss/vim-javascript'
Plug 'pechorin/any-jump.vim'
Plug 'plasticboy/vim-markdown'
Plug 'preservim/nerdtree'
Plug 'preservim/tagbar'
Plug 'rust-lang/rust.vim'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'simrat39/symbols-outline.nvim'
Plug 'sophacles/vim-bundle-mako'
Plug 'tarekbecker/vim-yaml-formatter'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'therubymug/vim-pyte'
Plug 'tomasiser/vim-code-dark'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-autoformat/vim-autoformat'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/mayansmoke'
Plug 'vim-scripts/mru.vim'
Plug 'vlime/vlime', {'rtp': 'vim/'}
Plug 'windwp/nvim-autopairs'

" Custom plugin
Plug 'https://gist.github.com/caesar0301/f510e0e1a21b93081ea06c9a223df05b',
    \ { 'as': 'set_tabline.vim', 'do': 'mkdir -p plugin; cp -f *.vim plugin/' }
Plug 'https://gist.github.com/caesar0301/29d5af8cd360e0ff9bf443bf949a179b',
    \ { 'as': 'peepopen.vim', 'do': 'mkdir -p plugin; cp -f *.vim plugin/' }

call plug#end()
