local conf_path = vim.fn.stdpath "config" --[[@as string]]
return {
  { -- dropbar (breadcrumb like)
    'Bekaboo/dropbar.nvim',
  },
  { -- show CSS colors
    'brenoprata10/nvim-highlight-colors',
    config = function()
      require('nvim-highlight-colors').setup({})
    end
  },
  { -- persistent sessions
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {}
  },
  { -- better yank/paste
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    opts = {
      highlight = { timer = 150 },
    },
    keys = function()
      require('config.keymaps').yank()
    end,
  },
  { -- set general keymaps
    name = "options",
    event = "VeryLazy",
    dir = conf_path,
    config = function()
      require("config.keymaps").general()
      require("config.keymaps").lsp()
    end,
  },
}
