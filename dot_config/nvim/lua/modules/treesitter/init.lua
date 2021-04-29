-- TreeSitter Config
local tree_sitter = require('nvim-treesitter.configs')

-- Folding
-- vim.api.nvim_set_option("foldmethod","expr")
-- vim.api.nvim_set_option("foldexpr", "nvim_treesitter#foldexpr()")

local ts_config = {
    ensure_installed = 'maintained',
    highlight = { 
        enable = true,
        disable = { "html", "xml"},
        additional_vim_regex_highlighting = true,
        language_tree = true,
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
}

tree_sitter.setup(ts_config)
