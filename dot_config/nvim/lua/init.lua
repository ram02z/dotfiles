-- Append plenary.filetypes
require'plenary.filetype'.add_file('extra')

require'nvim-lastplace'.setup()

require'utils.modules'.source(false)

require'utils.keymaps'
require'mappings'
