local M = {}

local VIRTUAL_DIAGNOSTICS_NS = vim.api.nvim_create_namespace("virtual-diagnostics")

local config = {
  show_virtual_text = true,
}

function M.toggle_virtual_diagnostics()
  config.show_virtual_text = not config.show_virtual_text
  M.clear_virtual_diagnostics(bufnr)
end

function M.clear_virtual_diagnostics(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, VIRTUAL_DIAGNOSTICS_NS, 0, -1)
end

function M.update_virtual_diagnostics(opts, bufnr, line_nr, client_id)
  opts = opts or {}
  bufnr = bufnr or 0

  -- Remove previous highlights
  M.clear_virtual_diagnostics(bufnr)

  if not config.show_virtual_text then
    return
  end

  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
  if vim.tbl_isempty(line_diagnostics) then
    return
  end

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
