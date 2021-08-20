local function disable_default_plugins()
  -- FIXME: WSL register bug
  vim.g.loaded_clipboard_provider = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.loaded_gzip = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_2html_plugin = 1
end

disable_default_plugins()

-- NOTE: can fail on before installations
pcall(vim.api.nvim_command, "packadd chezmoi.vim")
-- Rest of startup moved to top level plugins folder
