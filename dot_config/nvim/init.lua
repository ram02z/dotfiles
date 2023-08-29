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

vim.loader.enable()

vim.api.nvim_create_user_command("PurgeUndoFiles", function()
  require("utils.misc").purge_old_undos()
end, {})

vim.cmd.colorscheme("dracula")
