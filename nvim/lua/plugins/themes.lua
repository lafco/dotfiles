return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				on_highlights = function(hl, colors)
					hl.TelescopeSelectionCaret = { fg = colors.red }
					hl.TelescopePromptPrefix = { fg = colors.red, bg = colors.black }
					hl.TelescopeMatching = { fg = colors.red }
					hl.TelescopeSelection = { fg = colors.blue, bg = colors.bg_float }
					hl.TelescopePromptNormal = { bg = colors.black }
					hl.TelescopePromptBorder = { bg = colors.black, fg = colors.black }
					hl.TelescopePromptTitle = { fg = colors.text, bg = colors.red }
					hl.TelescopeResultsNormal = { bg = colors.bg_float }
					hl.TelescopeResultsBorder = { bg = colors.bg_float, fg = colors.bg_float }
					hl.TelescopeResultsTitle = { fg = colors.black, bg = colors.green }
					hl.TelescopePreviewNormal = { bg = colors.black }
					hl.TelescopePreviewBorder = { bg = colors.black, fg = colors.black }
					hl.TelescopePreviewTitle = { fg = colors.black, bg = colors.hint }
				end,
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				no_italic = true,
				no_underline = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					diffview = true,
					neogit = true,
					dap = true,
					dap_ui = true,
					which_key = true,
				},
				custom_highlights = function(colors)
					return {
						-- Visual = { fg = colors.mantle, bg = colors.red },
						TelescopeSelectionCaret = { fg = colors.red, bg = colors.mantle },
						TelescopePromptPrefix = { fg = colors.red, bg = colors.crust },
						TelescopeMatching = { fg = colors.red },
						TelescopeSelection = { fg = colors.blue, bg = colors.mantle },
						TelescopePromptNormal = { bg = colors.crust },
						TelescopePromptBorder = { bg = colors.crust, fg = colors.crust },
						TelescopePromptTitle = { fg = colors.crust, bg = colors.red },
						TelescopeResultsNormal = { bg = colors.mantle },
						TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
						TelescopeResultsTitle = { fg = colors.crust, bg = colors.green },
						TelescopePreviewNormal = { bg = colors.crust },
						TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
						TelescopePreviewTitle = { fg = colors.crust, bg = colors.blue },
						-- https://cmp.saghen.dev/configuration/appearance.html
					}
				end,
			})
			-- Set default colorscheme - change this to switch between themes
			-- Options: "tokyonight-moon", "tokyonight-storm", "tokyonight-night", "tokyonight-day", "catppuccin"
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
