local M = {}

function M.setup()
	local flutter = vim.fn.exepath("flutter")
	if flutter == "" then
		vim.notify("Flutter executable was not found in PATH", vim.log.levels.WARN)
		flutter = "flutter"
	end

	require("flutter-tools").setup({
		flutter_path = flutter,
		fvm = false,
		lsp = {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
			settings = {
				showTodos = true,
				completeFunctionCalls = true,
				renameFilesWithClasses = "prompt",
			},
		},
		widget_guides = {
			enabled = true,
		},
		closing_tags = {
			enabled = true,
		},
	})
end

return M
