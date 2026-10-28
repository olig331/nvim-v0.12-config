local dadbod = require("vim_dadbod_completion.blink")

local function in_csharp_sql_string()
	local node = vim.treesitter.get_node({ bufnr = 0 })
	while node do
		if node:type() == "raw_string_content" then
			return true
		end
		node = node:parent()
	end
	return false
end

local M = {}

function M.new()
	local source = dadbod.new()
	local original_get_completions = source.get_completions

	function source:enabled()
		if not vim.env.DATABASE_URL and not vim.g.db then
			return false
		end

		if vim.tbl_contains({ "cs", "c_sharp" }, vim.bo.filetype) then
			return in_csharp_sql_string()
		end

		return vim.tbl_contains({ "sql", "mysql", "plsql" }, vim.bo.filetype)
	end

	function source:get_completions(ctx, callback)
		local filetype = vim.bo.filetype

		-- Dadbod uses the buffer filetype to identify SQL buffers. Temporarily
		-- expose embedded C# SQL as SQL while it gathers completions.
		if filetype == "cs" or filetype == "c_sharp" then
			vim.bo.filetype = "sql"
		end

		local ok, result = pcall(original_get_completions, self, ctx, callback)
		vim.bo.filetype = filetype

		if not ok then
			error(result)
		end

		return result
	end

	return source
end

return M
