local M = {}

function M.setup()
	-- Core globals must be defined before plugins and mappings are initialized.
	vim.g.loaded_perl_provider = 0
	vim.g.loaded_ruby_provider = 0
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	vim.g.have_nerd_font = true
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	vim.g.netrw_banner = 0
end

return M
