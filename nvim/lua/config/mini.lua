local M = {}

M.move = {
  mappings = {
    left = "<A-h>",
    right = "<A-l>",
    down = "<A-j>",
    up = "<A-k>",
    line_left = "<A-h>",
    line_right = "<A-l>",
    line_down = "<A-j>",
    line_up = "<A-k>",
  },
}

M.visits = {
  store = {
    path = vim.fn.stdpath "cache" .. "mini-visits-index",
  },
}

local miniclue = require "mini.clue"
M.clue = {
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "i", keys = "<C-x>" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" },
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },
  window = {
    delay = 500
  },
  clues = {
    { mode = 'n', keys = '<Leader>f', desc = '+Find' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>l', desc = '+Language' },
    { mode = 'n', keys = '<Leader>w', desc = '+Workspaces' },
    { mode = 'n', keys = '<Leader>o', desc = '+Options' },
    { mode = 'n', keys = '<Leader>s', desc = '+Search' },
    { mode = 'x', keys = '<Leader>s', desc = '+Search' },
    { mode = 'x', keys = '<Leader>g', desc = '+Git' },
    { mode = 'x', keys = '<Leader>l', desc = '+Language' },
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
}

M.surround = {
  mappings = {
    add = 'sa',        -- Add surrounding in Normal and Visual modes
    delete = 'sd',     -- Delete surrounding
    find = 'sf',       -- Find surrounding (to the right)
    find_left = 'sF',  -- Find surrounding (to the left)
    highlight = 'sh',  -- Highlight surrounding
    replace = 'sr',    -- Replace surrounding
    suffix_last = 'p', -- Suffix to search with "prev" method
    suffix_next = 'n', -- Suffix to search with "next" method
  },
}

M.icons = {
  lsp = {
    ["function"] = { glyph = "󰡱", hl = "MiniIconsCyan" },
  },
}

M.extra = {}

return M
