-- Initialize configuration dictionary
vim.g.fzf_vim = {}

-- Preview window is hidden by default. You can toggle it with ctrl-/.
vim.g.fzf_vim.preview_window = {"right,50%,<70(up,40%)", "ctrl-/"}

-- Jump to the existing window if possible
vim.g.fzf_vim.buffers_jump = 1

-- Customize the options used by 'git log'
vim.g.fzf_vim.commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

-- Command to generate tags file
vim.g.fzf_vim.tags_command = "ctags -R"

-- --expect expression for directly executing the command
vim.g.fzf_vim.commands_expect = "alt-enter,ctrl-x"

-- Hide status line of terminal buffer
vim.api.nvim_exec(
    [[
  autocmd! FileType fzf set laststatus=0 noshowmode noruler
  autocmd BufLeave <buffer> set laststatus=2 showmode ruler
]],
    true
)

-- Terminal ANSI colors
vim.g.terminal_ansi_colors = {
    "#4e4e4e",
    "#d68787",
    "#5f865f",
    "#d8af5f",
    "#85add4",
    "#d7afaf",
    "#87afaf",
    "#d0d0d0",
    "#626262",
    "#d75f87",
    "#87af87",
    "#ffd787",
    "#add4fb",
    "#ffafaf",
    "#87d7d7",
    "#e4e4e4"
}

-- Ag: Start ag in the specified directory e.g. :Agdir ~/foo
-- FIXME: optimize implementation
function ag_in(bang, ...)
    local dir = ...
    if not vim.fn.isdirectory(dir) then
        error("Not a valid directory: " .. dir)
    end
    -- Press `?' to enable preview window.
    vim.fn["fzf#vim#ag"](table.concat({...}, " "), vim.fn["fzf#vim#with_preview"]({dir = dir}, "right:50%", "?"), bang)
end

vim.cmd([[command! -bang -nargs=+ -complete=dir Agdir lua ag_in(<bang>0, <f-args>)]])
