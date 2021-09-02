local M = {}

local VIRTUAL_DIAGNOSTICS_NS = vim.api.nvim_create_namespace("hover-diagnostics")
local FLOATING_DIAGNOSTICS_NR = nil

local config = {
  show_diagnostic = true,
  view = "floating", -- floating/virtual
  modes = { "n" }, -- vim modes
}

function M.toggle_hover_diagnostics()
  config.show_diagnostic = not config.show_diagnostic
  M.clear_hover_diagnostics(bufnr)
end

-- Remove previous virtual text highlight
function M.clear_hover_diagnostics(bufnr)
  if config.view == "virtual" then
    vim.api.nvim_buf_clear_namespace(bufnr, VIRTUAL_DIAGNOSTICS_NS, 0, -1)
  elseif config.view == "floating" and FLOATING_DIAGNOSTICS_NR then
    if vim.api.nvim_buf_is_loaded(FLOATING_DIAGNOSTICS_NR) then
      vim.api.nvim_buf_delete(FLOATING_DIAGNOSTICS_NR, { force = true })
    end
  end
end

function M.update_hover_diagnostics(opts, bufnr, line_nr, client_id)
  opts = opts or {}
  bufnr = bufnr or 0

  M.clear_hover_diagnostics(bufnr)

  if not config.show_diagnostic then
    return
  end

  local vim_mode = vim.api.nvim_get_mode().mode
  if not vim.tbl_contains(config.modes, vim_mode) then
    return
  end

  if config.view == "floating" then
    FLOATING_DIAGNOSTICS_NR = vim.lsp.diagnostic.show_line_diagnostics({
      focusable = false,
      show_header = false,
    })
    return
  end

  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
  if vim.tbl_isempty(line_diagnostics) then
    return
  end

  -- TODO: improve diagnostic message display
  -- truncate when more than one diagnostic on one line
  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  local virt_texts = vim.lsp.diagnostic.get_virtual_text_chunks_for_line(bufnr, line_nr, line_diagnostics, opts)
  local ns_id = vim.api.nvim_create_namespace(diagnostic_message)
  vim.api.nvim_buf_set_extmark(bufnr, VIRTUAL_DIAGNOSTICS_NS, line_nr, 0, {
    virt_text = virt_texts,
  })
end

return M
