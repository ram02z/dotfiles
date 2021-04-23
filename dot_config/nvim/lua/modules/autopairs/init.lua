-- pears.nvim config
-- local pears = require('pears')
--
-- pears.setup(function(conf)
    -- conf.on_insert_enter(function(exec)
        -- if vim.fn.pumvisible() == 1 then
            -- vim.fn["compe#confirm"]("<CR>")
        -- else
            -- exec()
        -- end
    -- end)
-- end)

-- nvim-autopairs config

local autopairs = require'nvim-autopairs'


autopairs.setup({
    check_ts = true,
    check_line_pair = false,
})

local M = {}

M.confirm = function()
  autopairs.check_break_line_char()
end

return M
