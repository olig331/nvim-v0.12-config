local M = {}

function M.setup()
	local opt = vim.opt

	-- Editing behavior.
	vim.o.mouse = "a"
	vim.o.scrolloff = 15
	vim.o.sidescrolloff = 10
	opt.wrap = false
	opt.cursorline = true
	opt.number = true
	opt.relativenumber = true
	opt.title = true
	opt.confirm = true

	-- Window behavior.
	opt.splitright = true
	opt.splitbelow = true
	opt.splitkeep = "screen"
	opt.inccommand = "split"

	-- Spelling and clipboard.
	opt.spell = true
	opt.spelllang = "en"
	opt.spelloptions:append("camel")
	opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
	opt.clipboard = "unnamedplus"

	opt.encoding = "utf-8"
	opt.fileencoding = "utf-8"

	-- Indentation.
	opt.tabstop = 4
	opt.shiftwidth = 4
	opt.softtabstop = 4
	opt.expandtab = true
	opt.smartindent = true
	opt.autoindent = true

	-- Search.
	opt.ignorecase = true
	opt.smartcase = true
	opt.hlsearch = true
	opt.incsearch = true

	-- UI.
	opt.termguicolors = true
	opt.signcolumn = "yes:1"
	opt.showmatch = true
	opt.matchtime = 2
	opt.cmdheight = 1
	opt.showmode = false
	opt.pumblend = 10
	opt.pumheight = 12
	opt.winblend = 0

	-- Files and timing.
	opt.backup = false
	opt.writebackup = false
	opt.swapfile = false
	opt.undofile = true
	opt.undolevels = 10000
	opt.updatetime = 300
	opt.timeout = true
	opt.timeoutlen = vim.g.vscode and 1000 or 300
	opt.autoread = true
	opt.path:append("**")
	opt.wildignore:append({ "*/node_modules/*", "*.venv/*", "*/.git/*", "*/target/*", "*/dist/*", "*/build/*" })

	-- Folding and grep.
	opt.smoothscroll = true
	opt.foldmethod = "expr"
	opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	opt.foldlevel = 99
	opt.grepprg = "rg --vimgrep"

	-- Completion and command-line UI.
	vim.o.complete = ".,o"
	vim.o.completeopt = "menuone,noinsert,noselect"
	vim.o.autocomplete = false
	vim.o.wildmode = "longest:full"
	vim.o.wildmenu = false
	vim.o.wildoptions = "pum"
end

return M
