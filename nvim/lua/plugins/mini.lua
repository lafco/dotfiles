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
  event = function()
    if vim.fn.argc() == 0 then
      return "VimEnter"
    else
      return { "InsertEnter", "LspAttach" }
    end
  end,
  config = function()
    local mini_config = require("config.mini")
    local mini_modules = {
      "icons",
      "pick",
      "extra",
      "visits",
      "files",
      "bufremove",
      "move",
      "indentscope",
      "comment",
      "pairs",
      "diff",
      "clue",
      "notify",
      "surround",
    }
    for _, module in ipairs(mini_modules) do
      require("mini." .. module).setup(mini_config[module])
    end
  end,
}
