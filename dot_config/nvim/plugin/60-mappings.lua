local K = vim.keymap

-- Disable exmode
K.set("n", "Q", "<nop>")

vim.cmd([[
command! -nargs=0 W :w
command! -nargs=0 Q :q
]])

-- Yank
K.set("n", "yil", "0y$")
-- Absolute left and right
K.set({ "n", "x" }, "H", "g^")
K.set({ "n", "x" }, "L", "g$")

-- PageUp/PageDown
K.set("", "<PageUp>", "<C-b>", { silent = true })
K.set("i", "<PageUp>", "<C-O><C-b>", { silent = true })
K.set("", "<PageDown>", "<C-f>", { silent = true })
K.set("i", "<PageDown>", "<C-O><C-f>", { silent = true })

-- Moving in insert mode
K.set("i", "<C-j>", "<Down>", { silent = true })
K.set("i", "<C-k>", "<Up>", { silent = true })
K.set("i", "<C-h>", "<Left>", { silent = true })
K.set("i", "<C-l>", "<Right>", { silent = true })
-- Useful arrow keys
K.set({ "n", "v" }, "<Down>", "<C-e>")
K.set({ "n", "v" }, "<Up>", "<C-y>")
K.set("n", "<Left>", "<<")
K.set("n", "<Right>", ">>")
K.set("v", "<Left>", "<gv")
K.set("v", "<Right>", ">gv")

-- Remap for dealing with word wrap
K.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })
K.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })

-- Insert blankline
K.set("n", "<Plug>(BlankDown)", ":<C-U>exe utils#blank_down()<CR>", { silent = true })
K.set("n", "<Leader>o", ":<C-U>exe utils#blank_down()<CR>", { silent = true })

K.set("n", "<Plug>(BlankUp)", ":<C-U>exe utils#blank_up()<CR>", { silent = true })
K.set("n", "<Leader>O", ":<C-U>exe utils#blank_up()<CR>", { silent = true })

-- Leave terminal mode
K.set("t", "<C-]>", "<C-\\><C-n>", { silent = true })

-- Zero toggles between itself and ^
K.set("", "0", "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { silent = true, expr = true })

-- Buffer wipeout
K.set("n", "<Leader>q", "<cmd>lua require('utils.buffer').bufwipeout()<CR>", { silent = true })

-- Window switcher
K.set("n", "<Leader>w", "<cmd>lua require('utils.window').pick()<CR>", { silent = true })

-- Toggle lists
K.set("n", "<Leader>]", "<cmd>lua require('utils.misc').toggle_qf()<CR>", { silent = true })
K.set("n", "<Leader>[", "<cmd>lua require('utils.misc').toggle_loc()<CR>", { silent = true })

-- Find and replace
K.set("n", "<Leader>fs", ":%s/\\<<C-r><C-w>\\>//g<left><left>", { silent = true })

-- Diagnostic keymaps
K.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>")
K.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>")
K.set("n", "<Leader>dl", "<cmd>lua vim.diagnostic.setloclist()<CR>")
K.set("n", "<Leader>df", "<cmd>lua require('modules.diagnostic').toggle_float_view()<CR>")
-- K.set("n", "<Leader>dt", "<cmd>lua require('modules.diagnostic').toggle_hover_diagnostics()<CR>")
-- K.set("n", "<Leader>dv", "<cmd>lua require('modules.diagnostic').toggle_hover_view()<CR>")
K.set("n", "<Leader>da", "<cmd>lua require('modules.diagnostic').toggle_all_diagnostics()<CR>")

require("utils.keychord").cancel("<Leader>d", false)
