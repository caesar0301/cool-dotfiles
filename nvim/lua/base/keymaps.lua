--********
-- Editing
--********

-- MLE: avoid accidental case changing
vim.api.nvim_create_user_command("W", "wa", {})
vim.api.nvim_create_user_command("Q", "qa", {})
vim.api.nvim_create_user_command("Wq", "waq", {})
vim.api.nvim_create_user_command("WQ", "waqa", {})
vim.api.nvim_create_user_command("Qa", "qa", {})

-- Write and quit all buffers
vim.keymap.set({"n", "v"}, "<leader>W", "<cmd>wa<cr>", {desc = "Save all buffers (:wa)"})
vim.keymap.set({"n", "v"}, "<leader>Q", "<cmd>qa<cr>", {desc = "Quite all buffers (:qa)"})

-- Save with Ctrl + s
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("i", "<C-s>", "<ESC>:w<CR>l")
vim.keymap.set("v", "<C-s>", "<ESC>:w<CR>")

-- MLE: disable Join to avoid accidental trigger
vim.keymap.set({"n", "v"}, "J", "<Nop>", {silent = true, desc = "disable [J]oin action"})

-- MLE: remap VIM 0 to first non-blank character
vim.keymap.set("", "0", "^", {noremap = true})

-- Goto line head and tail
vim.keymap.set("n", "<C-a>", "<ESC>^", {noremap = true})
vim.keymap.set("i", "<C-a>", "<ESC>I", {noremap = true})
vim.keymap.set("n", "<C-e>", "<ESC>$", {noremap = true})
vim.keymap.set("i", "<C-e>", "<ESC>A", {noremap = true})

-- Goto code, with plugin AnyJump
vim.keymap.set("n", "<leader>aj", ":AnyJump<CR>", {silent = true})
vim.keymap.set("x", "<leader>aj", ":AnyJumpVisual<CR>", {silent = true})
vim.keymap.set("n", "<leader>ab", ":AnyJumpBack<CR>", {silent = true})
vim.keymap.set("n", "<leader>al", ":AnyJumpLastResults<CR>", {silent = true})

-- Format with plugin formatter.nvim
vim.keymap.set("n", "<leader>af", ":w<CR><bar>:Format<CR>")

-- Smart insert in blank line (auto indent)
vim.keymap.set(
    "n",
    "i",
    function()
        if #vim.fn.getline(".") == 0 then
            return [["_cc]]
        else
            return "i"
        end
    end,
    {expr = true}
)

-- Move line in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Mapping for dd that doesn't yank an empty line into your default register:
vim.keymap.set(
    "n",
    "dd",
    function()
        if vim.api.nvim_get_current_line():match("^%s*$") then
            return '"_dd'
        else
            return "dd"
        end
    end,
    {expr = true}
)

-- Delete a word using Ctrl+Backspace
vim.keymap.set("i", "<C-BS>", "<C-w>")
vim.keymap.set("c", "<C-BS>", "<C-w>")

-- Pressing ,ss will toggle and untoggle spell checking
vim.keymap.set("", "<leader>ss", "<cmd>setlocal spell!<cr>")

--**********************
-- View, Window and Tabs
--**********************

-- Smart way to move between windows
vim.keymap.set("", "<C-j>", "<C-W>j")
vim.keymap.set("", "<C-k>", "<C-W>k")
vim.keymap.set("", "<C-h>", "<C-W>h")
vim.keymap.set("", "<C-l>", "<C-W>l")

-- Toggle plugin nvim-tree
vim.keymap.set("n", "<F8>", "<cmd>:NvimTreeFindFileToggle!<cr>", {})
vim.keymap.set("n", "<leader>N", "<cmd>:NvimTreeFindFileToggle!<cr>", {})
vim.keymap.set("n", "<leader>nn", "<cmd>:NvimTreeFindFileToggle!<cr>", {})

-- Switch CWD to the directory of the open buffer
vim.keymap.set("", "<leader>cd", "<cmd>cd %:p:h<cr>:pwd<cr>")

-- Move to previous/next, with plugin barbar
vim.keymap.set("n", "<A-,>", "<cmd>BufferPrevious<CR>", {silent = true})
vim.keymap.set("n", "<A-.>", "<cmd>BufferNext<CR>", {silent = true})

-- Close/Restore buffer, with plugin barbar
vim.keymap.set("n", "<leader><A-c>", "<cmd>BufferClose<CR>", {silent = true})
vim.keymap.set("n", "<leader><A-C>", "<cmd>BufferCloseAllButCurrent<CR>", {silent = true})
vim.keymap.set("n", "<leader><A-r>", "<cmd>BufferRestore<CR>", {silent = true})

-- Tagbar mappings, with plugin tagbar
vim.keymap.set("n", "<leader>tt", ":TagbarToggle<CR>", {silent = true})
vim.keymap.set("n", "<F9>", ":TagbarToggle<CR>", {silent = true})

--*******************
-- Search and Replace
--*******************

-- Map <leader> to / (search) and Ctrl-<leader> to ? (backwards search)
vim.keymap.set("n", "<space>", "/", {noremap = true})
vim.keymap.set("n", "<C-space>", "?", {noremap = true})

-- Search with plugin Telescope
-- Lists files in your current working directory, respects .gitignore
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)

-- Searches for the string under your cursor or selection in your current working directory
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string)

