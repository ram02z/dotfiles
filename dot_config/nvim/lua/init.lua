-- Append plenary.filetypes
require'plenary.filetype'.add_file('extra')

-- TODO: Add to setup
require'nvim-lastplace'.setup()

require'modules.colorizer'

require'modules.devicons'

require'modules.compe'
require'modules.compe.mappings'

require'modules.treesitter'

require'modules.hop'
require'modules.hop.mappings'

require'modules.autopairs'
-- require'modules.autopairs.mappings'

require'modules.gitsigns'

require'modules.statusline'

require'modules.telescope'
require'modules.telescope.mappings'

require'modules.numb'

require'modules.bufferline'
require'modules.bufferline.mappings'

require'modules.kommentary'
require'modules.kommentary.mappings'

require'modules.lspinstall'

require'modules.dial'

require'modules.neoscroll'

-- Chord cancelation
require'keychord'.cancel('<leader>')
