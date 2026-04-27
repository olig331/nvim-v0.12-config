local M = {}

local tools = {
	"eslint_d",
	"prettierd",
	"stylua",
	"black",
	"gofumpt",
	"shfmt",
	"shellcheck",
	"fixjson",
	"clang-format",
	"golangci-lint",
	"zls",
	"angular-language-server",
	"csharpier",
}

function M.setup()
	require("mason").setup()
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			local registry = require("mason-registry")
			registry.refresh(function()
				for _, tool in ipairs(tools) do
					local ok, pkg = pcall(registry.get_package, tool)
					if ok and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end,
	})
end

return M
