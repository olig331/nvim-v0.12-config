local M = {}

function M.setup()
	require("blink.cmp").setup({
		keymap = {
			preset = "none",
			["<C-Space>"] = { "show", "hide" },
			["<Tab>"] = { "select_and_accept", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			-- ["<Down>"] = { "snippet_forward", "fallback" },
			-- ["<Up>"] = { "snippet_backward", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		completion = {
			trigger = {
				show_on_trigger_character = true,
				show_on_blocked_trigger_characters = { " ", "\n", "\t" },
				-- show_on_insert_on_trigger_character = true,
			},
			accept = { auto_brackets = { enabled = false } },
			list = { selection = { preselect = false, auto_insert = false } },
			menu = { auto_show = true },
			documentation = { auto_show = true, auto_show_delay_ms = 200 },
		},
		sources = { default = { "lsp", "path", "buffer", "snippets" } },
		cmdline = {
			keymap = {
				preset = "none",
				["<C-Space>"] = { "show", "hide" },
				["<Tab>"] = { "select_and_accept", "fallback" },
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
