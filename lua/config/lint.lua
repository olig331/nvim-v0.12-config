local M = {}

function M.setup()
	local lint = require("lint")

	lint.linters_by_ft = {
		go = { "golangcilint" },
		sh = { "shellcheck" },
	}

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
		callback = function()
			lint.try_lint()
		end,
	})
end

return M
