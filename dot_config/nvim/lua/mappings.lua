local K = vim.keymap

-- PageUp/PageDown
K.map({'<PageUp>', '<C-b>', silent = true})
K.map({'<PageDown>', '<C-f>', silent = true})
K.imap({'<PageUp>', '<C-O><C-b>', silent = true})
K.imap({'<PageDown>', '<C-O><C-f>', silent = true})

-- Buffer manipulation
local buffer = require'utils.buffer'
K.nnoremap({'<Leader>q', buffer.bufwipeout, silent = true})
K.nnoremap({'<Leader>l', ':e#<CR>', silent = true})

-- Toggle line numbers
K.nnoremap({'<Leader>d', ':set nu! rnu! <CR>', silent = true})

-- Terminal buffer
-- TODO: Use nvim-toggleterm
K.nnoremap({'<Leader><CR>', ':term<CR>', silent = true})
K.tnoremap({'<C-]>', '<C-\\><C-n>', silent = true})

-- Zero toggles between itself and ^
K.noremap({'0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", silent = true, expr = true})
