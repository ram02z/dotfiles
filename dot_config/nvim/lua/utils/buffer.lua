local M = {}

-- TODO: use vim.api functions
-- Options
-- next = 'cycle' or 'alternate'
local opts = {next = 'alternate'}  -- how to retrieve the next buffer

-- Switch to buffer 'buf' on each window from list 'windows'
local function switch_buffer(windows, buf)
  local cur_win = vim.api.nvim_get_current_win()
  for _, winid in ipairs(windows) do
    vim.cmd(string.format('%d wincmd w', vim.fn.win_id2win(winid)))
    -- vim.cmd(string.format('buffer %d', buf))
    vim.api.nvim_set_current_buf(buf)
  end
  vim.api.nvim_set_current_win(cur_win)
end

-- Select the first buffer with a number greater than given buffer
local function get_next_buf(buf)
  local next = vim.fn.bufnr('#')
  if opts.next == 'alternate' and vim.api.nvim_buf_is_loaded(next) == true then
    return next
  end
  for i = 0, vim.fn.bufnr('$') - 1 do
    next = (buf + i) % vim.fn.bufnr('$') + 1  -- will loop back to 1
    if vim.api.nvim_buf_is_loaded(next) == true then
      return next
    end
  end
end

-- Retrieve the buffer associated to the given name or number
local function get_buf(bufexpr)
  if not bufexpr then  -- return current buffer when 'bufexpr' is nil
    return vim.fn.bufnr()
  end
  if tonumber(bufexpr) then
    return tonumber(bufexpr)
  end
  bufexpr = string.gsub(bufexpr, [[^['"]+]], '')  -- escape any start quote
  bufexpr = string.gsub(bufexpr, [[['"]+$]], '')  -- escape any end quote
  return vim.fn.bufnr(bufexpr)
end

M.bufwipeout = function(bufexpr)
  local buf = get_buf(bufexpr)
  local bufno = #vim.fn.getbufinfo({buflisted = 1})
  -- exit neovim when there is only one buffer left
  if bufno < 2 then
    vim.cmd('confirm qall')
  end
  if vim.fn.buflisted(buf) == 0 then  -- exit if buffer number is invalid
    return
  end
  if bufno == 2 and #vim.api.nvim_tabpage_list_wins(0) > 1 then -- Remove split
    vim.cmd[[only]]
  end
  local next_buf = get_next_buf(buf)
  local windows = vim.fn.getbufinfo(buf)[1].windows
  switch_buffer(windows, next_buf)
  -- force deletion of terminal buffers to avoid the prompt
  if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
    -- vim.cmd(string.format('bwipeout! %d', buf))
    vim.api.nvim_buf_delete(buf, {force = true})
  else
    vim.api.nvim_buf_delete(buf, {})
  end
  -- revert buffer switches if user has canceled deletion
  if vim.api.nvim_buf_is_loaded(buf) == true then
    switch_buffer(windows, buf)
  end
end

return M
