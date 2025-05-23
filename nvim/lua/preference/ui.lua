-- UI & Editing Preferences for Neovim

-- Line Numbers
vim.opt.number = true

-- Indentation & Tabs
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smarttab = true -- Smart tab behavior
vim.opt.tabstop = 4 -- A tab is 4 spaces
vim.opt.shiftwidth = 2 -- Indent by 2 spaces
vim.opt.autoindent = true -- Auto indent new lines
vim.opt.smartindent = true -- Smart autoindenting

-- Line Wrapping & Text Width
vim.opt.wrap = true -- Wrap lines
vim.opt.linebreak = true -- Wrap at word boundaries
vim.opt.textwidth = 79 -- Linebreak at 79 chars
vim.opt.formatoptions:append("mM") -- Better CJK line wrapping

-- Cursor & Navigation
vim.opt.scrolloff = 7 -- Keep 7 lines above/below cursor
vim.opt.ruler = true -- Show cursor position
vim.opt.cmdheight = 1 -- Command bar height

-- Wildmenu & File Ignore
vim.opt.wildmenu = true
vim.opt.wildignore = { "*.o", "*~", "*.pyc" }
if vim.fn.has("win16") == 1 or vim.fn.has("win32") == 1 then
	vim.opt.wildignore:append({ ".git/*", ".hg/*", ".svn/*" })
else
	vim.opt.wildignore:append({ "*/.git/*", "*/.hg/*", "*/.svn/*", "*/.DS_Store" })
end

-- Buffer & Backspace Behavior
vim.opt.hidden = true -- Allow background buffers
vim.opt.backspace:append({ "eol", "start", "indent" })
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,h,l"

-- Search
vim.opt.ignorecase = true -- Ignore case in search
vim.opt.smartcase = true -- ...unless uppercase used

-- (Add more UI options below as needed)
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

-- Theme
vim.opt.background = "dark"
local status, result = pcall(vim.cmd, "colorscheme codedark")
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
--vim.cmd("language en_US.UTF-8")
vim.opt.encoding = "utf8"

-- Use Unix as the standard file type
vim.opt.fileformats = { "unix", "dos", "mac" }
