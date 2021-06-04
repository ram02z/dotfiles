local t = require'utils.misc'.t
local check_back_space = require'utils.misc'.check_back_space
local check_not_comment = require'utils.misc'.check_not_comment

local M = {}

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
M.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

M.s_tab_complete = function()
  if vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  elseif vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<C-h>"
  end
end

return M
