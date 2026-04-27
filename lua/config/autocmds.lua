local M = {}

local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

local last_tmux_lsp_progress = nil
local default_spell_path_blacklist = {
	"/node_modules/",
	"/target/",
	"/dist/",
	"/build/",
	"/.git/",
	"/.next/",
	"/coverage/",
	"/.turbo/",
}
local default_spell_filetype_blacklist = {
	checkhealth = true,
	help = true,
	lspinfo = true,
	qf = true,
}
local default_spell_buftype_blacklist = {
	nofile = true,
	prompt = true,
	quickfix = true,
	terminal = true,
}

local function should_enable_spell(bufnr)
	local bo = vim.bo[bufnr]

	if default_spell_buftype_blacklist[bo.buftype] then
		return false
	end

	local filetype_blacklist = vim.g.spell_filetype_blacklist or default_spell_filetype_blacklist
	if filetype_blacklist[bo.filetype] then
		return false
	end

	local path = vim.api.nvim_buf_get_name(bufnr)
	if path == "" then
		return true
	end

	path = vim.fs.normalize(path)
	for _, ignored in ipairs(vim.g.spell_path_blacklist or default_spell_path_blacklist) do
		if path:find(ignored, 1, true) then
			return false
		end
	end

	return true
end

local function update_spell(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.api.nvim_set_option_value("spell", should_enable_spell(bufnr), { scope = "local", win = 0 })
end

local function set_tmux_lsp_progress(value)
	if os.getenv("TMUX") == nil or last_tmux_lsp_progress == value then
		return
	end

	last_tmux_lsp_progress = value
	vim.system({ "tmux", "set-option", "-gq", "@lsp_progress", value })
	vim.system({ "tmux", "refresh-client", "-S" })
end

function M.setup()
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = augroup("highlight_yank"),
		callback = function()
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
		end,
	})

	vim.api.nvim_create_autocmd("VimResized", {
		group = augroup("resize_splits"),
		callback = function()
			local current_tab = vim.fn.tabpagenr()
			vim.cmd("tabdo wincmd =")
			vim.cmd("tabnext " .. current_tab)
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup("close_with_q"),
		pattern = {
			"help",
			"lspinfo",
			"location-list",
			"checkhealth",
			"qf",
			"grug-far",
		},
		callback = function(event)
			vim.keymap.set("n", "q", function()
				vim.api.nvim_win_close(0, false)
			end, { buffer = event.buf, silent = true })
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup("json_conceal"),
		pattern = { "json", "jsonc", "json5" },
		callback = function()
			vim.opt_local.conceallevel = 0
		end,
	})

	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup("env_filetype"),
		pattern = { "*.env", ".env.*" },
		callback = function()
			vim.opt_local.filetype = "sh"
		end,
	})

	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup("j2_filetype"),
		pattern = { "*.json.j2" },
		callback = function()
			vim.opt_local.filetype = "json"
		end,
	})

	vim.api.nvim_create_autocmd("LspProgress", {
		group = augroup("lsp_progress"),
		callback = function(ev)
			local value = ev.data.params.value or {}
			if not value.kind then
				return
			end

			local client_id = ev.data.client_id
			local token = ev.data.params.token
			local sl = require("config.statusline")

			if value.kind == "end" then
				set_tmux_lsp_progress("")
				sl.clear_lsp_progress(client_id, token)
			else
				local msg = value.title or value.message or ""
				if value.percentage then
					msg = value.percentage .. "% " .. msg
				end
				sl.set_lsp_progress(client_id, token, msg)
				set_tmux_lsp_progress(string.format("%d%%", value.percentage or 0))
			end
		end,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup("lsp_completion"),
		callback = function(ev)
			vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
		end,
	})

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
		group = augroup("buffer_spell"),
		callback = function(ev)
			update_spell(ev.buf)
		end,
	})
end

return M
