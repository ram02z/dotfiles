local function disable_default_plugins()
  -- FIXME: WSL register bug
  vim.g.loaded_clipboard_provider = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
end

disable_default_plugins()

-- Loading moved to top level plugins folder
