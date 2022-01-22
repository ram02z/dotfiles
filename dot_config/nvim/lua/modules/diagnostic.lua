local M = {}

-- Global config
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = true,
  update_in_insert = false,
  virtual_lines = true,
})

-- Change diagnostic signs
local signs = { Error = "", Warn = "", Hint = "", Info = "" }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Workaround for ESLint (neovim #16673)
vim.diagnostic.set = (function(orig)
  return function(namespace, bufnr, diagnostics, opts)
    for _, v in ipairs(diagnostics) do
      v.col = v.col or 0
    end
    return orig(namespace, bufnr, diagnostics, opts)
  end
end)(vim.diagnostic.set)

function M.toggle_all_diagnostics()
  local virtual_lines = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = not virtual_lines })
end

function M.toggle_float_view()
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
end

return M
