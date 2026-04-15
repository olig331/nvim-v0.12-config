local M = {}

function M.setup()
	local map = vim.keymap.set
	local pick = require("mini.pick")
	local pick_config = require("config.pick")

	map("n", "<Esc>", "<cmd>nohlsearch<CR>")

	vim.api.nvim_set_keymap("n", "<S-Right>", "<End>", {})
	vim.api.nvim_set_keymap("v", "<S-Right>", "<End>", {})
	vim.api.nvim_set_keymap("i", "<S-Right>", "<End>", {})
	vim.api.nvim_set_keymap("i", "<S-Left>", "<C-o>^", { noremap = true })
	vim.api.nvim_set_keymap("n", "<S-Left>", "^", {})
	vim.api.nvim_set_keymap("v", "<S-Left>", "^", {})

	vim.api.nvim_set_keymap("n", "<M-Right>", "<End>", {})
	vim.api.nvim_set_keymap("v", "<M-Right>", "<End>", {})
	vim.api.nvim_set_keymap("i", "<M-Right>", "<End>", {})
	vim.api.nvim_set_keymap("i", "<M-Left>", "<C-o>^", { noremap = true })
	vim.api.nvim_set_keymap("n", "<M-Left>", "^", {})
	vim.api.nvim_set_keymap("v", "<M-Left>", "^", {})

	vim.api.nvim_set_keymap("n", "<leader>gg", ":Git ", {})

	map("n", "<leader>us", function()
		vim.wo.spell = not vim.wo.spell
	end, { desc = "Toggle spell" })
	map("n", "<leader>uw", function()
		vim.wo.wrap = not vim.wo.wrap
	end, { desc = "Toggle word wrap" })

	vim.api.nvim_set_keymap(
		"n",
		"\\\\",
		":%y+<CR>",
		{ noremap = true, silent = true, desc = "Yank entire file to clipboard" }
	)

	map("n", "<leader>ut", ":Undotree<CR>", { desc = "Open Undo Tree" })
	map({ "n", "i", "v" }, "<S-CR>", "<Nop>")
	map({ "n", "i", "v" }, "<S-Down>", "<Nop>")
	map({ "n", "i", "v" }, "<S-Up>", "<Nop>")
	map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
	map("i", "<Tab>", function()
		if vim.fn.pumvisible() == 1 then
			return "<C-y>"
		end
		return "<Tab>"
	end, { expr = true, silent = true })

	-- Keep existing navigation behavior while defining all picker mappings in one place.
	map("n", "<leader>ff", ":find ", { desc = "Find file" })
	map("n", "<leader><leader>", ":Pick files<CR>", { desc = "Find file" })
	map("n", "<leader>fg", pick.builtin.grep_live, { desc = "Pick Live Grep" })
	map("n", "<leader>/", pick.builtin.grep_live, { desc = "Pick Live Grep" })
	map("n", "gb", pick.builtin.buffers, { desc = "Pick Buffers" })
	map("n", "<leader>fh", pick.builtin.help, { desc = "Pick Help Tags" })
	map("n", "<leader>fx", function()
		pick_config.diagnostics("buffer")
	end, { desc = "Pick Diagnostics Buffer" })
	map("n", "<leader>fX", function()
		pick_config.diagnostics("all")
	end, { desc = "Pick Diagnostics Workspace" })

	map("n", "<leader>sR", function()
		local grug = require("grug-far")
		local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
		grug.open({
			transient = true,
			prefills = {
				filesFilter = ext and ext ~= "" and "*." .. ext or nil,
			},
		})
	end)

	map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	map("n", "<leader>e", function()
		require("oil").open_float()
	end, { desc = "Open Oil (float)" })

	map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
	map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
	map("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

	map("n", "<leader>p", '"_dP', { desc = "Paste Without Yank" })

	map("n", "L", ":bnext<CR>", { desc = "Next buffer", noremap = true })
	map("n", "H", ":bprevious<CR>", { desc = "Previous buffer", noremap = true })
	map("n", "<leader>bd", function()
		local buf = vim.api.nvim_get_current_buf()
		local bufs = vim.fn.getbufinfo({ buflisted = 1 })
		if #bufs > 1 then
			vim.cmd("bnext")
			if vim.api.nvim_get_current_buf() == buf then
				vim.cmd("bprevious")
			end
		end
		vim.api.nvim_buf_delete(buf, {})
	end, { desc = "Delete current buffer" })
	map("n", "<leader>bD", ':%bdelete|edit #|normal ` "<CR>', { desc = "Delete All but the current buffer" })

	map("n", "<leader>sv", ":split<CR>", { desc = "Horizontal Split" })

	map("n", "<M-j>", ":m .+1<CR>==", { desc = "Move line down" })
	map("n", "<M-k>", ":m .-2<CR>==", { desc = "Move line up" })
	map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
	map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

	map("v", "<", "<gv", { desc = "Indent left and reselect" })
	map("v", ">", ">gv", { desc = "Indent right and reselect" })

	map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

	map("n", "<leader>pa", function()
		local path = vim.fn.expand("%:p")
		vim.fn.setreg("+", path)
		print("file:", path)
	end, { desc = "Copy full file path" })

	map("n", "<leader>td", function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end, { desc = "Toggle diagnostics" })

	map("n", "<leader>mf", function()
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			local cfg = vim.api.nvim_win_get_config(win)
			if cfg.relative ~= "" then
				vim.api.nvim_set_current_win(win)
				return
			end
		end
	end, { desc = "Focus open float" })

	map("n", "<leader>a", function()
		local wins = vim.fn.getqflist({ winid = 0 }).winid
		if wins ~= 0 then
			vim.cmd("cclose")
		else
			vim.cmd("copen")
		end
	end, { desc = "Toggle quickfix list" })

	map("n", "]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
	end, { desc = "Next error" })

	map("n", "[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
	end, { desc = "Previous error" })

	vim.api.nvim_create_user_command("QFFiles", function(opts)
		local pattern = opts.args
		local files = vim.fn.systemlist('rg --files --iglob "*' .. pattern .. '*"')
		vim.fn.setqflist(vim.tbl_map(function(f)
			return { filename = f, lnum = 1 }
		end, files))
		vim.cmd("copen")
		vim.schedule(function()
			local win = vim.fn.getqflist({ winid = 0 }).winid
			if win ~= 0 then
				vim.fn.clearmatches(win)
				vim.fn.matchadd("Search", pattern, 10, -1, { window = win })
			end
		end)
	end, { nargs = 1 })

	vim.api.nvim_create_user_command("QFGrep", function(opts)
		local pattern = opts.args
		local lines = vim.fn.systemlist('rg --vimgrep "' .. pattern .. '"')
		local qflist = vim.tbl_map(function(line)
			local file, lnum, col, text = line:match("^(.+):(%d+):(%d+):(.+)$")
			return {
				filename = file,
				lnum = tonumber(lnum),
				col = tonumber(col),
				text = text,
			}
		end, lines)
		vim.fn.setqflist(qflist)
		vim.cmd("copen")
		vim.schedule(function()
			local win = vim.fn.getqflist({ winid = 0 }).winid
			if win ~= 0 then
				vim.fn.clearmatches(win)
				local hl_pattern = "\\v\\|[^|]+\\|[^|]*\\zs" .. vim.fn.escape(pattern, "\\/.*$^~[]")
				vim.fn.matchadd("Search", hl_pattern, 10, -1, { window = win })
			end
		end)
	end, { nargs = 1 })

	map("n", "<leader>fq", ":QFFiles ")
	map("n", "<leader>/q", ":QFGrep ")
end

return M
