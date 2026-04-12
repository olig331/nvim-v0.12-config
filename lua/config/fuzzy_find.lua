local M = {}

local cache = {
	cwd = nil,
	files = nil,
}

local function get_files()
	local cwd = vim.loop.cwd()
	if cache.cwd == cwd and cache.files then
		return cache.files
	end

	local files = vim.fn.systemlist({ "rg", "--files", "--hidden", "-g", "!.git" })
	if vim.v.shell_error ~= 0 then
		files = {}
	end

	cache.cwd = cwd
	cache.files = files
	return files
end

local function fuzzy_match(query, candidate)
	query = query:lower()
	candidate = candidate:lower()

	if query == "" then
		return true, 999999
	end

	local qi = 1
	local score = 0
	local last = 0

	for i = 1, #candidate do
		if candidate:sub(i, i) == query:sub(qi, qi) then
			score = score + (i - last)
			last = i
			qi = qi + 1
			if qi > #query then
				return true, score
			end
		end
	end

	return false, nil
end

local function complete_files(arglead)
	local matches = {}

	for _, file in ipairs(get_files()) do
		local ok, score = fuzzy_match(arglead, file)
		if ok then
			table.insert(matches, { file = file, score = score })
		end
	end

	table.sort(matches, function(a, b)
		if a.score == b.score then
			return a.file < b.file
		end
		return a.score < b.score
	end)

	local out = {}
	for _, item in ipairs(matches) do
		table.insert(out, item.file)
	end
	return out
end

function M.setup()
	vim.api.nvim_create_user_command("F", function(opts)
		vim.cmd.edit(vim.fn.fnameescape(opts.args))
	end, {
		nargs = 1,
		complete = function(arglead, _, _)
			return complete_files(arglead)
		end,
	})
end

return M
