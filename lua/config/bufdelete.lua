local M = {}

function M.delete_current_keep_window()
	local cur = vim.api.nvim_get_current_buf()
	local alt = vim.fn.bufnr("#")
	local target = nil

	if alt > 0 and alt ~= cur and vim.api.nvim_buf_is_valid(alt) and vim.bo[alt].buflisted then
		target = alt
	else
		-- fallback: any other listed loaded buffer
		for _, b in ipairs(vim.api.nvim_list_bufs()) do
			if b ~= cur and vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.api.nvim_buf_is_loaded(b) then
				target = b
				break
			end
		end
	end

	-- if no target exists, create an empty buffer so window never closes
	if not target then
		vim.cmd("enew")
		target = vim.api.nvim_get_current_buf()
	end

	-- move every window showing cur to target BEFORE deleting cur
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == cur then
			vim.api.nvim_win_set_buf(win, target)
		end
	end

	-- now safe to delete
	vim.api.nvim_buf_delete(cur, { force = false })
end

return M
