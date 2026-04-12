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
	require("mini.pick").setup({})
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
