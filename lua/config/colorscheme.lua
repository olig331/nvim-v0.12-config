local M = {}

local function neutralise_csharp_string_tokens()
	for _, group in ipairs({ "@lsp.type.string.cs", "@lsp.type.string" }) do
		vim.api.nvim_set_hl(0, group, {})
	end
end

function M.setup()
	vim.cmd.colorscheme("tokyohabamax")
	neutralise_csharp_string_tokens()

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("user_csharp_sql_hl", { clear = true }),
		callback = neutralise_csharp_string_tokens,
	})
end

return M
