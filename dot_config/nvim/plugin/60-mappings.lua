local K = vim.keymap

-- Disable exmode
K.nnoremap({ "Q", "<nop>" })

vim.cmd([[
command! -nargs=0 W :w
command! -nargs=0 Q :q
]])

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

-- Moving in insert mode
K.imap({ "<C-j>", "<Down>", silent = true })
K.imap({ "<C-k>", "<Up>", silent = true })
K.imap({ "<C-h>", "<Left>", silent = true })
K.imap({ "<C-l>", "<Right>", silent = true })
-- Useful arrow keys
K.nmap({ "<Down>", "<C-e>" })
K.nmap({ "<Up>", "<C-y>" })
K.vmap({ "<Down>", "<C-e>" })
K.vmap({ "<Up>", "<C-y>" })
K.nmap({ "<Left>", "<<" })
K.nmap({ "<Right>", ">>" })
K.vmap({ "<Left>", "<gv" })
K.vmap({ "<Right>", ">gv" })

-- Remap for dealing with word wrap
K.nnoremap({ "k", "v:count == 0 ? 'gk' : 'k'", silent = true, expr = true })
K.nnoremap({ "j", "v:count == 0 ? 'gj' : 'j'", silent = true, expr = true })

-- Insert blankline
K.nnoremap({"<Plug>(BlankDown)", ":<C-U>exe utils#blank_down()<CR>", silent = true})
K.nnoremap({"<Leader>o", ":<C-U>exe utils#blank_down()<CR>", silent = true})

K.nnoremap({"<Plug>(BlankUp)", ":<C-U>exe utils#blank_up()<CR>", silent = true})
K.nnoremap({"<Leader>O", ":<C-U>exe utils#blank_up()<CR>", silent = true})

-- Leave terminal mode
K.tnoremap({ "<C-]>", "<C-\\><C-n>", silent = true })

-- Zero toggles between itself and ^
K.noremap({ "0", "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", silent = true, expr = true })

-- Buffer wipeout
K.nnoremap({ "<Leader>q", "<cmd>lua require('utils.buffer').bufwipeout()<CR>", silent = true })

-- Window switcher
K.nnoremap({ "<Leader>w", "<cmd>lua require('utils.window').pick()<CR>", silent = true })

-- Toggle lists
K.nnoremap({ "<Leader>]", "<cmd>lua require('utils.misc').toggle_qf()<CR>", silent = true })
K.nnoremap({ "<Leader>[", "<cmd>lua require('utils.misc').toggle_loc()<CR>", silent = true })

-- Find and replace
K.nnoremap({ "<Leader>fs", ":%s/\\<<C-r><C-w>\\>//g<left><left>", silent = true })

-- Diagnostic keymaps
K.nnoremap({
  "]d",
  "<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>",
})
K.nnoremap({
  "[d",
  "<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>",
})
K.nnoremap({
  "<Leader>dl",
  "<cmd>lua vim.diagnostic.setloclist()<CR>",
})
K.nnoremap({
  "<Leader>dt",
  "<cmd>lua require('modules.diagnostic').toggle_hover_diagnostics()<CR>",
})
K.nnoremap({
  "<Leader>dv",
  "<cmd>lua require('modules.diagnostic').toggle_hover_view()<CR>",
})
K.nnoremap({
  "<Leader>da",
  "<cmd>lua require('modules.diagnostic').toggle_all_diagnostics()<CR>",
})

require("utils.keychord").cancel("<Leader>d", false)
