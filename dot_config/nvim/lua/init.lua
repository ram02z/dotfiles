-- TODO: Split file into multiple config files
-- Colorizer setup
local colorizer = require('colorizer')

local colorizer_opts = {
    RGB = true;
    RRGGBB = true;
    RRGGBBAA = true;
    css_fn = true;
}

-- init colorizer
colorizer.setup(_, colorizer_opts)

-- Compe setup
-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noinsert,noselect"

-- Avoid showing extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

local compe = require('compe')

local compe_conf = {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 2,
    preselect = 'enable',

    source = {
        path = true,
        calc = true,
        -- vsnip = true,
        nvim_lsp = true,
        nvim_lua = true,
        -- snippets_nvim = true,
        ultisnips = true,
        treesitter = true,
    },
}

-- init compe
compe.setup(compe_conf)


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
}

tree_sitter.setup(ts_config)

-- LSP config
local nvim_lsp = require('lspconfig')
-- TODO: Add LSPs
