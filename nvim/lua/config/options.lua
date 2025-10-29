-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Add any additional options here
vim.opt.statusline = "%#Normal#%="
vim.opt.cmdheight = 0

-- Neovide
if vim.g.neovide then
  vim.g.neovide_padding_top = 25
  vim.g.neovide_padding_bottom = 25
  vim.g.neovide_padding_right = 25
  vim.g.neovide_padding_left = 25
  vim.g.neovide_cursor_animation_length = 0.08
  vim.g.neovide_cursor_trail_size = 0.4
  vim.keymap.set({ "n", "v" }, "<A-=>", ":lua set.neovide_scale_factor = set.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<A-->", ":lua set.neovide_scale_factor = set.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<A-0>", ":lua set.neovide_scale_factor = 1<CR>")
end
