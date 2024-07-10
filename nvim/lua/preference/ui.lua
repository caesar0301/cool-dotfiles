-- Show line number
vim.opt.number = true

-- Text, tab and indent related
-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Be smart when using tabs ;)
vim.opt.smarttab = true

-- 1 tab == 4 spaces
vim.opt.tabstop = 4

-- fine-grained shifting = 2 spaces
vim.opt.shiftwidth = 2

-- Linebreak on 500 characters
vim.opt.linebreak = true
vim.opt.textwidth = 500

vim.opt.autoindent = true -- Auto indent
vim.opt.smartindent = true -- Smart indent
vim.opt.wrap = true -- Wrap lines

-- Chinese line wrapping
vim.opt.formatoptions:append("mM")

-- Set 7 lines to the cursor - when moving vertically using j/k
vim.opt.scrolloff = 7

-- Turn on the Wild menu
vim.opt.wildmenu = true

-- Ignore compiled files
vim.opt.wildignore = {"*.o", "*~", "*.pyc"}
if vim.fn.has("win16") or vim.fn.has("win32") then
    vim.opt.wildignore:append(".git/*", ".hg/*", ".svn/*")
else
    vim.opt.wildignore:append("*/.git/*", "*/.hg/*", "*/.svn/*", "*/.DS_Store")
end

-- Always show current position
vim.opt.ruler = true

-- Height of the command bar
vim.opt.cmdheight = 1

-- A buffer becomes hidden when it is abandoned
vim.opt.hidden = true

-- Configure backspace so it acts as it should act
vim.opt.backspace:append("eol", "start", "indent")
vim.opt.whichwrap:append("<", ">", "h", "l")

-- Ignore case when searching
vim.opt.ignorecase = true

-- When searching try to be smart about cases
vim.opt.smartcase = true

-- Highlight search results
vim.opt.hlsearch = true

-- Makes search act like search in modern browsers
vim.opt.incsearch = true

-- Don't redraw while executing macros (good performance config)
vim.opt.lazyredraw = true

-- For regular expressions turn magic on
vim.opt.magic = true

-- Show matching brackets when text indicator is over them
vim.opt.showmatch = true

-- How many tenths of a second to blink when matching brackets
vim.opt.matchtime = 2

-- No annoying sound on errors
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.tm = 500

-- Enable 256 colors palette in Gnome Terminal
if vim.env.COLORTERM == "gnome-terminal" then
    vim.opt.termguicolors = true
end

vim.opt.background = "dark"
-- One of dracula, gruvbox, vscode, codedark etc.
local status, result = pcall(vim.cmd, "colorscheme vscode")
if not status then
    vim.cmd("colorscheme elflord")
end

-- Set extra options when running in GUI mode
if vim.fn.has("gui_running") then
    vim.opt.termguicolors = true
    -- vim.opt.guitablabel = "%M %t"
end

if vim.fn.exists("$TMUX") then
    vim.opt.termguicolors = true
end

-- Set utf8 as standard encoding and en_US as the standard language
vim.opt.encoding = "utf8"

-- Use Unix as the standard file type
vim.opt.fileformats = {"unix", "dos", "mac"}
