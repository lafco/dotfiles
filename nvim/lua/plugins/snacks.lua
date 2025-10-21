return {
  "folke/snacks.nvim",
  name = "snacks",
  keys = function()
    require("config.keymaps").snacks()
  end,
  opts = {
    bigfile = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 2000,
    },
    picker = {
      enabled = true
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {}
    }
  },
}
