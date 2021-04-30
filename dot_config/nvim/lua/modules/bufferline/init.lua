local bline = require'bufferline'

bline_conf = {
    options = {
        numbers = "ordinal",
        number_style = "none",
        show_buffer_close_icons = false,
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
    },
    highlights = {
        fill = {
            guibg = '#21232B'
        },
        background = {
            guibg = '#21232B'
        },
        separator = {
            guibg = '#21232B'
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
