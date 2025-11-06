local wezterm = require 'wezterm'
local commands = require 'commands'

local config = wezterm.config_builder()

-- Font settings
config.font_size = 11
config.line_height = 1
config.font = wezterm.font_with_fallback {
  { family = 'Jetbrains Mono' },
  { family = 'Symbols Nerd Font Mono' },
}

-- Colors
config.color_scheme = 'Catppuccin Mocha'

-- Appearance
config.cursor_blink_rate = 0
-- config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 10,
  right = 10,
  top = 0,
  bottom = 5,
}

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true

return config
