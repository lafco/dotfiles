-- lua/custom/plugins/mini.lua
return {
  "echasnovski/mini.nvim",
  name = "mini",
  version = false,
  keys = function()
    require("config.keymaps").mini()
  end,
  init = function()
    package.preload["nvim-web-devicons"] = function()
      package.loaded["nvim-web-devicons"] = {}
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  config = function()
    local mini_config = require("config.mini")
    local mini_modules = {
      "icons",
      "visits",
      "move",
      "clue",
      "surround",
      "extra"
    }
    for _, module in ipairs(mini_modules) do
      require("mini." .. module).setup(mini_config[module])
    end
  end,
}
