-- Avoid showing extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

-- Limit menu items to 5
vim.o.pumheight = 5

local cmp = require("cmp")
local fn = vim.fn
local utils = require("utils.misc")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  preselect = cmp.PreselectMode.None,
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end,
    ["<C-y>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
  },
  formatting = {
    format = function(_, vim_item)
      local codicons = require("codicons")
      local symbols = require("codicons.extensions.completion_item_kind").symbols
      local icon = codicons.get(symbols[vim_item.kind].icon)
      -- vim_item.kind = string.format("%s %s", vim_item.kind, icon)
      vim_item.kind = icon
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = "luasnip", keyword_length = 3 },
    { name = "nvim_lua" },
    { name = "nvim_lsp", keyword_length = 2 },
    { name = "path" },
  }, {
    { name = "buffer", keyword_length = 4 },
  }),
})
