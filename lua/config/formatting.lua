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
			json = { "fixjson" },
			jsonc = { "fixjson" },
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
			cs = { "csharpier", lsp_format = "last" },
			dart = { "dart_format" },
		},
		format_after_save = function(bufnr)
			if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
				return
			end
			if vim.api.nvim_buf_get_name(bufnr) == "" then
				return
			end
			return {
				timeout_ms = 3000,
				lsp_format = vim.bo[bufnr].filetype == "cs" and "last" or "never",
			}
		end,
	})
end

return M
