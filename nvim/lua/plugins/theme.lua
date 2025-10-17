return {
  {
    "catppuccin/nvim",
    lazy = true,
    priority = 1000,
    -- enabled = false,
    name = "catppuccin",
    init = function()
      vim.cmd.colorscheme "catppuccin"
    end,
    opts = {
      term_colors = true,
    }
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    priority = 1000, -- Ensure it loads first
    enabled = false,
    name = "onedark",
    init = function()
      vim.cmd.colorscheme "onedark"
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000, -- Ensure it loads first
    enabled = false,
    name = "gruvbox",
    init = function()
      vim.cmd.colorscheme "gruvbox"
    end,
    opts = {
      term_colors = true,
    }
  }
}
