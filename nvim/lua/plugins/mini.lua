-- lua/custom/plugins/mini.lua
return {
  "nvim-mini/mini.nvim",
  name = "mini",
  version = false,
  config = function()
    require("mini.move").setup({
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
    })
    require("mini.surround").setup({
      mappings = {
        add = 'ra',        -- Add surrounding in Normal and Visual modes
        delete = 'rd',     -- Delete surrounding
        find = 'rf',       -- Find surrounding (to the right)
        find_left = 'rF',  -- Find surrounding (to the left)
        highlight = 'rh',  -- Highlight surrounding
        replace = 'rr',    -- Replace surrounding
        suffix_last = 'p', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      }
    })
  end,
}
