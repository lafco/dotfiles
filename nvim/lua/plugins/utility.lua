local conf_path = vim.fn.stdpath "config" --[[@as string]]
return {
  {
    'Bekaboo/dropbar.nvim',
  },
  { -- Show CSS Colors
    'brenoprata10/nvim-highlight-colors',
    config = function()
      require('nvim-highlight-colors').setup({})
    end
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },
  {
    name = "options",
    event = "VeryLazy",
    dir = conf_path,
    config = function()
      require("config.keymaps").general()
      require("config.keymaps").lsp()
    end,
  },
}
