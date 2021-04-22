-- pears.nvim config
local pears = require('pears')

pears.setup(function(conf)
    conf.on_insert_enter(function(exec)
        if vim.fn.pumvisible() == 1 then
            vim.fn["compe#confirm"]("<CR>")
        else
            exec()
        end
    end)
end)
