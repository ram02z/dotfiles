local vimp = require'vimp'
local opts = {'override', 'silent'}

-- nnoremap <silent> <Leader>] :HopWord<CR>
vimp.nnoremap(opts, '<Leader>]', ':HopWord<CR>')

-- nnoremap <silent> <Leader>[ :HopLine<CR>
vimp.nnoremap(opts, '<Leader>[', ':HopLine<CR>')
