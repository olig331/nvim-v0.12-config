local M = {}

local function set_oil_highlights()
	vim.api.nvim_set_hl(0, "OilNormal", { bg = "#1f1f1f", fg = "#eeeeee" })
end

function M.setup()
	set_oil_highlights()

	require("oil").setup({
		default_file_explorer = true,
		delete_to_trash = false,
		skip_confirm_for_simple_edits = false,
		columns = {
			-- "permissions",
			-- "size",
		},
		view_options = {
			show_hidden = true,
			natural_order = true,
			is_always_hidden = function(name, _)
				return name == ".." or name == ".git"
			end,
		},
		float = {
			padding = 2,
			max_width = 90,
			max_height = 0,
			border = "rounded",
		},
		win_options = {
			wrap = false,
			signcolumn = "no",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = true,
			list = true,
			conceallevel = 3,
			concealcursor = "nvic",
			winhighlight = "Normal:OilNormal,NormalNC:OilNormal,NormalFloat:OilNormal",
		},
		keymaps = {
			["g?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<C-v>"] = { "actions.select", opts = { vertical = true } },
			["<C-V>"] = { "actions.select", opts = { horizontal = true } },
			["<C-t>"] = { "actions.select", opts = { tab = true } },
			["<C-p>"] = "actions.preview",
			["q"] = { "actions.close", mode = "n" },
			["<C-r>"] = "actions.refresh",
			["'"] = { "actions.parent", mode = "n" },
			["@"] = { "actions.open_cwd", mode = "n" },
			["`"] = { "actions.cd", mode = "n" },
			["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			["gs"] = { "actions.change_sort", mode = "n" },
			["gx"] = "actions.open_external",
			["g."] = { "actions.toggle_hidden", mode = "n" },
			["g\\"] = { "actions.toggle_trash", mode = "n" },
		},
		use_default_keymaps = false,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("user_oil_highlights", { clear = true }),
		callback = set_oil_highlights,
	})
end

return M
