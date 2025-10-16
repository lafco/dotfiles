local M = {}

M.pairs = {
  mappings = {
    ["<"] = { action = "closeopen", pair = "<>", neigh_pattern = "[^\\].", register = { cr = false } },
  },
}

M.files = {
  use_as_default_explorer = true,
  windows = {
    max_number = math.huge,
    preview = false,
    width_focus = 30,
    width_nofocus = 20,
    width_preview = 25,
  },
}

M.bufremove = {
  silent = true,
}

M.comment = {}

M.pick = {
  options = {
    use_cache = true,
  },
  window = {
    width = 0.2,
    height = 0.2,
  },
  mappings = {
    choose_marked = "<C-CR>"
  }
}

M.notify = {}

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

M.indentscope = {
  symbol = "┋",
}

-- M.ai = {}

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
    delay = 700
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
}

M.jump = {}

M.diff = {
  view = {
    style = "sign",
    signs = { add = " ", change = " ", delete = "" },
  },
}

M.surround = {
   mappings = {
    add = 'sa', -- Add surrounding in Normal and Visual modes
    delete = 'sd', -- Delete surrounding
    find = 'sf', -- Find surrounding (to the right)
    find_left = 'sF', -- Find surrounding (to the left)
    highlight = 'sh', -- Highlight surrounding
    replace = 'sr', -- Replace surrounding
    suffix_last = 'p', -- Suffix to search with "prev" method
    suffix_next = 'n', -- Suffix to search with "next" method
  },
}

M.icons = {
  lsp = {
    ["function"] = { glyph = "󰡱", hl = "MiniIconsCyan" },
  },
}

return M
