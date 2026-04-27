local M = {}

local function set_float_highlights()
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1a1a", fg = "#eeeeee" })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1a1a1a", fg = "#1f1f1f" })
	vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1a1a1a", fg = "#eeeeee" })
	vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2f334d", fg = "#eeeeee" })
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#1a1a1a" })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#595857" })
	vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1a1a1a", fg = "#eeeeee" })
	vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#1a1a1a", fg = "#1f1f1f" })
	vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#1a1a1a", fg = "#eeeeee" })
	vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#1a1a1a", fg = "#1f1f1f" })
	vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#eeeeee" })
	vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", {
		fg = "#F29C51",
		bold = true,
		underline = true,
	})
	vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { fg = "#bdbdbd" })
	vim.api.nvim_set_hl(0, "MsgArea", { bg = "#1a1a1a", fg = "#eeeeee" })
	vim.api.nvim_set_hl(0, "CmdLine", { bg = "#1a1a1a", fg = "#eeeeee" })
end

local function set_spell_highlights()
	local misspelled = { undercurl = true, sp = "#ff6b6b" }
	local style = { undercurl = true, sp = "#ff6b6b" }

	vim.api.nvim_set_hl(0, "SpellBad", misspelled)
	vim.api.nvim_set_hl(0, "SpellCap", style)
	vim.api.nvim_set_hl(0, "SpellLocal", style)
	vim.api.nvim_set_hl(0, "SpellRare", style)

	vim.api.nvim_set_hl(0, "Visual", { bg = "#595857" })
	vim.api.nvim_set_hl(0, "IncSearch", { bg = "#F29C51", fg = "#000000" })
end

function M.setup()
	require("mini.ai").setup({})
	require("mini.hipatterns").setup({
		highlighters = {
			hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
		},
	})
	require("mini.icons").setup({})
	require("mini.pairs").setup({})

	require("vim._core.ui2").enable({ enable = true })

	set_float_highlights()
	set_spell_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("user_float_highlights", { clear = true }),
		callback = function()
			set_float_highlights()
			set_spell_highlights()
		end,
	})
end

return M
