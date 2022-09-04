local M = {}

M.on_attach = function(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.codeActionProvider then
    vim.fn.sign_define("LightBulbSign", { text = "", texthl = "String", linehl = "", numhl = "" })
    vim.cmd([[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua require"nvim-lightbulb".update_lightbulb()]])
    vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action, { buffer = true })
    vim.keymap.set("v", "<Leader>la", vim.lsp.buf.range_code_action, { buffer = true })
  end
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = true })
  vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, { buffer = true })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true })
  vim.keymap.set("n", "<CR>", vim.lsp.buf.signature_help, { buffer = true })
  vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { buffer = true })
  vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, { buffer = true })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = true })
  vim.keymap.set("n", "<Leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, { buffer = true })
  vim.keymap.set("x", "<Leader>f", vim.lsp.buf.range_formatting, { buffer = true })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = true })

  -- Additional plugins
  require("fidget").setup({
    window = {
      blend = 0,
    },
  })
end

-- config that activates keymaps and enables snippet support
M.make = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return {
    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
    -- map buffer local keybindings when the language server attaches
    on_attach = M.on_attach,
    autostart = true,
    flags = {
      debounce_text_changes = 500,
    },
  }
end

return M
