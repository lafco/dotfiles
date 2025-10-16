return {
  "folke/snacks.nvim",
  name = "snacks",
  keys = function()
    require("config.keymaps").snacks()
  end,
  event = { "BufReadPost" },
  opts = {
    statuscolumn = {
      left = { "fold", "git" },
      right = { "mark", "sign" },
    },
    words = {
      enabled = true,
      debounce = 500,
    },
    notifier = {
      wo = {
        winblend = vim.g.winblend,
      },
    },
    indent = {
      scope = {
        treesitter = {
          enabled = true,
        },
      },
    },
  },
}
