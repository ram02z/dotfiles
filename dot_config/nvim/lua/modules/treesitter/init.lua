-- TreeSitter Config
local tree_sitter = require('nvim-treesitter.configs')

-- Folding
-- vim.api.nvim_set_option("foldmethod","expr")
-- vim.api.nvim_set_option("foldexpr", "nvim_treesitter#foldexpr()")

local ts_config = {
    -- ensure_installed = 'maintained',
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
    -- nvim-ts-rainbow
    rainbow = {
        enable = true,
        -- extended_mode = true,
        max_file_lines = 1000,
    },
}

tree_sitter.setup(ts_config)

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.fish = {
  install_info = {
    url = "https://github.com/krnik/tree-sitter-fish.git", -- local path or git repo
    files = {"src/parser.c", "src/scanner.c"}
  },
  filetype = "fish", -- if filetype does not agrees with parser name
}
