-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("diffview").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local map = require("utils").map

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git [c]hange" })
				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git [c]hange" })

				-- visual mode
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [s]tage hunk" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [r]eset hunk" })

				-- normal mode
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[s]tage hunk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[r]eset hunk" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "[S]tage buffer" })
				map("n", "<leader>hu", gitsigns.stage_hunk, { desc = "[u]ndo stage hunk" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "[R]eset buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[p]review hunk" })
				map("n", "<leader>hb", gitsigns.blame_line, { desc = "[b]lame line" })
				map("n", "<leader>hd", gitsigns.diffthis, { desc = "[d]iff against index" })
				map("n", "<leader>hD", function()
					gitsigns.diffthis("@")
				end, { desc = "[D]iff against last commit" })

				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Git show blame line" })
				map("n", "<leader>td", gitsigns.preview_hunk_inline, { desc = "Git show deleted" })
			end,
		},
	},
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"sindrets/diffview.nvim",
		},
		config = true,
		opts = {
			graph_style = "unicode",
			notification_icon = "",
			signs = {
				item = { "", "" },
				section = { "", "" },
			},
			disable_commit_confirmation = true,
			integrations = {
				telescope = true,
				diffview = true,
			},
		},
	},
	{
		"aaronhallaert/advanced-git-search.nvim",
		cmd = { "AdvancedGitSearch" },
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
	},
}
