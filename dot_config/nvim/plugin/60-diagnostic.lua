local M = {}
local K = vim.keymap

-- lsp_lines.nvim plugin
require("lsp_lines").setup()

-- Global config
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = true,
  update_in_insert = false,
  virtual_lines = false,
})

-- Change diagnostic signs
local signs = { Error = "", Warn = "", Hint = "", Info = "" }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Diagnostic keymaps
K.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>")
K.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>")
K.set("n", "<Leader>dl", "<cmd>lua vim.diagnostic.setloclist()<CR>")
K.set("n", "<Leader>df", function()
  if type(FLOATING_DIAGNOSTICS_NR) == "number" and vim.api.nvim_buf_is_loaded(FLOATING_DIAGNOSTICS_NR) then
    vim.api.nvim_buf_delete(FLOATING_DIAGNOSTICS_NR, { force = true })
  else
    FLOATING_DIAGNOSTICS_NR = vim.diagnostic.open_float(bufnr, {
      {
        focusable = false,
        header = false,
      },
      scope = "line",
    })
  end
end, { desc = "Open floating diagnostic window at cursor" })
K.set("n", "<Leader>da", function()
  local virtual_lines = vim.diagnostic.config().virtual_lines
  local virtual_text = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_lines = not virtual_lines, virtual_text = not virtual_text })
end, { desc = "Toggle between lsp_lines and virtual text" })

require("utils.keychord").cancel("<Leader>d", false)

return M
