return {
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			---@diagnostic disable-next-line: missing-fields
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
					-- blink.cmp
					-- hl.BlinkCmpMenuSelection = { fg = colors.base, bg = colors.db_dark }
					-- hl.BlinkCmpMenuBorder = { fg = colors.base }
					-- hl.BlinkCmpDocBorder = { fg = colors.base }
					-- hl.BlinkCmpSignatureHelpBorder = { fg = colors.yellow }
				end,
			})
			vim.cmd.colorscheme("tokyonight-moon")
		end,
	},
}
