return {
  "andrewferrier/debugprint.nvim",
  dependencies = {
    "nvim-mini/mini.nvim",
    "nvim-telescope/telescope.nvim",
  },
  lazy = false,
  version = "*",
  config = function() 
    require('debugprint').setup()
  end
}
