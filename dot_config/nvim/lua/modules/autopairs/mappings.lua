local vimp = require'vimp'
local autopairs = require'modules.autopairs'
local opts = {'override', 'silent', 'expr'}

vimp.inoremap(opts, '<CR>', autopairs.confirm) 