-- Search for a string in your current working directory and get results live as you type, respects .gitignore
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)

-- Find and replace current word under cursor (case sensitive)
vim.keymap.set(
    "n",
    "<leader>rw",
    ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    {desc = "Replace current word (case sensitive)"}
)
vim.keymap.set(
    "v",
    "<leader>rw",
    ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    {desc = "Replace current word (case sensitive)"}
)
vim.keymap.set({"n", "v"}, "<leader>R", "<leader>rw", {remap = true})

-- Find and replace with cdo
vim.api.nvim_create_user_command(
    "FindAndReplace",
    function(opts)
        vim.api.nvim_command(string.format("cdo s/%s/%s", opts.fargs[1], opts.fargs[2]))
        vim.api.nvim_command("cfdo update")
    end,
    {nargs = "*"}
)
vim.keymap.set("n", "<leader>fr", ":FindAndReplace ", {noremap = true})

-- Use Telescope to search the provided path
vim.api.nvim_create_user_command(
    "FindDir",
    function(opts)
        local builtin = require("telescope.builtin")
        builtin.live_grep({prompt_title = "Search in " .. opts.fargs[1], cwd = opts.fargs[1]})
    end,
    {nargs = 1}
)

-- Open file_browser with the path of the current buffer
vim.keymap.set(
    "n",
    "<leader>fb",
    function()
        require("telescope").extensions.file_browser.file_browser()
    end
)

-- clear highlight of search, messages, floating windows
vim.keymap.set(
    {"n", "i"},
    "<Esc>",
    function()
        vim.cmd([[nohl]]) -- clear highlight of search
        vim.cmd([[stopinsert]]) -- clear messages (the line below statusline)
        for _, win in ipairs(vim.api.nvim_list_wins()) do -- clear all floating windows
            if vim.api.nvim_win_get_config(win).relative == "win" then
                vim.api.nvim_win_close(win, false)
            end
        end
    end,
    {desc = "Clear highlight of search, messages, floating windows"}
)

--*********
-- Terminal
--*********

-- open term with toggleterm.nvim
vim.keymap.set("n", "<leader>T", "<cmd>:ToggleTerm<cr>", {})

-- moving in and out of a terminal easier once toggled, whilst still keeping it open.
function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

--**************
-- Miscellaneous
--**************

-- Toggle plugin gitgutter
vim.keymap.set("n", "<leader>gu", "<cmd>GitGutterToggle<cr>", {silent = true})

-- Trigger gitignore interactive
vim.keymap.set("n", "<leader>gi", require("gitignore").generate, {desc = "Add gitignore"})

-- Zen mode with plugin Goyo
vim.keymap.set("n", "<leader>Z", ":Goyo<CR>", {silent = true, desc = "Toggle ZEN mode"})

-- Compile run
vim.keymap.set("n", "<F5>", "<cmd>call CompileRun()<CR>")
vim.keymap.set("i", "<F5>", "<Esc><cmd>call CompileRun()<CR>")
vim.keymap.set("v", "<F5>", "<Esc><cmd>call CompileRun()<CR>")
