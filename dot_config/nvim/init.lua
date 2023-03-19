-- Required to be loaded first by lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "  "

-- NOTE: required for WSL register bug
vim.g.loaded_clipboard_provider = 1

-- Install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = { lazy = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.api.nvim_create_user_command("PurgeUndoFiles", function()
  require("utils.misc").purge_old_undos()
end, {})

vim.cmd.colorscheme("dracula")
