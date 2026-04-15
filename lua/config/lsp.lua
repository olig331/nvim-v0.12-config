local M = {}

local function lua_library_paths()
	return vim.api.nvim_get_runtime_file("lua", true)
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	if not vim.b[bufnr].lsp_keymaps_set then
		vim.b[bufnr].lsp_keymaps_set = true

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto definition" }))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto declaration" }))
		vim.keymap.set(
			"n",
			"<leader>gd",
			vim.lsp.buf.definition,
			vim.tbl_extend("force", opts, { desc = "Goto definition" })
		)
		vim.keymap.set(
			"n",
			"<leader>gD",
			vim.lsp.buf.declaration,
			vim.tbl_extend("force", opts, { desc = "Goto declaration" })
		)

		vim.keymap.set("n", "<leader>gS", function()
			vim.cmd.vsplit()
			vim.lsp.buf.definition()
		end, vim.tbl_extend("force", opts, { desc = "Goto definition in vsplit" }))

		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
		vim.keymap.set(
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code action" })
		)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))

		vim.keymap.set("n", "<leader>D", function()
			vim.diagnostic.open_float({ scope = "line" })
		end, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))

		vim.keymap.set("n", "<leader>d", function()
			vim.diagnostic.open_float({ scope = "cursor" })
		end, vim.tbl_extend("force", opts, { desc = "Cursor diagnostics" }))

		vim.keymap.set("n", "<leader>nd", function()
			vim.diagnostic.jump({ count = 1 })
		end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

		vim.keymap.set("n", "<leader>pd", function()
			vim.diagnostic.jump({ count = -1 })
		end, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))

		vim.keymap.set(
			"n",
			"<leader>fd",
			vim.lsp.buf.definition,
			vim.tbl_extend("force", opts, { desc = "Definitions" })
		)
		vim.keymap.set(
			"n",
			"<leader>fr",
			vim.lsp.buf.references,
			vim.tbl_extend("force", opts, { desc = "References" })
		)
		vim.keymap.set(
			"n",
			"<leader>ft",
			vim.lsp.buf.type_definition,
			vim.tbl_extend("force", opts, { desc = "Type definitions" })
		)
		vim.keymap.set(
			"n",
			"gi",
			vim.lsp.buf.implementation,
			vim.tbl_extend("force", opts, { desc = "Implementations" })
		)
		vim.keymap.set(
			"n",
			"<leader>fs",
			vim.lsp.buf.document_symbol,
			vim.tbl_extend("force", opts, { desc = "Document symbols" })
		)
		vim.keymap.set(
			"n",
			"<leader>fw",
			vim.lsp.buf.workspace_symbol,
			vim.tbl_extend("force", opts, { desc = "Workspace symbols" })
		)
	end

	if client:supports_method("textDocument/codeAction") and not vim.b[bufnr].lsp_imports_keymap_set then
		vim.b[bufnr].lsp_imports_keymap_set = true
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
	end
end

function M.setup()
	local group = vim.api.nvim_create_augroup("user_lsp", { clear = true })

	vim.api.nvim_create_autocmd("LspAttach", { group = group, callback = lsp_on_attach })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "qf",
		callback = function()
			vim.opt_local.wrap = true
		end,
	})
	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		group = group,
		callback = function()
			local winid = vim.fn.getloclist(0, { winid = 0 }).winid
			if winid == 0 then
				return
			end
			local items = vim.diagnostic.toqflist(vim.diagnostic.get())
			vim.fn.setloclist(0, {}, "r", { title = "Diagnostics", items = items })
		end,
	})
	vim.keymap.set("n", "<leader>q", function()
		local winid = vim.fn.getloclist(0, { winid = 0 }).winid
		if winid ~= 0 then
			vim.cmd.lclose()
		else
			local items = vim.diagnostic.toqflist(vim.diagnostic.get())
			vim.fn.setloclist(0, {}, "r", { title = "Diagnostics", items = items })
			vim.cmd.lopen()
		end
	end, { desc = "Toggle diagnostic list" })
	-- vim.keymap.set("n", "<leader>q", function()
	-- 	vim.diagnostic.setloclist({ open = true })
	-- end, { desc = "Open diagnostic list" })
	vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

	local capabilities = require("blink.cmp").get_lsp_capabilities()
	capabilities.general = capabilities.general or {}
	capabilities.general.positionEncodings = { "utf-8" }
	vim.lsp.config["*"] = {
		capabilities = capabilities,
	}

	vim.lsp.config("lua_ls", {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = {
						"lua/?.lua",
						"lua/?/init.lua",
					},
				},
				workspace = {
					checkThirdParty = false,
					library = lua_library_paths(),
				},
			})
		end,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "require" },
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})

	vim.lsp.config("efm", {
		cmd = { "efm-langserver", "-logfile", "/tmp/efm.log", "-loglevel", "5" },
		filetypes = {
			"c",
			"cpp",
			"css",
			"go",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"python",
			"sh",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
		offset_encoding = "utf-8",
		init_options = { documentFormatting = true },
		settings = {
			languages = require("config.formatting").languages(),
		},
	})

	vim.lsp.config("pyright", {})
	vim.lsp.config("bashls", {})
	vim.lsp.config("vtsls", {
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
		settings = {
			typescript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = { completeFunctionCalls = false },
				inlayHints = {
					enumMemberValues = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					propertyDeclarationTypes = { enabled = true },
					variableTypes = { enabled = false },
				},
			},
			vtsls = {
				enableMoveToFileCodeAction = true,
				autoUseWorkspaceTsdk = true,
			},
		},
	})

	vim.lsp.config("gopls", {})
	vim.lsp.enable({ "lua_ls", "vimls", "vtsls", "eslint", "efm", "bashls", "gopls" })

	vim.api.nvim_create_user_command("LspLog", function()
		vim.cmd.edit(vim.lsp.get_log_path())
	end, { desc = "Open Neovim LSP log" })

	vim.api.nvim_create_user_command("LspRestart", function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			client.stop()
		end
		vim.defer_fn(function()
			vim.cmd("edit")
		end, 500)
	end, { desc = "Restart LSP clients for current buffer" })
end

return M
