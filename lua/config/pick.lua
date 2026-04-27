local M = {}

local function set_highlights()
	-- Make matched characters stand out clearly in the picker list.
	vim.api.nvim_set_hl(0, "MiniPickMatchRanges", {
		fg = "#F29C51",
		bold = true,
		underline = false,
	})

	vim.api.nvim_set_hl(0, "MiniPickPrompt", { fg = "#eeeeee", bg = "#1e2030" })
	vim.api.nvim_set_hl(0, "MiniPickPromptCaret", { fg = "#eeeeee", bg = "#1e2030" })
	vim.api.nvim_set_hl(0, "MiniPickPromptPrefix", { fg = "#eeeeee", bg = "#121212" })
end

local function format_diagnostic(item)
	local path = vim.api.nvim_buf_is_valid(item.bufnr) and vim.api.nvim_buf_get_name(item.bufnr) or ""
	if path == "" then
		path = "[No Name]"
	else
		path = vim.fn.fnamemodify(path, ":.")
	end

	local severity = vim.diagnostic.severity[item.severity] or "INFO"
	local message = item.message:gsub("%s+", " ")
	return string.format("%s:%d:%d [%s] %s", path, item.lnum + 1, item.col + 1, severity, message)
end

local function jump_to_diagnostic(item)
	if not item then
		return
	end

	local path = vim.api.nvim_buf_get_name(item.bufnr)
	if path ~= "" then
		vim.cmd.edit(vim.fn.fnameescape(path))
	end

	vim.api.nvim_win_set_cursor(0, { item.lnum + 1, item.col })
end

function M.setup()
	local pick = require("mini.pick")

	pick.setup({
		source = {
			show = function(buf_id, items, query, opts)
				-- Default rendering (fuzzy match positions)
				pick.default_show(buf_id, items, query, opts)

				-- Also highlight every literal occurrence of the query in each line
				local query_str = table.concat(query):lower()
				if #query_str == 0 then
					return
				end

				local ns = vim.api.nvim_create_namespace("user_pick_all_matches")
				vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)

				for lnum, line in ipairs(vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)) do
					local low = line:lower()
					local start = 1
					while true do
						local s, e = low:find(query_str, start, true)
						if not s then
							break
						end
						vim.api.nvim_buf_add_highlight(buf_id, ns, "MiniPickMatchRanges", lnum - 1, s - 1, e)
						start = e + 1
					end
				end
			end,
		},
	})
	set_highlights()

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("user_pick_highlights", { clear = true }),
		callback = set_highlights,
	})
end

function M.diagnostics(scope)
	local items

	if scope == "all" then
		items = vim.diagnostic.get(nil)
	else
		items = vim.diagnostic.get(0)
	end

	require("mini.pick").ui_select(items, {
		prompt = scope == "all" and "Workspace diagnostics" or "Buffer diagnostics",
		format_item = format_diagnostic,
	}, jump_to_diagnostic)
end

return M
