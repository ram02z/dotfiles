local M = {}

local VIRTUAL_DIAGNOSTICS_NS = vim.api.nvim_create_namespace("hover-diagnostics")
local FLOATING_DIAGNOSTICS_NR = nil

local config = {
  hidden = false,
  view = "virt", -- floating/virtual
  show_all = false, -- only applies to virtual text
}

-- Global config
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = true,
  update_in_insert = false,
})
-- Change diagnostic signs
local signs = { Error = "", Warn = "", Hint = "", Info = "" }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

function M.toggle_hover_view(bufnr)
  if config.show_all then
    return
  end
  bufnr = bufnr or 0
  M.clear_hover_diagnostics(bufnr)
  if config.view == "virt" then
    config.view = "float"
  else
    config.view = "virt"
  end
end

function M.toggle_hover_diagnostics(bufnr)
  if config.show_all then
    return
  end
  bufnr = bufnr or 0
  config.hidden = not config.hidden
  M.clear_hover_diagnostics(bufnr)
end

function M.toggle_all_diagnostics(bufnr)
  bufnr = bufnr or 0
  config.show_all = not config.show_all
  if config.view == "virt" and config.show_all then
    M.clear_hover_diagnostics(bufnr)
    vim.diagnostic.config({ virtual_text = true })
  else
    vim.diagnostic.config({ virtual_text = false })
  end
end

-- Remove previous virtual text highlight
function M.clear_hover_diagnostics(bufnr)
  if config.view == "virt" then
    vim.diagnostic.hide(VIRTUAL_DIAGNOSTICS_NS, bufnr)
  elseif config.view == "float" and FLOATING_DIAGNOSTICS_NR then
    if vim.api.nvim_buf_is_loaded(FLOATING_DIAGNOSTICS_NR) then
      vim.api.nvim_buf_delete(FLOATING_DIAGNOSTICS_NR, { force = true })
    end
  end
end

function M.update_hover_diagnostics(bufnr)
  bufnr = bufnr or 0

  if config.hidden or config.show_all then
    return
  end

  if vim.api.nvim_get_mode().mode == "i" then
    M.clear_hover_diagnostics(bufnr)
    return
  end

  if config.view == "float" then
    FLOATING_DIAGNOSTICS_NR = vim.diagnostic.open_float(bufnr, {
      {
        focusable = false,
        show_header = false,
      },
      scope = "line",
    })
  elseif config.view == "virt" then
    if config.show_all == true then
      vim.diagnostic.config({ virtual_text = true })
      return
    end

    local lnum, _ = unpack(vim.api.nvim_win_get_cursor(0))
    lnum = lnum - 1

    local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })
    vim.diagnostic.show(VIRTUAL_DIAGNOSTICS_NS, bufnr, diagnostics, {
      signs = false,
      virtual_text = true,
      underline = false,
    })
  end
end

return M
