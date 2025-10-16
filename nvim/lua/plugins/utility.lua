local conf_path = vim.fn.stdpath "config" --[[@as string]]
return {
  { -- This helps with php/html for indentation
    'captbaritone/better-indent-support-for-php-with-html',
  },
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
    name = "options",
    event = "VeryLazy",
    dir = conf_path,
    config = function()
      require("config.keymaps").general()
      require("config.keymaps").lsp()
    end,
  },
}
