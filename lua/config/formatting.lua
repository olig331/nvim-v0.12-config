local M = {}

local format_patterns = {
	"*.lua",
	"*.py",
	"*.go",
	"*.js",
	"*.jsx",
	"*.ts",
	"*.tsx",
	"*.json",
	"*.css",
	"*.scss",
	"*.html",
	"*.rs",
	"*.sh",
	"*.bash",
	"*.zsh",
	"*.c",
	"*.cpp",
	"*.h",
	"*.hpp",
	"*.cs",
}

function M.languages()
	local stylua = require("efmls-configs.formatters.stylua")
	local black = require("efmls-configs.formatters.black")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d = require("efmls-configs.linters.eslint_d")
	local eslint_d_fmt = require("efmls-configs.formatters.eslint_d")
	local fixjson = require("efmls-configs.formatters.fixjson")
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")
	local clangfmt = require("efmls-configs.formatters.clang_format")
	local go_revive = require("efmls-configs.linters.go_revive")
	local gofumpt = require("efmls-configs.formatters.gofumpt")
	local rustfmt = require("efmls-configs.formatters.rustfmt")

	return {
		c = { clangfmt },
		go = { gofumpt, go_revive },
		cpp = { clangfmt },
		css = { prettier_d },
		html = { prettier_d },
		javascript = { eslint_d, eslint_d_fmt, prettier_d },
		javascriptreact = { eslint_d, eslint_d_fmt, prettier_d },
		json = { eslint_d, eslint_d_fmt, fixjson },
		jsonc = { eslint_d, eslint_d_fmt, fixjson },
		lua = { stylua },
		markdown = { prettier_d },
		python = { black },
		rust = { rustfmt },
		sh = { shellcheck, shfmt },
		typescript = { eslint_d, eslint_d_fmt, prettier_d },
		typescriptreact = { eslint_d, eslint_d_fmt, prettier_d },
		vue = { eslint_d, eslint_d_fmt, prettier_d },
		svelte = { eslint_d, eslint_d_fmt, prettier_d },
	}
end

function M.setup()
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("user_format_on_save", { clear = true }),
		pattern = format_patterns,
		callback = function(args)
			if vim.bo[args.buf].buftype ~= "" or not vim.bo[args.buf].modifiable then
				return
			end

			if vim.api.nvim_buf_get_name(args.buf) == "" then
				return
			end

			-- Run ESLint fix-all (import order, type imports, etc.) before formatting
			local has_efm = false
			for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
				if client.name == "efm" then
					has_efm = true
					break
				end
			end

			pcall(vim.lsp.buf.format, {
				bufnr = args.buf,
				timeout_ms = 3000,
				filter = function(client)
					if has_efm then
						return client.name == "efm"
					end
					return client:supports_method("textDocument/formatting")
				end,
			})
		end,
	})
end

return M
