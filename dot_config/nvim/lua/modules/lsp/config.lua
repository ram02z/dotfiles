local M = {}

M.on_attach = function(client, bufnr)
  local caps = client.server_capabilities
  -- Set autocommands conditional on server_capabilities
  if caps.codeActionProvider then
    vim.fn.sign_define("LightBulbSign", { text = "", texthl = "String", linehl = "", numhl = "" })
    local augroup = vim.api.nvim_create_augroup("CodeAction", {})
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
      group = augroup,
      buffer = bufnr,
      callback = function()
        require("nvim-lightbulb").update_lightbulb()
      end,
    })
    vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, { buffer = true })
  end

  if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
    local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
    vim.api.nvim_create_autocmd("TextChanged", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.semantic_tokens_full()
      end,
    })
    -- fire it first time on load as well
    vim.lsp.buf.semantic_tokens_full()
  end

  -- Set kepmaps regardless of server_capabilities
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
  vim.keymap.set("x", "<Leader>f", vim.lsp.formatexpr, { buffer = true })
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
  return {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    -- map buffer local keybindings when the language server attaches
    on_attach = M.on_attach,
    autostart = true,
    flags = {
      debounce_text_changes = 500,
    },
  }
end

return M
