-- OPTIONS
local set = vim.opt

--line nums
set.relativenumber = true
set.number = true

-- indentation and tabs
set.tabstop = 2
set.shiftwidth = 2
set.autoindent = true
set.expandtab = true

-- search settings
set.ignorecase = true
set.smartcase = true

-- appearance
set.termguicolors = true
set.background = "dark"
set.signcolumn = "yes"
set.winborder = "rounded"
set.statusline = "%#Normal#%="
set.cmdheight = 0

-- cursor line
set.cursorline = true

-- 100th column
-- set.colorcolumn = "100"

-- clipboard
set.clipboard:append("unnamedplus")

-- backspace
set.backspace = "indent,eol,start"

-- split windows
set.splitbelow = true
set.splitright = true

-- dw/diw/ciw works on full-word
set.iskeyword:append("-")

-- keep cursor at least 8 rows from top/bot
set.scrolloff = 8

-- undo dir settings
set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

-- incremental search
set.incsearch = true

-- faster cursor hold
set.updatetime = 50

-- Misc
set.completeopt = { "menuone", "noselect", "noinsert" }
set.wildmenu = true
set.pumheight = 10

-- Neovide
if vim.g.neovide then
    vim.g.neovide_padding_top = 25
    vim.g.neovide_padding_bottom = 25
    vim.g.neovide_padding_right = 25
    vim.g.neovide_padding_left = 25
    vim.g.neovide_cursor_animation_length = 0.09
    vim.g.neovide_cursor_trail_size = 0.4
    vim.g.guifont = "Jetbrains Mono:h8"
    vim.keymap.set({ "n", "v" }, "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end
