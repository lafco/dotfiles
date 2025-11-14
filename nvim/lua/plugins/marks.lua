return {
  {
    'fnune/recall.nvim',
    lazy = true,
    config = function()
      local map = require('utils').map
      require('recall').setup({
        sign = "",
        sign_highlight = "@comment.note",

        telescope = {
          autoload = true,
          mappings = {
            unmark_selected_entry = {
              normal = "x",
              insert = "<C-x>",
            },
          },
        },

        wshada = vim.fn.has("nvim-0.10") == 0,
      })
      map("n", "<leader>mm", ":RecallToggle<CR>", { noremap = true, silent = true })
      map("n", "<leader>mn", ":RecallNext<CR>", { noremap = true, silent = true })
      map("n", "<leader>mp", ":RecallPrevious<CR>", { noremap = true, silent = true })
      map("n", "<leader>mc", ":RecallClear<CR>", { noremap = true, silent = true })
      map("n", "<leader>mf", ":Telescope recall<CR>", { noremap = true, silent = true })
    end
  }
}
