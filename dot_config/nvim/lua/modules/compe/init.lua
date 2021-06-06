-- Compe setup
-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noselect"

-- Avoid showing extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

-- Limit menu items to 5
vim.o.pumheight = 5

-- Increase menu width
vim.o.pumwidth = 25

local compe = require('compe')

local compe_conf = {
  enabled = true,
  autocomplete = true,

  source = {
    path = {
      kind = ''
    },
    buffer = {
      kind = '',
      filetypes = {'fish'}
    },
    vsnip = {
      kind = '',
      priority = 10000
    },
    nvim_lsp = {
      priority = 9999
    },
  },
}

-- init compe
compe.setup(compe_conf)

-- Maps
vim.keymap.inoremap({'<CR>', 'compe#complete(\'<CR>\')', silent = true, expr = true})
vim.keymap.inoremap({'<C-Space>', 'pumvisible() ? compe#close() : compe#complete()', silent = true, expr = true})

vim.keymap.inoremap({'<TAB>', 'v:lua.require\'modules.compe.functions\'.tab_complete()', silent = true, expr = true})
vim.keymap.snoremap({'<TAB>', 'v:lua.require\'modules.compe.functions\'.tab_complete()', silent = true, expr = true})

vim.keymap.inoremap({'<S-TAB>', 'v:lua.require\'modules.compe.functions\'.s_tab_complete()', silent = true, expr = true})
vim.keymap.snoremap({'<S-TAB>', 'v:lua.require\'modules.compe.functions\'.s_tab_complete()', silent = true, expr = true})

