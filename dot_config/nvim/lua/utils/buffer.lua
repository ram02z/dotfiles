local M = {}

local cmd = vim.api.nvim_command

-- opts: force
M.bufwipeout = function(bufnr, opts)
  local buffers = vim.api.nvim_list_bufs()
  -- exit if buffer number is invalid
  if bufnr and not vim.tbl_contains(buffers, bufnr) then
    return
  end

  -- exit neovim when there is only one buffer left
  if #buffers < 2 then
    cmd("confirm qall")
  end
  -- Remove split
  if #buffers == 2 and #vim.api.nvim_tabpage_list_wins(0) > 1 then
    cmd("only")
  end

  bufnr = bufnr or vim.api.nvim_get_current_buf()
  -- force deletion of terminal buffers to avoid the prompt
  if (opts and opts.force == true) or
    vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  else
    vim.api.nvim_buf_delete(bufnr, {})
  end
end

return M
