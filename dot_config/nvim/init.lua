local function disable_default_plugins()
  -- FIXME: WSL register bug
  vim.g.loaded_clipboard_provider = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_gzip = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_2html_plugin = 1
end

disable_default_plugins()

-- TODO: remove when https://github.com/neovim/neovim/pull/15436 is merged
pcall(require, "impatient")

-- NOTE: can fail on before installations
pcall(vim.api.nvim_command, "packadd chezmoi.vim")
-- Rest of startup moved to top level plugins folder

vim.api.nvim_add_user_command("PurgeUndoFiles", function()
  require("utils.misc").purge_old_undos()
end, {})

vim.api.nvim_command("colorscheme dracula")
