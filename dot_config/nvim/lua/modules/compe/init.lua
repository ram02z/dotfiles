-- Compe setup
-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noselect"

-- Avoid showing extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

local compe = require('compe')

local compe_conf = {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 2,
    preselect = 'enable',
    allow_prefix_unmatch = false,

    source = {
        path = true,
        -- calc = true,
        vsnip = true,
        nvim_lsp = true,
        nvim_lua = true,
        -- snippets_nvim = true,
        -- ultisnips = true,
        treesitter = true,
    },
}

-- init compe
compe.setup(compe_conf)

