local M = {}

local ensure_installed = {
	"vim",
	"vimdoc",
	"rust",
	"c",
	"go",
	"html",
	"css",
	"javascript",
	"jsx",
	"json",
	"lua",
	"markdown",
	"python",
	"toml",
	"typescript",
	"tsx",
	"vue",
	"svelte",
	"yaml",
	"c_sharp",
	"bash",
}

function M.setup()
	local treesitter = require("nvim-treesitter")
	local config = require("nvim-treesitter.config")

	treesitter.setup({})

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
		callback = function(args)
			local lang = vim.treesitter.language.get_lang(args.match)
			if lang and vim.tbl_contains(treesitter.get_installed(), lang) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

return M
