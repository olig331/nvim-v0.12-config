local M = {}

local function packadd(name)
	vim.cmd.packadd(name)
end

function M.setup()
	vim.pack.add({
		"https://github.com/neovim/nvim-lspconfig",
		"https://github.com/christoomey/vim-tmux-navigator",
		"https://github.com/creativenull/efmls-configs-nvim",
		"https://github.com/folke/which-key.nvim",
		"https://github.com/MagicDuck/grug-far.nvim",
		"https://github.com/windwp/nvim-ts-autotag",
		"https://github.com/vuki656/package-info.nvim",
		"https://github.com/stevearc/oil.nvim",
		"https://www.github.com/echasnovski/mini.nvim",
		"https://github.com/tpope/vim-fugitive",
		{
			src = "https://github.com/mrcjkb/rustaceanvim",
			version = vim.version.range("^9"),
		},
		{
			src = "https://github.com/nvim-treesitter/nvim-treesitter",
			branch = "main",
			build = ":TSUpdate",
		},
		{
			src = "https://github.com/saghen/blink.cmp",
			version = vim.version.range("1.*"),
		},
	})

	packadd("nvim-treesitter")
	packadd("blink.cmp")
	packadd("efmls-configs-nvim")
	packadd("oil.nvim")
	packadd("nvim.undotree")
end
return M
