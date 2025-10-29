return {
  "nvim-mini/mini.nvim",
  name = "mini",
  version = false,
  config = function()
    require("mini.sessions").setup({})
    require("mini.move").setup({
      mappins = {
        left = "<A-h>",
        right = "<A-l>",
        down = "<A-j>",
        up = "<A-k>",
        line_left = "<A-h>",
        line_right = "<A-l>",
        line_down = "<A-j>",
        line_up = "<A-k>",
      },
    })
  end,
}
