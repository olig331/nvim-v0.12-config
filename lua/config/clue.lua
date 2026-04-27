local M = {}

function M.setup()
	local miniclue = require("mini.clue")
	miniclue.setup({
		window = {
			delay = 500,
			config = function(buf_id)
				local n = vim.api.nvim_buf_line_count(buf_id)
				local max_height = math.floor(vim.o.lines * 0.5)
				return {
					anchor = "SW",
					row = vim.o.lines - 2,
					col = 0,
					width = vim.o.columns,
					height = math.min(n, max_height),
				}
			end,
		},
		triggers = {
			-- Leader triggers
			{ mode = { "n", "x" }, keys = "<Leader>" },

			-- `[` and `]` keys
			{ mode = "n", keys = "[" },
			{ mode = "n", keys = "]" },

			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = { "n", "x" }, keys = "g" },

			-- Marks
			{ mode = { "n", "x" }, keys = "'" },
			{ mode = { "n", "x" }, keys = "`" },

			-- Registers
			{ mode = { "n", "x" }, keys = '"' },
			{ mode = { "i", "c" }, keys = "<C-r>" },

			-- Window commands
			{ mode = "n", keys = "<C-w>" },

			-- `z` key
			{ mode = { "n", "x" }, keys = "z" },
		},
		scroll_down = "<C-d>",
		scroll_up = "<C-u>",
		clues = {
			miniclue.gen_clues.square_brackets(),
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows(),
			miniclue.gen_clues.z(),
		},
	})
end

return M
