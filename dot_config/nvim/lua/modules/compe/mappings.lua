local vimp = require'vimp'
local opts = {'override', 'silent', 'expr'}

vimp.inoremap(opts, '<CR>', 'compe#confirm(\'<CR>\')')

vimp.inoremap(opts, '<C-Space>', 'pumvisible() ? compe#close() : compe#complete()')

vimp.inoremap(opts, '<TAB>', 'v:lua.tab_complete()')
vimp.snoremap(opts, '<TAB>', 'v:lua.tab_complete()')

vimp.inoremap(opts, '<S-TAB>', 'v:lua.s_tab_complete()')
vimp.snoremap(opts, '<S-TAB>', 'v:lua.s_tab_complete()')
