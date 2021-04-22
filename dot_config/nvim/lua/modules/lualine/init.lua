-- Lualine config
local lualine = require('lualine')

lline_config = {
    options = {
        theme = 'dracula',
        section_separators = {'', ''},
        component_separators = {'', ''},
        icons_enabled = true,
    },
    sections = {
        lualine_b = {'branch', 'diff'},
    },
    extensions = { 'fugitive' }, 
}

lualine.setup(lline_config)
