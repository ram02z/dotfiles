local vimp = require'vimp'
local opts = {'override', 'silent', 'expr'}

vimp.inoremap(opts, '<CR>', 'compe#confirm(\'<CR>\')')

vimp.inoremap(opts, '<C-Space>', 'compe#complete()')

vimp.inoremap(opts, '<C-e>', 'compe#close(\'<C-e>\')')

vimp.inoremap(opts, '<TAB>', 'pumvisible() ? "\\<C-n>" : "\\<TAB>"')

vimp.inoremap(opts, '<S-TAB>', 'pumvisible() ? "\\<C-p>" : "\\<C-d>"')
