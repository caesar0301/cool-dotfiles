--********
-- Editing
--********

-- MLE: avoid accidental case changing
vim.api.nvim_create_user_command("W", "wa", {desc = "Save all buffers"})
vim.api.nvim_create_user_command("Q", "qa", {desc = "Quit all buffers"})
vim.api.nvim_create_user_command("Wq", "waq", {desc = "Save all buffers and quit current"})
vim.api.nvim_create_user_command("WQ", "waqa", {desc = "Save and quit all buffers"})
vim.api.nvim_create_user_command("Qa", "qa", {desc = "Quit all buffers"})
vim.keymap.set({"n", "v"}, "<leader>W", "<cmd>wa<cr>", {desc = "Save all buffers"})
vim.keymap.set({"n", "v"}, "<leader>Q", "<cmd>qa<cr>", {desc = "Quit all buffers"})
vim.keymap.set("n", "<C-s>", ":w<CR>", {desc = "Save current buffer"})
vim.keymap.set("i", "<C-s>", "<ESC>:w<CR>l", {desc = "Save current buffer"})
vim.keymap.set("v", "<C-s>", "<ESC>:w<CR>", {desc = "Save current buffer"})

-- MLE: disable Join to avoid accidental trigger
vim.keymap.set({"n", "v"}, "J", "<Nop>", {silent = true, desc = "Disable [J]oin action"})

-- MLE: remap VIM 0 to first non-blank character
vim.keymap.set("", "0", "^", opt_s("Goto first non-blank char"))

-- Goto line head and tail
vim.keymap.set("n", "<C-a>", "<ESC>^", opt_s("Goto line head"))
vim.keymap.set("i", "<C-a>", "<ESC>I", opt_s("Goto line head"))
vim.keymap.set("n", "<C-e>", "<ESC>$", opt_s("Goto line tail"))
vim.keymap.set("i", "<C-e>", "<ESC>A", opt_s("Goto line tail"))

-- Goto code, with plugin AnyJump
vim.keymap.set("n", "<leader>aj", ":AnyJump<CR>", opt_s("[AnyJump] jump to symbol"))
vim.keymap.set("x", "<leader>aj", ":AnyJumpVisual<CR>", opt_s("[AnyJump] jump to symbol visual"))
vim.keymap.set("n", "<leader>ab", ":AnyJumpBack<CR>", opt_s("[AnyJump] jump back"))
vim.keymap.set("n", "<leader>al", ":AnyJumpLastResults<CR>", opt_s("[AnyJump] jump to last results"))

-- Format with plugin formatter.nvim
vim.keymap.set("n", "<leader>af", ":w<CR><bar>:Format<CR>", opt_s("Format current buffer"))

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
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move selected downwards"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move selected upwards"})

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
vim.keymap.set("", "<leader>ss", "<cmd>setlocal spell!<cr>", opt_s("Toggle spell checking"))

--**********************
-- View, Window and Tabs
--**********************

-- Smart way to move between windows
vim.keymap.set("", "<C-j>", "<C-W>j")
vim.keymap.set("", "<C-k>", "<C-W>k")
vim.keymap.set("", "<C-h>", "<C-W>h")
vim.keymap.set("", "<C-l>", "<C-W>l")

-- Toggle plugin nvim-tree
vim.keymap.set("n", "<F8>", "<cmd>:NvimTreeFindFileToggle!<cr>", opt_s("[nvim-tree] Toggle find file"))
vim.keymap.set("n", "<leader>N", "<cmd>:NvimTreeFindFileToggle!<cr>", opt_s("[nvim-tree] Toggle find file"))
vim.keymap.set("n", "<leader>nn", "<cmd>:NvimTreeFindFileToggle!<cr>", opt_s("[nvim-tree] Toggle find file"))

-- Switch CWD to the directory of the open buffer
vim.keymap.set("", "<leader>cd", "<cmd>cd %:p:h<cr>:pwd<cr>", opt_s("CWD to dir of current buffer"))

