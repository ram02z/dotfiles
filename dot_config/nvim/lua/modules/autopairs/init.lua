-- pears.nvim config
local pears = require('pears')

pears.setup(function(conf)
    conf.preset "tag_matching"
    conf.on_enter(function(pear_handle)
        if vim.fn.pumvisible() == 1  and vim.fn.complete_info().selected ~= -1 then
            vim.api.nvim_feedkeys(vim.fn["compe#confirm"]("<CR>"), "n", true)
        else
            pear_handle()
        end
    end)
end)

-- nvim-autopairs config

-- local autopairs = require'nvim-autopairs'
--
--
-- autopairs.setup({
    -- check_ts = true,
    -- check_line_pair = false,
-- })
--
-- local M = {}
--
-- M.confirm = function()
  -- autopairs.check_break_line_char()
-- end
--
-- return M
