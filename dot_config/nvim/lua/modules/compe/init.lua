-- Compe setup
-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noselect"

-- Avoid showing extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

-- Limit menu items to 5
vim.o.pumheight = 5

-- Increase menu width
vim.o.pumwidth = 25

-- Manually disable sources
-- Lazy load coming soon :)
-- vim.g.loaded_compe_buffer = 1
-- vim.g.loaded_compe_calc = 1
vim.g.loaded_compe_emoji = 0
vim.g.loaded_compe_luasnip = 0
-- vim.g.loaded_compe_nvim_lsp = 1
vim.g.loaded_compe_nvim_lua = 0
vim.g.loaded_compe_omni = 0
-- vim.g.loaded_compe_path = 1
vim.g.loaded_compe_snippets_nvim = 0
vim.g.loaded_compe_spell = 0
vim.g.loaded_compe_tags = 0
vim.g.loaded_compe_treesitter = 0
vim.g.loaded_compe_ultisnips = 0
vim.g.loaded_compe_vim_lsc = 0
vim.g.loaded_compe_vim_lsp = 0
-- vim.g.loaded_compe_vsnip = 1

local compe = require('compe')

local compe_conf = {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  allow_prefix_unmatch = false,
  throttle_time = 80,
  score_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    calc = true,
    buffer = true,
    vsnip = true,
    nvim_lsp = true,
    -- tag = true,
    -- treesitter = true,
  },
}

-- init compe
compe.setup(compe_conf)

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<C-d>"
  end
end
