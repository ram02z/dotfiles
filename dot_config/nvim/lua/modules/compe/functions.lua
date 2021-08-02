local utils = require("utils.misc")
local luasnip = require("luasnip")

local M = {}

--- move to prev/next item
M.next_complete = function()
  if vim.fn.pumvisible() == 1 then
    return utils.t("<C-n>")
    -- elseif utils.check_next_col() then
    --   return utils.t("<Tab>")
  elseif luasnip.expand_or_jumpable() then
    return utils.t("<Plug>luasnip-expand-or-jump")
  else
    return utils.t("<Tab>")
  end
end

M.prev_complete = function()
  if vim.fn.pumvisible() == 1 then
    return utils.t("<C-p>")
  elseif luasnip.jumpable(-1) then
    return utils.t("<Plug>luasnip-jump-prev")
  else
    return utils.t("<C-h>")
  end
end

return M
