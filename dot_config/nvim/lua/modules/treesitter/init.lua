-- TreeSitter Config
local tree_sitter = require('nvim-treesitter.configs')

local ts_config = {
    ensure_installed = 'maintained',
    highlight = { 
        enable = true,
        disable = { "html", "xml"},
        additional_vim_regex_highlighting = true,
    },
    incremental_selection = { enable = true },
    indent = { 
        enable = true,
        disable = { "html", "xml" },
    },
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
    -- nvim-autopairs
    autopairs = { enable = true },
    -- nvim-ts-autotag
    autotag = {
        enable = true,
        filetypes = { "html", "xml" },
    },
    -- vim-matchup
    matchup = { enable = true },
}

tree_sitter.setup(ts_config)
