vim.cmd [[packadd packer.nvim]]
local packer = require'packer'
local use = packer.use

packer.startup(function()
  use {'wbthomason/packer.nvim', opt = true}

  use {'editorconfig/editorconfig-vim'}

)
