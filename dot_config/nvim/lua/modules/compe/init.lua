-- Compe setup
-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noselect"

-- Avoid showing extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

-- Limit menu items to 5
vim.o.pumheight = 5

local compe = require('compe')

local compe_conf = {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    allow_prefix_unmatch = false,
    throttle_time = 80,
    score_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = true,
        calc = true,
        buffer = true,
        vsnip = true,
        nvim_lsp = true,
        -- tag = true,
        -- treesitter = true,
    },
}

-- init compe
compe.setup(compe_conf)