-- Move to previous/next, with plugin barbar
vim.keymap.set("n", "<A-,>", "<cmd>BufferPrevious<CR>", opt_s("[barbar] Previous buffer"))
vim.keymap.set("n", "<A-.>", "<cmd>BufferNext<CR>", opt_s("[barbar] Next buffer"))
vim.keymap.set("n", "<A-c>", "<cmd>BufferClose<CR>", opt_s("[barbar] Close current buffer"))
vim.keymap.set("n", "<A-C>", "<cmd>BufferCloseAllButCurrent<CR>", opt_s("[barbar] Close all but current"))
vim.keymap.set("n", "<A-r>", "<cmd>BufferRestore<CR>", opt_s("[[barbar] Restore last closed]"))
vim.keymap.set("n", "<C-p>", "<cmd>BufferPick<CR>", opt_s("[barbar] Magic buffer picker"))
vim.keymap.set("n", "<Space>bb", "<cmd>BufferOrderByBufferNumber<CR>", opt_s("[barbar] Order buffers by number"))
vim.keymap.set("n", "<Space>bn", "<cmd>BufferOrderByName<CR>", opt_s("[barbar] Order buffers by name"))
vim.keymap.set("n", "<Space>bd", "<cmd>BufferOrderByDirectory<CR>", opt_s("[barbar] Order buffers by dir"))
vim.keymap.set("n", "<Space>bl", "<cmd>BufferOrderByLanguage<CR>", opt_s("[barbar] Order buffers by lang"))
vim.keymap.set("n", "<Space>bw", "<cmd>BufferOrderByWindowNumber<CR>", opt_s("[barbar] Order buffers by window number"))

-- Tagbar mappings, with plugin tagbar
vim.keymap.set("n", "<leader>tt", ":TagbarToggle<CR>", opt_s("[tagbar] Toggle tagbar"))
vim.keymap.set("n", "<F9>", ":TagbarToggle<CR>", opt_s("[tagbar] Toggle tagbar"))

--*******************
-- Search and Replace
--*******************

-- Map <leader> to / (search) and Ctrl-<leader> to ? (backwards search)
vim.keymap.set("n", "<space>", "/", opt_s("Search"))
vim.keymap.set("n", "<C-space>", "?", opt_s("Backwards search"))

-- Search with plugin Telescope
-- Shortcuts:
--   <leader>ff: list files in CWD.
--   <leader>fw: search for the string under cursor or selection in CWD.
--   <leader>fg: search for a string in CWD.
--   <leader>fd: search for a string in a given directory.

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, opt_s("[telescope] Find files"))
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, opt_s("[telescope] Find current word"))
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, opt_s("[telescope] Search everywhere"))
local function live_grep_directory()
    local dir = vim.fn.input("Directory: ", vim.fn.expand("%:p:h"), "dir")
    require("telescope.builtin").live_grep({cwd = dir})
end
vim.keymap.set("n", "<leader>fd", live_grep_directory, {desc = "[telescope] Search in directory"})

-- Find and replace current word under cursor (case sensitive)
vim.keymap.set(
    "n",
    "<leader>rw",
    ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    opt_s("Replace current word (case sensitive)")
)
vim.keymap.set(
    "v",
    "<leader>rw",
    ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    opt_s("Replace current word (case sensitive)")
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
vim.keymap.set("n", "<leader>fr", ":FindAndReplace ", opt_s("[QuickFix] Find and replace"))

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
    opt_s("Clear highlight of search, messages, floating windows")
)

--*********
-- Terminal
--*********

-- open term with toggleterm.nvim
vim.keymap.set("n", "<leader>T", "<cmd>:ToggleTerm<cr>", opt_s("ToggleTerm"))

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
vim.keymap.set("n", "<leader>gu", "<cmd>GitGutterToggle<cr>", opt_s("Toggle GitGutter"))

-- Trigger gitignore interactive
vim.keymap.set("n", "<leader>gi", require("gitignore").generate, opt_s("Add gitignore"))

-- Zen mode with plugin Goyo
vim.keymap.set("n", "<leader>Z", ":Goyo<CR>", opt_s("Toggle ZEN mode"))

-- Compile run
vim.keymap.set("n", "<F5>", "<cmd>call CompileRun()<CR>", opt_s("Compile and Run"))
vim.keymap.set("i", "<F5>", "<Esc><cmd>call CompileRun()<CR>", opt_s("Compile and Run"))
vim.keymap.set("v", "<F5>", "<Esc><cmd>call CompileRun()<CR>", opt_s("Compile and Run"))
