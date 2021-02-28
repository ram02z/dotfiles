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

-- LSP config
local nvim_lsp = require('lspconfig')
-- TODO: Add LSPs
