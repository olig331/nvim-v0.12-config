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
	map("n", "<leader>W", "<cmd>noautocmd write<CR>", { desc = "Write without formatting" })
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
	-- map("n", "<leader>e", function()
	-- 	require("oil").open_float()
	-- end, { desc = "Open Oil (float)" })

	local fyler_root_path
	local fyler_instance
	local fyler_cursor_line
	map("n", "<leader>e", function()
		local finder = require("fyler.finder")
		if fyler_instance then
			if type(fyler_instance.win_id) == "number" and vim.api.nvim_win_is_valid(fyler_instance.win_id) then
				local cursor = vim.api.nvim_win_get_cursor(fyler_instance.win_id)
				fyler_cursor_line = cursor[1]
				vim.api.nvim_win_hide(fyler_instance.win_id)
			else
				fyler_instance:open()
				local function restore_cursor()
					if type(fyler_instance.win_id) ~= "number" or not vim.api.nvim_win_is_valid(fyler_instance.win_id) then
						return
					end
					if fyler_instance._is_refreshing then
						vim.defer_fn(restore_cursor, 10)
						return
					end
					local line_count = vim.api.nvim_buf_line_count(fyler_instance.buf_id)
					local line = math.min(fyler_cursor_line or 1, line_count)
					vim.api.nvim_win_set_cursor(fyler_instance.win_id, { line, 0 })
				end
				vim.defer_fn(restore_cursor, 10)
			end
			return
		end

		local path = fyler_root_path
		if not path then
			path = vim.api.nvim_buf_get_name(0)
			if path == "" or vim.fn.filereadable(path) == 0 then
				path = vim.fn.getcwd()
			elseif vim.fn.isdirectory(path) == 0 then
				path = vim.fs.dirname(path)
			end
			fyler_root_path = path
		end
		fyler_instance = finder.instance_get(nil, {
			kind = "split_left_most",
			root_path = path,
		})
		fyler_instance:open()
	end, { desc = "Fyler.nvim - Open at current level" })

	map("n", "<leader>E", function()
		local root = vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
		require("fyler").open({ kind = "split_left_most", root_path = root })
	end, { desc = "Fyler.nvim - Open at project root" })

	map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
	map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
	map("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

	map("n", "<leader>p", "_dP", { desc = "Paste Without Yank" })
	map("x", "<leader>p", [["_dP]], { desc = "Paste over selection without yanking replaced text" })

	map("n", "L", ":bnext<CR>", { desc = "Next buffer", noremap = true })
	map("n", "H", ":bprevious<CR>", { desc = "Previous buffer", noremap = true })
	vim.keymap.set("n", "<leader>bd", function()
		require("config.bufdelete").delete_current_keep_window()
	end, { desc = "Delete buffer (keep split)" })
	map("n", "<leader>bD", ':%bdelete|edit #|normal ` "<CR>', { desc = "Delete All but the current buffer" })

	map("n", "<leader>sv", ":split<CR>", { desc = "Horizontal Split" })
	map("n", "<PageUp>", "<cmd>vertical resize +5<CR>", { desc = "Increase pane width" })
	map("n", "<PageDown>", "<cmd>vertical resize -5<CR>", { desc = "Decrease pane width" })

	map("n", "<M-j>", ":m .+1<CR>==", { desc = "Move line down" })
	map("n", "<M-k>", ":m .-2<CR>==", { desc = "Move line up" })
	map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
	map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

	map("v", "<", "<gv", { desc = "Indent left and reselect" })
	map("v", ">", ">gv", { desc = "Indent right and reselect" })

	map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

	map("n", "<leader>wd", function()
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
	map("n", "<leader>f/", ":QFGrep ")
end

return M
