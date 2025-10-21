local function map(mode, keys, action, desc)
	desc = desc or ""
	local opts = { noremap = true, silent = true, desc = desc }
	vim.keymap.set(mode, keys, action, opts)
end

local M = {}
M.map = map

M.general = function()
  -- movement
  map("n", "<S-h>", "<Home>")
  map("n", "<S-l>", "<End>")
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
	-- Quickfix list
	map("n", "<A-n>", "<cmd>cnext<CR>")
	map("n", "<A-p>", "<cmd>cprev<CR>")
end

M.mini = function()
	local miniextra = require("mini.extra")
	local minivisits = require("mini.visits")
	local minisession = require("mini.sessions")

	-- Visits
	map("n", "<A-z>", function() miniextra.pickers.visit_paths({ filter = "marked" }) end, "Open visits")
	map("n", "<A-a>", function() minivisits.add_label("marked") end, "Add file to visits")
	map("n", "<A-r>", function() minivisits.remove_label("marked") end, "Remove file from visits")

	-- Session management
	map("n", "<leader>ws", function() minisession.write(vim.fn.input("Session name: ")) end, "Save")
	map("n", "<leader>wr", function() minisession.select("read") end, "Read")
	map("n", "<leader>ww", function() minisession.write() end, "Write current")
	map("n", "<leader>wd", function() minisession.select("delete") end, "Delete")
end

M.snacks = function()
	local Snacks = require("snacks")
	-- Explorer
	map("n", "<leader>e", function() Snacks.explorer() end, "File Explorer")

	-- find
	map("n", "<leader>fb", function() Snacks.picker.buffers() end, "Buffers")
	map("n", "<leader>ff", function() Snacks.picker.files() end, "Files")
	map("n", "<leader>fg", function() Snacks.picker.git_files() end, "Git Files")
	map("n", "<leader>fr", function() Snacks.picker.recent() end, "Recent")
	map("n", "<leader>fs", function() Snacks.picker.smart() end, "Smart Files")
	map("n", "<leader>fp", function() Snacks.picker.projects() end, "Projects")

	-- git
	map("n", "<leader>gb", function() Snacks.picker.git_branches() end, "Git Branches")
	map("n", "<leader>gl", function() Snacks.picker.git_log() end, "Git Log")
	map("n", "<leader>gL", function() Snacks.picker.git_log_line() end, "Git Log Line")
	map("n", "<leader>gs", function() Snacks.picker.git_status() end, "Git Status")
	map("n", "<leader>gS", function() Snacks.picker.git_stash() end, "Git Stash")
	map("n", "<leader>gd", function() Snacks.picker.git_diff() end, "Git Diff (Hunks)")
	map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, "Git Log File")
	map({ "n", "t" }, "<leader>gg", function() Snacks.lazygit() end, "Lazygit")

	-- Grep
	map("n", "<leader>sb", function() Snacks.picker.grep_buffers() end, "Grep Open Buffers")
	map("n", "<leader>sg", function() Snacks.picker.grep() end, "Grep")
	map({"n", "x"}, "<leader>sw", function() Snacks.picker.grep_word() end, "Visual selection or word")

	-- search
	map("n", "<leader>s/", function() Snacks.picker.registers() end, "Registers")
	map("n", "<leader>sm", function() Snacks.picker.marks() end, "Marks")
	map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, "Diagnostics")
	map("n", "<leader>sc", function() Snacks.picker.command_history() end, "Command History")
	map("n", "<leader>q", function() Snacks.picker.qflist() end, "Quickfix List")
	map("n", "<leader>sr", function() Snacks.picker.resume() end, "Resume search")

	-- misc
	map({ "n", "t" }, "<leader>p", function() Snacks.scratch() end, "Scratch pad")
	map({ "n", "t" }, "<A-t>", function() Snacks.terminal() end, "Toggle terminal buffer")
	map("n", "<leader>oc", function() Snacks.picker.colorschemes() end, "Colorschemes")
	map("n", "<leader>os", function() Snacks.toggle.option("spell", { name = "Spelling" }) end, "Spelling")
	map("n", "<leader>ow", function() Snacks.toggle.option("wrap", { name = "Wrap" }) end, "Wrap")
	map("n", "<leader>on", function() Snacks.toggle.option("relativenumber", { name = "Relative Number" }) end, "Relative Number")
	map("n", "<leader>od", function() Snacks.toggle.diagnostics() end, "Diagnostics")
	map("n", "<leader>ol", function() Snacks.toggle.line_number() end, "Line Number")
	map("n", "<leader>oe", function() Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }) end, "Conceal Level")
	map("n", "<leader>oh", function() Snacks.toggle.inlay_hints() end, "Inlay Hints")
	map("n", "<leader>oi", function() Snacks.toggle.indent() end, "Indent")
	map("n", "<leader>oD", function() Snacks.toggle.dm() end, "Dim")
	map("n", "<leader>on", function() Snacks.notifier.hide() end, "Dismiss All Notifications")
	map("n", "<leader>oz", function() Snacks.zen() end, "Toggle Zen Mode")

  -- editor
  map({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, "Prev Reference")
  map({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, "Next Reference")
end

M.lsp = function()
	local Snacks = require("snacks")

	map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
	map("n", "gD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
	map("n", "gr", function() Snacks.picker.lsp_references() end, "References")
	map("n", "gi", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
	map("n", "gt", function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition")
	map("n", "<leader>ls", function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
	map("n", "<leader>lw", function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")
	map("n", "<leader>lr", function() vim.lsp.buf.rename() end, "Rename across files")
	map("n", "<leader>la", function() vim.lsp.buf.code_action() end, "Code actions")
	map("n", "<leader>lf", function() require("conform").format({ lsp_fallback = true }) end, "Format document")
end

return M
