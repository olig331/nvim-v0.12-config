-- Custom buffer order tracking for MRU buffer switching
local M = {}

-- Ordered list of buffer numbers, most recent first
local buflist = {}

-- Utility: remove a buffer from the list
local function remove_buf(bufnr)
  for i, b in ipairs(buflist) do
    if b == bufnr then
      table.remove(buflist, i)
      return
    end
  end
end

-- Utility: add buffer to front
local function push_buf(bufnr)
  remove_buf(bufnr)
  table.insert(buflist, 1, bufnr)
end

-- On buffer enter, update MRU list
function M.on_buf_enter()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_is_loaded(bufnr) then
    push_buf(bufnr)
  end
end

-- On buffer delete, remove from list
function M.on_buf_delete(args)
  remove_buf(args.buf)
end

-- Get next MRU buffer (not current)
function M.next_mru()
  local cur = vim.api.nvim_get_current_buf()
  for _, b in ipairs(buflist) do
    if b ~= cur and vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_is_loaded(b) then
      return b
    end
  end
  return nil
end

-- Setup autocommands
function M.setup()
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = M.on_buf_enter,
    group = vim.api.nvim_create_augroup("user_buforder", { clear = true }),
  })
  vim.api.nvim_create_autocmd({"BufDelete", "BufWipeout"}, {
    callback = M.on_buf_delete,
    group = "user_buforder",
  })
end

return M
