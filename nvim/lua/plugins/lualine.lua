return {
  {
    "nvim-lualine/lualine.nvim",
    VeryLazy = true,
    dependencies = {
      "nvim-mini/mini.icons"
      -- "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()
      local colors = require("tokyonight.colors").setup()
      require('lualine').setup({
        options = {
          theme = {
            normal = {
              a = {bg = colors.bg, fg = colors.text, gui = 'bold'},
              b = {bg = colors.bg, fg = colors.text},
              c = {bg = colors.bg, fg = colors.text}
            },
            insert = {
              a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
            },
            visual = {
              a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
            },
          },
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          refresh = {
            statusline = 100,
          },
        },
      })
    end
  },
}
