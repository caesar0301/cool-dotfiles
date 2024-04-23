local api = vim.api
local keymap = vim.keymap

-- Avoid accidental case changing
api.nvim_create_user_command("W", "wa", {})
api.nvim_create_user_command("Q", "qa", {})
api.nvim_create_user_command("Wq", "waq", {})
api.nvim_create_user_command("WQ", "waqa", {})
api.nvim_create_user_command("Qa", "qa", {})

-- MLE: disable Join to avoid accidental trigger
keymap.set({"n", "v"}, "J", "<Nop>", {silent = true, desc = "disable [J]oin action"})

-- Quickly quit terminal mode: <C-\><C-n>
keymap.set("t", "<leader>kt", [[<C-\><C-n>]])

-- Toggle plugin gitgutter
keymap.set("n", "<leader>gu", "<cmd>GitGutterToggle<cr>", {silent = true})

-- Smart way to move between windows
keymap.set("", "<C-j>", "<C-W>j")
keymap.set("", "<C-k>", "<C-W>k")
keymap.set("", "<C-h>", "<C-W>h")
keymap.set("", "<C-l>", "<C-W>l")

-- Toggle plugin nvim-tree
keymap.set("n", "<F8>", "<cmd>:NvimTreeFindFileToggle!<cr>", {})
keymap.set("n", "<leader>N", "<cmd>:NvimTreeFindFileToggle!<cr>", {})
keymap.set("n", "<leader>nn", "<cmd>:NvimTreeFindFileToggle!<cr>", {})

-- Switch CWD to the directory of the open buffer
keymap.set("", "<leader>cd", "<cmd>cd %:p:h<cr>:pwd<cr>")

-- Useful mappings for managing tabs
keymap.set("n", "<leader>tn", ":tabnew<CR>")
keymap.set("n", "<leader>te", ":tabedit " .. vim.fn.expand("%:p:h") .. "<CR>")
keymap.set("n", "<leader>to", ":tabonly<CR>")
keymap.set("n", "<leader>tc", ":tabclose<CR>")
keymap.set("n", "<leader>tm", ":tabmove")
keymap.set("n", "<leader>t<leader>", ":tabnext<CR>")

-- Move to previous/next, with plugin barbar
keymap.set("n", "<A-,>", "<cmd>BufferPrevious<CR>", {silent = true})
keymap.set("n", "<A-.>", "<cmd>BufferNext<CR>", {silent = true})

-- Re-order to previous/next, with plugin barbar
keymap.set("n", "<A-<>", "<cmd>BufferMovePrevious<CR>", {silent = true})
keymap.set("n", "<A->>", "<cmd>BufferMoveNext<CR>", {silent = true})

-- Goto buffer in position..., with plugin barbar
keymap.set("n", "<leader><A-1>", "<cmd>BufferGoto 1<CR>", {silent = true})
keymap.set("n", "<leader><A-2>", "<cmd>BufferGoto 2<CR>", {silent = true})
keymap.set("n", "<leader><A-3>", "<cmd>BufferGoto 3<CR>", {silent = true})
keymap.set("n", "<leader><A-4>", "<cmd>BufferGoto 4<CR>", {silent = true})
keymap.set("n", "<leader><A-5>", "<cmd>BufferGoto 5<CR>", {silent = true})
keymap.set("n", "<leader><A-6>", "<cmd>BufferGoto 6<CR>", {silent = true})
keymap.set("n", "<leader><A-7>", "<cmd>BufferGoto 7<CR>", {silent = true})
keymap.set("n", "<leader><A-8>", "<cmd>BufferGoto 8<CR>", {silent = true})
keymap.set("n", "<leader><A-9>", "<cmd>BufferGoto 9<CR>", {silent = true})
keymap.set("n", "<leader><A-0>", "<cmd>BufferLast<CR>", {silent = true})

-- Pin/unpin buffer, with plugin barbar
keymap.set("n", "<leader><A-p>", "<cmd>BufferPin<CR>", {silent = true})

-- Close buffer, with plugin barbar
keymap.set("n", "<leader><A-x>", "<cmd>BufferClose<CR>", {silent = true})

-- Restore buffer, with plugin barbar
keymap.set("n", "<leader><A-r>", "<cmd>BufferRestore<CR>", {silent = true})

-- Close all but current, with plugin barbar
keymap.set("n", "<leader><A-c>", "<cmd>BufferCloseAllButCurrent<CR>", {silent = true})

-- Tagbar mappings, with plugin tagbar
keymap.set("n", "<leader>tt", ":TagbarToggle<CR>", {silent = true})
keymap.set("n", "<F9>", ":TagbarToggle<CR>", {silent = true})

-- Goto code, with plugin AnyJump
keymap.set("n", "<leader>aj", ":AnyJump<CR>", {silent = true})
keymap.set("x", "<leader>aj", ":AnyJumpVisual<CR>", {silent = true})
keymap.set("n", "<leader>ab", ":AnyJumpBack<CR>", {silent = true})
keymap.set("n", "<leader>al", ":AnyJumpLastResults<CR>", {silent = true})

