local M = {}

function M.setup()
	require("config.globals").setup()
	require("config.options").setup()
	require("config.plugins").setup()
	require("config.mason").setup()

	require("config.colorscheme").setup()
	require("config.ui").setup()
	require("config.surround")
	require("config.oil").setup()
	require("config.pick").setup()
	require("config.fuzzy_find").setup()
	require("config.keymaps").setup()
	require("config.autocmds").setup()
	require("config.blink").setup()
	require("config.treesitter").setup()
	require("config.tags")
	require("config.diagnostics").setup()
	require("config.lsp").setup()
	require("config.formatting").setup()
	require("config.lint").setup()
	require("config.statusline").setup()
	require("config.package-info").setup()
	require("config.clue").setup()
	require("config.buforder").setup()
end

return M
