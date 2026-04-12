require("mini.surround").setup({
	custom_surroundings = {
		t = {
			input = { "<([%w-]-)%f[^<%w-][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
		},
	},
	highlight_duration = 2000,
	mappings = {
		add = "<leader>sa",
		delete = "<leader>sd",
		find = "<leader>sf",
		find_left = "<leader>sF",
		highlight = "<leader>sh",
		replace = "<leader>sr",
		suffix_last = "l",
		suffix_next = "n",
	},
	n_lines = 20,
	respect_selection_type = false,
	search_method = "cover",
	silent = false,
})
