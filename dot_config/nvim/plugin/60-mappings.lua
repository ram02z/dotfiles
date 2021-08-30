local K = vim.keymap

-- Yank
-- NOTE: #13268 got merged
-- K.nmap({ "Y", "y$" })
K.nnoremap({ "yil", "0y$" })
-- Absolute left and right
K.nnoremap({ "H", "g^" })
K.nnoremap({ "L", "g$" })
K.xnoremap({ "H", "g^" })
K.xnoremap({ "L", "g$" })

-- PageUp/PageDown
K.map({ "<PageUp>", "<C-b>", silent = true })
K.map({ "<PageDown>", "<C-f>", silent = true })
K.imap({ "<PageUp>", "<C-O><C-b>", silent = true })
K.imap({ "<PageDown>", "<C-O><C-f>", silent = true })

-- Toggle line numbers
K.nnoremap({ "<Leader>d", "<cmd>set nu! rnu! <CR>", silent = true })

-- Leave terminal mode
K.tnoremap({ "<C-]>", "<C-\\><C-n>", silent = true })

-- Zero toggles between itself and ^
K.noremap({ "0", "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", silent = true, expr = true })

-- Buffer wipeout
K.nnoremap({ "<Leader>q", require("utils.buffer").bufwipeout, silent = true })

-- Window switcher
K.nnoremap({ "<Leader>w", require("utils.window").pick, silent = true })

-- Toggle lists
K.nnoremap({ "<Leader>]", require("utils.misc").toggle_qf, silent = true })
K.nnoremap({ "<Leader>[", require("utils.misc").toggle_loc, silent = true })
