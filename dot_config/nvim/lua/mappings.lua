local K = vim.keymap

-- Yank
K.nmap({'Y', 'y$'})
K.nmap({'yil', '0y$'})

-- PageUp/PageDown
K.map({'<PageUp>', '<C-b>', silent = true})
K.map({'<PageDown>', '<C-f>', silent = true})
K.imap({'<PageUp>', '<C-O><C-b>', silent = true})
K.imap({'<PageDown>', '<C-O><C-f>', silent = true})

-- Toggle line numbers
K.nnoremap({'<Leader>d', '<cmd>:set nu! rnu! <CR>', silent = true})

-- Leave terminal mode
K.tnoremap({'<C-]>', '<C-\\><C-n>', silent = true})

-- Zero toggles between itself and ^
K.noremap({'0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", silent = true, expr = true})

-- Buffer wipeout
K.nnoremap({'<Leader>q', require'utils.buffer'.bufwipeout, silent = true})

-- Window switcher
K.nnoremap({'<Leader>w', require'utils.window'.pick, silent = true})

-- TODO: change to native lua if that ever gets merged
vim.cmd [[command! PurgeUndoFiles call luaeval('require"utils.misc".purge_old_undos()')]]

-- Toggle list
K.nnoremap({'<Leader>]', require'utils.misc'.toggle_qf, silent = true})
K.nnoremap({'<Leader>[', require'utils.misc'.toggle_loc, silent = true})
