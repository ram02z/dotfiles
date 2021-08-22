-- Avoid showing extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

-- Limit menu items to 5
vim.o.pumheight = 5

local cmp = require("cmp")
local fn = vim.fn
local utils = require("utils.misc")
cmp.register_source("path", require("cmp_path").new())
cmp.register_source("luasnip", require("cmp_luasnip").new())
cmp.register_source("buffer", require("cmp_buffer").new())
cmp.setup({
  completion = {
    autocomplete = {},
    completeopt = "menu,menuone,noinsert",
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.prev_item(),
    ["<C-n>"] = cmp.mapping.next_item(),
    ["<C-d>"] = cmp.mapping.scroll(-4),
    ["<C-f>"] = cmp.mapping.scroll(4),
    ["<C-Space>"] = cmp.mapping.mode({ "i" }, function(core, fallback)
      local types = require("cmp.types")
      if fn.pumvisible() == 1 then
        core.reset()
      else
        core.complete(core.get_context({ reason = types.cmp.ContextReason.Manual }))
      end
    end),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<Tab>"] = cmp.mapping.mode({ "i", "s" }, function(_, _)
      if fn.pumvisible() == 1 then
        fn.feedkeys(utils.t("<C-n>"), "n")
      elseif utils.invalid_prev_col() then
        fn.feedkeys(utils.t("<Tab>"), "n")
      elseif require("luasnip").expand_or_jumpable() then
        fn.feedkeys(utils.t("<Plug>luasnip-expand-or-jump"), "")
      else
        fn.feedkeys(utils.t("<Tab>"), "n")
      end
    end),
    ["<S-Tab>"] = cmp.mapping.mode({ "i", "s" }, function(_, _)
      if fn.pumvisible() == 1 then
        fn.feedkeys(utils.t("<C-p>"), "n")
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(utils.t("<Plug>luasnip-jump-prev"), "")
      else
        fn.feedkeys(utils.t("<C-d>"), "n")
      end
    end),
  },
  formatting = {
    format = function(_, vim_item)
      local codicons = require("codicons")
      local symbols  = require("codicons.extensions.completion_item_kind").symbols
      local icon     = codicons.get(symbols[vim_item.kind].icon)
      vim_item.kind  = string.format("%s %s", vim_item.kind, icon)
      return vim_item
    end,
  },
  sources = {
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  },
})

