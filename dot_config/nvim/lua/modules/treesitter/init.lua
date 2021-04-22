-- TreeSitter Config
local tree_sitter = require('nvim-treesitter.configs')

local ts_config = {
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = true },
    refactor = {
        highlight_definitions = { enable = true },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gnd",
                list_definitions = "gnD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
            },
        },
    },
    -- nvim-ts-autotag
    autotag = { enable = true },
}

tree_sitter.setup(ts_config)
