-- Avoid showing extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

-- Limit menu items to 5
vim.o.pumheight = 5

local cmp = require("cmp")
local fn = vim.fn
local utils = require("utils.misc")

cmp.setup({
  completion = {
    autocomplete = false,
    completeopt = "menu,menuone,noinsert",
  },
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
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end,
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
    { name = "latex_symbols" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
})