-- Remap VIM 0 to first non-blank character
keymap.set("", "0", "^", {noremap = true})

-- Goto line head and tail
keymap.set("n", "<C-a>", "<ESC>^", {noremap = true})
keymap.set("i", "<C-a>", "<ESC>I", {noremap = true})
keymap.set("n", "<C-e>", "<ESC>$", {noremap = true})
keymap.set("i", "<C-e>", "<ESC>A", {noremap = true})

-- Map <leader> to / (search) and Ctrl-<leader> to ? (backwards search)
keymap.set("n", "<space>", "/", {noremap = true})
keymap.set("n", "<C-space>", "?", {noremap = true})

-- Search with plugin Telescope
local builtin = require("telescope.builtin")

-- Lists files in your current working directory, respects .gitignore
keymap.set("n", "<leader>ff", builtin.find_files)

-- Searches for the string under your cursor or selection in your current working directory
keymap.set("n", "<leader>fw", builtin.grep_string)

-- Search for a string in your current working directory and get results live as you type, respects .gitignore
keymap.set("n", "<leader>fg", builtin.live_grep)

-- Find and replace with cdo
vim.api.nvim_create_user_command(
    "FindAndReplace",
    function(opts)
        vim.api.nvim_command(string.format("cdo s/%s/%s", opts.fargs[1], opts.fargs[2]))
        vim.api.nvim_command("cfdo update")
    end,
    {nargs = "*"}
)
keymap.set("n", "<leader>fr", ":FindAndReplace ", {noremap = true})

-- Open file_browser with the path of the current buffer
keymap.set(
    "n",
    "<leader>fb",
    function()
        require("telescope").extensions.file_browser.file_browser()
    end
)

-- Use Telescope to search the provided path
api.nvim_create_user_command(
    "FindDir",
    function(opts)
        local builtin = require("telescope.builtin")
        builtin.live_grep({prompt_title = "Search in " .. opts.fargs[1], cwd = opts.fargs[1]})
    end,
    {nargs = 1}
)

-- Search and replace in current word (case sensitive)
keymap.set(
    "n",
    "<leader>rw",
    ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    {desc = "Replace current word (case sensitive)"}
)
keymap.set(
    "v",
    "<leader>rw",
    ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    {desc = "Replace current word (case sensitive)"}
)
keymap.set({"n", "v"}, "<leader>R", "<leader>rw", {remap = true})

-- clear highlight of search, messages, floating windows
keymap.set(
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

-- Format with plugin formatter.nvim
keymap.set("n", "<leader>af", ":w<CR><bar>:Format<CR>")

-- Zen mode with plugin Goyo
keymap.set("n", "<leader>Z", ":Goyo<CR>", {silent = true, desc = "Toggle ZEN mode"})

-- Compile run
keymap.set("n", "<F5>", "<cmd>call CompileRun()<CR>")
keymap.set("i", "<F5>", "<Esc><cmd>call CompileRun()<CR>")
keymap.set("v", "<F5>", "<Esc><cmd>call CompileRun()<CR>")

-- Trigger gitignore interactive
keymap.set("n", "<leader>gi", require("gitignore").generate, {desc = "Add gitignore"})

-- Write and quit all buffers
keymap.set({"n", "v"}, "<leader>W", "<cmd>wa<cr>", {desc = "Save all buffers (:wa)"})
keymap.set({"n", "v"}, "<leader>Q", "<cmd>qa<cr>", {desc = "Quite all buffers (:qa)"})

-- Save with Ctrl + s
keymap.set("n", "<C-s>", ":w<CR>")
keymap.set("i", "<C-s>", "<ESC>:w<CR>l")
keymap.set("v", "<C-s>", "<ESC>:w<CR>")

-- Smart insert in blank line (auto indent)
keymap.set(
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
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Mapping for dd that doesn't yank an empty line into your default register:
-- keymap.set(
--     "n",
--     "dd",
--     function()
--         if api.nvim_get_current_line():match("^%s*$") then
--             return '"_dd'
--         else
--             return "dd"
--         end
--     end,
--     {expr = true}
-- )

-- Mapping for dd that doesn't yank into your default register:
keymap.set(
    "n",
    "dd",
    function()
        return '"_dd'
    end,
    {expr = true}
)

-- Delete a word using Ctrl+Backspace
keymap.set("i", "<C-BS>", "<C-w>")
keymap.set("c", "<C-BS>", "<C-w>")

-- Yank in terminal ssh
keymap.set("n", "<leader>Y", "y:Oscyank<cr>")
keymap.set("v", "<leader>Y", "y:Oscyank<cr>")
keymap.set("x", "<F7>", "y:Oscyank<cr>")

-- Pressing ,ss will toggle and untoggle spell checking
keymap.set("", "<leader>ss", "<cmd>setlocal spell!<cr>")
