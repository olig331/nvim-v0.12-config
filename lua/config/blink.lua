local M = {}

function M.setup()
	require("blink.cmp").setup({
		keymap = {
			preset = "none",
			["<C-Space>"] = { "show", "hide" },
			["<Tab>"] = { "accept", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			-- ["<Down>"] = { "snippet_forward", "fallback" },
			-- ["<Up>"] = { "snippet_backward", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		completion = { menu = { auto_show = true } },
		sources = { default = { "lsp", "path", "buffer", "snippets" } },
		cmdline = {
			keymap = {
				preset = "none",
				["<C-Space>"] = { "show", "hide" },
				["<Tab>"] = { "accept", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				-- ["<Down>"] = { "snippet_forward", "fallback" },
				-- ["<Up>"] = { "snippet_backward", "fallback" },
			},
			enabled = true,
			completion = {
				menu = {
					auto_show = true,
				},
			},
		},
		fuzzy = {
			implementation = "prefer_rust",
			prebuilt_binaries = { download = true },
		},
	})
end

return M
