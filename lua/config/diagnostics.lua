local M = {}

local diagnostic_signs = {
	Error = "E",
	Warn = "W",
	Hint = "H",
	Info = "I",
}

function M.setup()
	vim.diagnostic.config({
		virtual_text = { prefix = "~", spacing = 4 },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
				[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
				[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
				[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
			},
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "none",
			source = true,
			header = "",
			prefix = "",
			focusable = true,
			style = "minimal",
		},
	})
end

return M
