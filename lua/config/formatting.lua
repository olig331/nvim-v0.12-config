local M = {}

function M.setup()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			go = { "gofumpt" },
			javascript = { "eslint_d", "prettierd" },
			javascriptreact = { "eslint_d", "prettierd" },
			typescript = { "eslint_d", "prettierd" },
			typescriptreact = { "eslint_d", "prettierd" },
			json = { "eslint_d", "fixjson" },
			jsonc = { "eslint_d", "fixjson" },
			css = { "prettierd" },
			html = { "prettierd" },
			markdown = { "prettierd" },
			rust = { "rustfmt" },
		zig = { "zigfmt" },
			sh = { "shfmt" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			vue = { "eslint_d", "prettierd" },
			svelte = { "eslint_d", "prettierd" },
			cs = { "csharpier" },
		},
		formatters = {
			csharpier = {
				args = { "--fast", "--write-stdout" },
			},
		},
		-- Format async so the editor never blocks on slow formatters like eslint_d
		format_after_save = function(bufnr)
			if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
				return
			end
			if vim.api.nvim_buf_get_name(bufnr) == "" then
				return
			end
			return { timeout_ms = 3000, lsp_format = "never" }
		end,
	})
end

return M

