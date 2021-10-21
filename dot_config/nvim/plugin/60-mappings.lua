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

-- Search and replace
K.nnoremap({ "<Leader>sr", ":%s/\\<<C-r><C-w>\\>//g<left><left>", silent = true })

-- Diagnostic keymaps
K.nnoremap({
  "]d",
  function()
    vim.diagnostic.goto_next({ float = false })
  end,
})
K.nnoremap({
  "[d",
  function()
    vim.diagnostic.goto_prev({ float = false })
  end,
})
K.nnoremap({
  "<Leader>dl",
  vim.diagnostic.setloclist,
})
K.nnoremap({
  "<Leader>dt",
  require("modules.diagnostic").toggle_hover_diagnostics,
})
K.nnoremap({
  "<Leader>dv",
  require("modules.diagnostic").toggle_hover_view,
})
K.nnoremap({
  "<Leader>da",
  require("modules.diagnostic").toggle_all_diagnostics,
})

require("utils.keychord").cancel("<Leader>d", false)
