local function map(mode, keys, action, desc)
	desc = desc or ""
	local opts = { noremap = true, silent = true, desc = desc }
	vim.keymap.set(mode, keys, action, opts)
end

-- _G.Config.leader_group_clues = {
--   { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
--   { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
--   { mode = 'n', keys = '<Leader>f', desc = '+Find' },
--   { mode = 'n', keys = '<Leader>g', desc = '+Git' },
--   { mode = 'n', keys = '<Leader>l', desc = '+Language' },
--   { mode = 'n', keys = '<Leader>s', desc = '+Session' },
--   { mode = 'n', keys = '<Leader>v', desc = '+Visits' },
--   { mode = 'x', keys = '<Leader>g', desc = '+Git' },
--   { mode = 'x', keys = '<Leader>l', desc = '+Language' },
-- }

local M = {}
M.map = map

M.general = function()
	-- insert movement
	map("i", "<C-h>", "<Left>")
	map("i", "<C-l>", "<Right>")
	map("i", "<C-c>", "<esc>")
	map("i", "<C-q>", "<esc>")
	map("n", "<C-c>", "<cmd>noh<CR>")
	map("n", "<C-s>", "<cmd>update<CR>")
	-- Switching splits
	map("n", "<C-h>", "<C-w>h")
	map("n", "<C-j>", "<C-w>j")
	map("n", "<C-k>", "<C-w>k")
	map("n", "<C-l>", "<C-w>l")
	-- Switching splits (terminal)
	map("t", "<C-h>", "<C-\\><C-N><C-w>h")
	map("t", "<C-j>", "<C-\\><C-N><C-w>j")
	map("t", "<C-k>", "<C-\\><C-N><C-w>k")
	map("t", "<C-l>", "<C-\\><C-N><C-w>l")
	-- Buffer navigation
	map("n", "<Tab>", "<cmd>bnext<CR>")
	map("n", "<s-Tab>", "<cmd>bprev<CR>")
	-- Resize splits
	map("n", "<A-up>", ":resize +2<CR>")
	map("n", "<A-down>", ":resize -2<CR>")
	map("n", "<A-left>", ":vertical resize +2<CR>")
	map("n", "<A-right>", ":vertical resize -2<CR>")
	-- Resize splits (terminal)
	map("t", "<A-up>", "<C-\\><C-N>:resize +2<CR>")
	map("t", "<A-down>", "<C-\\><C-N>:resize -2<CR>")
	map("t", "<A-left>", "<C-\\><C-N>:vertical resize +2<CR>")
	map("t", "<A-right>", "<C-\\><C-N>:vertical resize -2<CR>")
end

M.mini = function()
  local minipick = require "mini.pick"
  local miniextra = require "mini.extra"
  local minivisits = require "mini.visits"
  local minidiff = require "mini.diff"
	local minisession = require "mini.sessions"
	local minibufremove = require "mini.bufremove"

  local builtin = minipick.builtin

	-- Find files and buffers
  map("n", "<leader>ff", function()
    builtin.files()
  end, "Find files")
  map("n", "<leader>fb", function()
    builtin.buffers()
  end, "Find buffers")
  map("n", "<leader>fr", function()
    builtin.resume()
  end, "Resume finding")
  map("n", "<leader>fg", function()
    builtin.grep_live()
  end, "Grep live")
	map("n", "<leader>fw", function()
    builtin.grep_pattern()
  end, "Grep pattern")

	-- Buffers
	map("n", "<leader>bd", function()
		minibufremove.delete()
	end, "Delete")
	map("n", "<leader>bD", function()
		minibufremove.delete(0, true)
	end, "Delete!")
	map("n", "<leader>bw", function()
		minibufremove.wipeout()
	end, "Wipeout")
	map("n", "<leader>bW", function()
		minibufremove.wipeout(0, true)
	end, "Wipeout!")

	-- Toggle minifiles, buffer remove, visits
	map("n", "<leader>e", function()
    local _ = require("mini.files").close() or require("mini.files").open()
  end, "Toggle minifiles")
  map("n", "<A-q>", function()
    miniextra.pickers.visit_paths { filter = "todo" }
  end, "Open visits")
  map("n", "<A-a>", function()
    minivisits.add_label "marked"
  end, "Add file to visits")
  map("n", "<A-r>", function()
    minivisits.remove_label("marked")
  end, "Remove file from visits")

	-- Git
  map("n", "<leader>gc", function()
    miniextra.pickers.git_commits()
  end, "Show git commits")
  map("n", "<leader>gh", function()
    miniextra.pickers.git_hunks()
  end, "Show git hunks")
  map("n", "<leader>gd", function()
    minidiff.toggle_overlay(0)
  end, "Toggle git diff")

	-- Session management
	map("n", "<leader>ss", function()
		minisession.write(vim.fn.input("Session name: "))
	end, "Save")
	map("n", "<leader>sr", function()
		minisession.select("read")
	end, "Read")
	map("n", "<leader>sw", function()
		minisession.write()
	end, "Write current")
	map("n", "<leader>sd", function()
		minisession.select("delete")
	end, "Delete")
end

M.snacks = function()
	local snacks = require("snacks")
	map({ "n" }, "<leader>o", function()
		snacks.scratch()
	end, "Scratch pad")
	map({ "n" }, "<leader>F", function()
		snacks.picker.pick("files")
	end, "Find files")
	map({ "n" }, "<leader>R", function()
		snacks.picker.pick("recent")
	end, "Find recent files")
	map({ "n", "t" }, "<A-t>", function()
		snacks.terminal()
	end, "Toggle terminal buffer")
end

M.lsp = function()
	local miniextra = require("mini.extra")

	-- Jump to the definition of the word under your cursor.
	--  This is where a variable was first declared, or where a function is defined, etc.
	--  To jump back, press <C-t>.
	map("n", "gd", function()
		miniextra.pickers.lsp({ scope = 'definition' })
	end, "Source definition")

	-- Find references for the word under your cursor.
	map("n", "gr", function()
		miniextra.pickers.lsp({ scope = 'references' })
	end, "Source references")

	-- Jump to the implementation of the word under your cursor.
	--  Useful when your language has ways of declaring types without an actual implementation.
	map("n", "gi", function()
		miniextra.pickers.lsp({ scope = 'implementation' })
	end, "Source implementation")

	-- Jump to the type of the word under your cursor.
	--  Useful when you're not sure what type a variable is and you want to see
	--  the definition of its *type*, not where it was *defined*.
	map("n", "gt", function()
		miniextra.pickers.lsp({ scope = 'type_definition' })
	end, "Source type definition")

	-- Fuzzy find all the symbols in your current document.
	--  Symbols are things like variables, functions, types, etc.
	map("n", "<leader>ls", function()
		miniextra.pickers.lsp({ scope = 'document_symbol' })
	end, "Buffer symbols")

	-- Fuzzy find all the symbols in your current workspace.
	--  Similar to document symbols, except searches over your entire project.
	map("n", "<leader>lw", function()
		miniextra.pickers.lsp({ scope = 'workspace_symbol' })
	end, "Workspace symbols")

	-- Rename the variable under your cursor.
	--  Most Language Servers support renaming across files, etc.
	map("n", "gr", function()
		vim.lsp.buf.rename()
	end, "Rename")

	-- Execute a code action, usually your cursor needs to be on top of an error
	-- or a suggestion from your LSP for this to activate.
	map("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, "Code action")

	-- Format current buffer
	map("n", "<leader>cf", function()
		require("conform").format({ lsp_fallback=true })
	end, "Format document")
end

return M
