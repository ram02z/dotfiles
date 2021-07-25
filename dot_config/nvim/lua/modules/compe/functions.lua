local t = require("utils.misc").t
local luasnip = require("luasnip")

local M = {}

--- move to prev/next item
M.next_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-n>")
  elseif luasnip.expand_or_jumpable() then
    return t("<Plug>luasnip-expand-or-jump")
  else
    return t("<Tab>")
  end
end

M.prev_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-p>")
  elseif luasnip.jumpable(-1) then
    return t("<Plug>luasnip-jump-prev")
  else
    return t("<C-h>")
  end
end

return M
