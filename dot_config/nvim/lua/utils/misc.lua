local M = {}

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

M.check_not_comment = function()
  local success = pcall(require, "nvim-treesitter.ts_utils")
  if not success then return true end
  local node = require'nvim-treesitter.ts_utils'.get_node_at_cursor()
  if node == nil then return true end
  -- Not sure if source == comment
  if node:type() == "source"  then
    return true
  else
    return false
  end
end


return M
