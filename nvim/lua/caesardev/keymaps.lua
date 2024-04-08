local keymap = vim.keymap

-- Quickly quit terminal mode: <C-\><C-n>
vim.keymap.set("t", "<leader>kt", [[<C-\><C-n>]])

-- Toggle plugin gitgutter
vim.keymap.set("n", "<leader>gu", "<cmd>GitGutterToggle<cr>", {silent = true})

-- Pressing ,ss will toggle and untoggle spell checking
vim.keymap.set("", "<leader>ss", "<cmd>setlocal spell!<cr>")

-- Extra spelling shortcuts
vim.keymap.set("", "<learder>sn", "]s")
vim.keymap.set("", "<learder>sp", "[s")
vim.keymap.set("", "<learder>sa", "zg")
vim.keymap.set("", "<learder>s?", "z=")

-- Smart way to move between windows
vim.keymap.set("", "<C-j>", "<C-W>j")
vim.keymap.set("", "<C-k>", "<C-W>k")
vim.keymap.set("", "<C-h>", "<C-W>h")
vim.keymap.set("", "<C-l>", "<C-W>l")

-- Toggle plugin nvim-tree
vim.keymap.set("n", "<F8>", "<cmd>:NvimTreeFindFileToggle!<cr>", {noremap = true})
vim.keymap.set("n", "<leader>nn", "<cmd>:NvimTreeFindFile!<cr>", {noremap = true})

-- Switch CWD to the directory of the open buffer
vim.keymap.set("", "<leader>cd", "<cmd>cd %:p:h<cr>:pwd<cr>", {noremap = true})

-- Useful mappings for managing tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", {noremap = true})
vim.keymap.set("n", "<leader>te", ":tabedit " .. vim.fn.expand("%:p:h") .. "<CR>", {noremap = true})
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", {noremap = true})
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", {noremap = true})
vim.keymap.set("n", "<leader>tm", ":tabmove", {noremap = true})
vim.keymap.set("n", "<leader>t<leader>", ":tabnext<CR>", {noremap = true})

-- Move to previous/next, with plugin barbar
vim.keymap.set("n", "<A-,>", "<cmd>BufferPrevious<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<A-.>", "<cmd>BufferNext<CR>", {noremap = true, silent = true})

-- Re-order to previous/next, with plugin barbar
vim.keymap.set("n", "<A-<>", "<cmd>BufferMovePrevious<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<A->>", "<cmd>BufferMoveNext<CR>", {noremap = true, silent = true})

-- Goto buffer in position..., with plugin barbar
vim.keymap.set("n", "<leader><A-1>", "<cmd>BufferGoto 1<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader><A-2>", "<cmd>BufferGoto 2<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader><A-3>", "<cmd>BufferGoto 3<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader><A-4>", "<cmd>BufferGoto 4<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader><A-5>", "<cmd>BufferGoto 5<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader><A-6>", "<cmd>BufferGoto 6<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader><A-7>", "<cmd>BufferGoto 7<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader><A-8>", "<cmd>BufferGoto 8<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader><A-9>", "<cmd>BufferGoto 9<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader><A-0>", "<cmd>BufferLast<CR>", {noremap = true, silent = true})

-- Pin/unpin buffer, with plugin barbar
vim.keymap.set("n", "<leader><A-p>", "<cmd>BufferPin<CR>", {noremap = true, silent = true})

-- Close buffer, with plugin barbar
vim.keymap.set("n", "<leader><A-x>", "<cmd>BufferClose<CR>", {noremap = true, silent = true})

-- Restore buffer, with plugin barbar
vim.keymap.set("n", "<leader><A-r>", "<cmd>BufferRestore<CR>", {noremap = true, silent = true})

-- Close all but current, with plugin barbar
vim.keymap.set("n", "<leader><A-c>", "<cmd>BufferCloseAllButCurrent<CR>", {noremap = true, silent = true})

-- Tagbar mappings, with plugin tagbar
vim.keymap.set("n", "<leader>tt", ":TagbarToggle<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<F9>", ":TagbarToggle<CR>", {noremap = true, silent = true})

-- Goto code, with plugin AnyJump
vim.keymap.set("n", "<leader>aj", ":AnyJump<CR>", {noremap = true, silent = true})
vim.keymap.set("x", "<leader>aj", ":AnyJumpVisual<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>ab", ":AnyJumpBack<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>al", ":AnyJumpLastResults<CR>", {noremap = true, silent = true})

-- Remap VIM 0 to first non-blank character
vim.keymap.set("", "0", "^", {noremap = true})

-- Goto line head and tail
vim.keymap.set("n", "<C-a>", "<ESC>^", {noremap = true})
vim.keymap.set("i", "<C-a>", "<ESC>I", {noremap = true})
vim.keymap.set("n", "<C-e>", "<ESC>$", {noremap = true})
vim.keymap.set("i", "<C-e>", "<ESC>A", {noremap = true})

-- Map <leader> to / (search) and Ctrl-<leader> to ? (backwards search)
vim.keymap.set("n", "<space>", "/", {noremap = true})
vim.keymap.set("n", "<C-space>", "?", {noremap = true})

-- Search the word under the cursor, with plugin fzf.vim
vim.keymap.set(
    "n",
    "<leader>fw",
    '<cmd>lua fzf#vim#ag(vim.fn.expand("<cword>"), fzf#vim#with_preview())<CR>',
    {noremap = true, silent = true}
)

-- Search everywhere, requires the_silver_searcher
vim.keymap.set("n", "<leader>fW", ":Ag<CR>", {noremap = true, silent = true})

-- Search MRU file history, with plugin mru.vim
vim.keymap.set("n", "<leader>fr", "<cmd>MRU<CR>", {noremap = true, silent = true})

-- Search with plugin Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {noremap = true, silent = true})

-- Search with plugin Spectre
vim.keymap.set(
    "n",
    "<leader>S",
    '<cmd>lua require("spectre").toggle()<CR>',
    {
        desc = "Toggle Spectre"
    }
)
vim.keymap.set(
    "n",
    "<leader>sw",
    '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
    {
        desc = "Search current word"
    }
)
vim.keymap.set(
    "v",
    "<leader>sw",
    '<esc><cmd>lua require("spectre").open_visual()<CR>',
    {
        desc = "Search current word"
    }
)
vim.keymap.set(
    "n",
    "<leader>sp",
    '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
    {
        desc = "Search on current file"
    }
)

-- Zen mode with plugin Goyo
vim.keymap.set("n", "<leader>z", ":Goyo<CR>", {noremap = true, silent = true})

-- Compile run
vim.keymap.set("n", "<F5>", "<cmd>call CompileRun()<CR>", {noremap = true})
vim.keymap.set("i", "<F5>", "<Esc><cmd>call CompileRun()<CR>", {noremap = true})
vim.keymap.set("v", "<F5>", "<Esc><cmd>call CompileRun()<CR>", {noremap = true})

-- vimtex shortcuts
