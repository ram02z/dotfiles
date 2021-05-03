-- Install packer
local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
end

vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]], false)

--[[ require'modules.colorizer'

require'modules.devicons'

require'modules.compe'
require'modules.compe.mappings'

require'modules.treesitter'

require'modules.hop'
require'modules.hop.mappings'

require'modules.autopairs'
require'modules.autopairs.mappings'

require'modules.gitsigns'

-- require'modules.lualine'
require'modules.statusline'

require'modules.telescope'
require'modules.telescope.mappings'

require'modules.surround'

require'modules.numb'

require'modules.bufferline'
require'modules.bufferline.mappings'

require'modules.kommentary'
require'modules.kommentary.mappings'

require'modules.lspinstall'

require'modules.neoscroll' ]]
