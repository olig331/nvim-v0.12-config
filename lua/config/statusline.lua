local M = {}

local mode_names = {
	n = "N",
	no = "N",
	nov = "N",
	noV = "N",
	["no\22"] = "N",
	niI = "N",
	niR = "N",
	niV = "N",
	i = "I",
	ic = "I",
	ix = "I",
	v = "V",
	vs = "V",
	V = "VL",
	Vs = "VL",
	["\22"] = "VB",
	["\22s"] = "VB",
	c = "C",
	cv = "C",
	ce = "C",
	r = "R",
	rm = "R",
	["r?"] = "R",
	R = "R",
	Rc = "R",
	Rx = "R",
	s = "S",
	S = "SL",
	["\19"] = "SB",
	t = "T",
}

local function mode_label()
	return mode_names[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
end

local function filename()
	local path = vim.fn.expand("%:.")
	if path == "" then
		return "[No Name]"
	end
	return path
end

local function fugitive_status()
	local ok, branch = pcall(vim.fn.FugitiveStatusline)
	if not ok or branch == nil then
		return ""
	end

	branch = tostring(branch)
	if branch == "" then
		return ""
	end

	branch = vim.trim(branch)
	branch = branch:gsub("^%[(.*)%]$", "%1")
	return branch
end

local function diagnostics_count()
	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

	local parts = {}

	if errors > 0 then
		parts[#parts + 1] = "%#StatusLineError#E:" .. errors
	end

	if warns > 0 then
		parts[#parts + 1] = "%#StatusLineWarn#W:" .. warns
	end

	return table.concat(parts, " ")
end

local lsp_progress_msgs = {}

function M.set_lsp_progress(client_id, token, msg)
	lsp_progress_msgs[client_id .. ":" .. tostring(token)] = msg
end

function M.clear_lsp_progress(client_id, token)
	lsp_progress_msgs[client_id .. ":" .. tostring(token)] = nil
end

local function lsp_progress()
	for _, msg in pairs(lsp_progress_msgs) do
		if msg and msg ~= "" then
			local pct = msg:match("^(%d+)%%")
			if pct then
				return "%#StatusLineLspProgress#" .. pct .. "%%"
			end
			return "%#StatusLineLspProgress#" .. msg:sub(1, 40)
		end
	end

	if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
		return "%#StatusLineLspReady#✓"
	end

	return ""
end

local function set_highlights()
	local bg = "#121212"

	vim.api.nvim_set_hl(0, "StatusLine", { fg = "#dddddd", bg = bg })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#888888", bg = bg })

	vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#dddddd", bg = bg, bold = true })
	vim.api.nvim_set_hl(0, "StatusLineGit", { fg = "#dddddd", bg = bg })
	vim.api.nvim_set_hl(0, "StatusLinePath", { fg = "#dddddd", bg = bg })
	vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#f38ba8", bg = bg, bold = true })
	vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#f9e2af", bg = bg, bold = true })
	vim.api.nvim_set_hl(0, "StatusLinePos", { fg = "#dddddd", bg = bg })
	vim.api.nvim_set_hl(0, "StatusLineLspProgress", { fg = "#89b4fa", bg = bg, bold = true })
	vim.api.nvim_set_hl(0, "StatusLineLspReady", { fg = "#a6e3a1", bg = bg, bold = true })
end

function M.render()
	local left = {}

	left[#left + 1] = "%#StatusLineMode#["
	left[#left + 1] = mode_label()
	left[#left + 1] = "]"

	local git = fugitive_status()
	if git ~= "" then
		left[#left + 1] = " "
		left[#left + 1] = "%#StatusLineGit#"
		left[#left + 1] = git
	end

	left[#left + 1] = " "
	left[#left + 1] = "%#StatusLinePath#%<"
	left[#left + 1] = filename()

	local right = {}

	local diag = diagnostics_count()
	if diag ~= "" then
		right[#right + 1] = diag
	end

	right[#right + 1] = "%#StatusLinePos#%l,%c"

	local lsp = lsp_progress()
	if lsp ~= "" then
		right[#right + 1] = lsp
	end

	return table.concat(left, "") .. "%=" .. table.concat(right, " ") .. " "
end

function M.setup()
	set_highlights()

	-- Use one global statusline across splits.
	vim.o.laststatus = 3
	vim.o.statusline = "%!v:lua.require('config.statusline').render()"

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("user_statusline_colors", { clear = true }),
		callback = set_highlights,
	})

	vim.api.nvim_create_autocmd({
		"BufEnter",
		"WinEnter",
		"BufWritePost",
		"CursorMoved",
		"DiagnosticChanged",
		"LspAttach",
		"LspDetach",
		"LspProgress",
		"ModeChanged",
	}, {
		callback = function()
			vim.cmd("redrawstatus")
		end,
	})
end

return M
