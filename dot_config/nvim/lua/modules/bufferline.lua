local bline = require'bufferline'

local bline_conf = {
  options = {
    numbers = 'ordinal',
    number_style = 'none',
    show_buffer_close_icons = false,
    show_close_icon = false,
    always_show_bufferline = false,
    diagnostics = 'nvim_lsp',
    mappings = false,
  },
  highlights = {
    fill = {
      guibg = '#21222C'
    },
    background = {
      guibg = '#21222C'
    },
    separator = {
      guibg = '#21222C'
    },
    modified = {
      guifg = '#44475A'
    },
    modified_selected = {
      guifg = '#C6C7D1'
    },
    modified_visible = {
      guifg = '#ADAEBE'
    },
  }
}

bline.setup(bline_conf)
