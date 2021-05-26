local K = vim.keymap
local cancel = require'keychord'.cancel

--
-- Standard
--

-- Vim move
K.nnoremap({'<A-j>', ':m .+1<CR>==', silent = true})
K.nnoremap({'<A-k>', ':m .-2<CR>==', silent = true})
K.inoremap({'<A-j>', '<C-O>:m .+1<CR>', silent = true})
K.inoremap({'<A-k>', '<C-O>:m .-2<CR>', silent = true})
K.vnoremap({'<A-j>', ':m \'>+1<CR>==gv', silent = true})
K.vnoremap({'<A-k>', ':m \'<-2<CR>==gv', silent = true})

-- PageUp/PageDown
K.map({'<PageUp>', '<C-b>', silent = true})
K.map({'<PageDown>', '<C-f>', silent = true})
K.imap({'<PageUp>', '<C-O><C-b>', silent = true})
K.imap({'<PageDown>', '<C-O><C-f>', silent = true})

-- Buffer manipulation
local buffer = require'utils.buffer'
K.nnoremap({'<Leader>q', buffer.bufwipeout, silent = true})
K.nnoremap({'<Leader>l', ':e#<CR>', silent = true})

-- Toggle line numbers
K.nnoremap({'<Leader>d', ':set nu! rnu! <CR>', silent = true})

-- Terminal buffer
-- TODO: Use nvim-toggleterm
K.nnoremap({'<Leader><CR>', ':term<CR>', silent = true})
K.tnoremap({'<C-]>', '<C-\\><C-n>', silent = true})

--
-- Lua plugins
--

-- Nvim-compe
K.inoremap({'<CR>', 'compe#complete(\'<CR>\')', silent = true, expr = true})
K.inoremap({'<C-Space>', 'pumvisible() ? compe#close() : compe#complete()', silent = true, expr = true})

K.inoremap({'<TAB>', 'v:lua.require\'modules.compe\'.tab_complete()', silent = true, expr = true})
K.snoremap({'<TAB>', 'v:lua.require\'modules.compe\'.tab_complete()', silent = true, expr = true})

K.inoremap({'<S-TAB>', 'v:lua.require\'modules.compe\'.s_tab_complete()', silent = true, expr = true})
K.snoremap({'<S-TAB>', 'v:lua.require\'modules.compe\'.s_tab_complete()', silent = true, expr = true})

-- Nvim-bufferline.lua
local bline = require'bufferline'
K.nnoremap({'<Leader><Leader>', bline.pick_buffer, silent = true})
K.nnoremap({'<Leader>,', function() bline.cycle(-1) end, silent = true})
K.nnoremap({'<Leader>.', function() bline.cycle(1) end, silent = true})
K.nnoremap({'<Leader><lt>', function() bline.move(-1) end, silent = true})
K.nnoremap({'<Leader>>', function() bline.move(1) end, silent = true})
for i=1,9 do
  K.nnoremap({'<Leader>'..tostring(i), function() bline.go_to_buffer(i) end, silent = true})
end

--  Hop.nvim
local hop = require'hop'
K.nnoremap({'<Leader>]', hop.hint_words, silent = true})
K.nnoremap({'<Leader>[', hop.hint_lines, silent = true})

-- Kommentary
K.nmap({'<C-_>', '<Plug>kommentary_line_default', silent = true })
K.imap({'<C-_>', '<C-O><Plug>kommentary_line_default', silent = true })
K.vmap({'<C-_>', '<Plug>kommentary_visual_default', silent = true })

-- Gitsigns
local gitsigns = require'gitsigns'
K.nnoremap({']g', gitsigns.next_hunk, silent = true})
K.nnoremap({'[g', gitsigns.prev_hunk, silent = true})
K.nnoremap({'<Leader>gp', gitsigns.preview_hunk, silent = true})
K.nnoremap({'<Leader>gs', gitsigns.stage_hunk, silent = true})
K.nnoremap({'<Leader>gu', gitsigns.undo_stage_hunk, silent = true})
K.nnoremap({'<Leader>gR', gitsigns.reset_buffer, silent = true})
K.nnoremap({'<Leader>gb', function() gitsigns.blame_line(true) end, silent = true})

cancel('<Leader>g')

-- Telescope.nvim
local tscope = require'modules.telescope'
-- View help pages
K.nnoremap({'<Leader>h', tscope.help_pages, silent = true})
-- View mappings
K.nnoremap({'<Leader>?', tscope.key_binds, silent = true})
-- Git project files (fallback to cwd)
K.nnoremap({'<Leader>pg', tscope.project_files, silent = true})
-- Live grep cwd
K.nnoremap({'<Leader>pl', tscope.grep_cwd, silent = true})
-- Live grep open buffers
K.nnoremap({'<Leader>po', tscope.grep_buffers, silent = true})
-- Current buffer search
K.nnoremap({'<Leader>pb', tscope.fz_buffer, silent = true})
-- List git commits
K.nnoremap({'<Leader>pc', tscope.git_commits, silent = true})
-- Treesitter picker
K.nnoremap({'<Leader>pt', tscope.treesitter, silent = true})
-- File history picker
K.nnoremap({'<Leader>ph', tscope.old_files, silent = true})
-- Mark picker
K.nnoremap({'<Leader>pm', tscope.bmarks, silent = true})

cancel('<Leader>p')

-- Dial.nvim
K.nmap({'<C-a>', '<Plug>(dial-increment)', silent = true})
K.nmap({'<C-x>', '<Plug>(dial-decrement)', silent = true})
K.vmap({'<C-a>', '<Plug>(dial-increment)', silent = true})
K.vmap({'<C-x>', '<Plug>(dial-decrement)', silent = true})

-- Nvim-reload
--[[ local rld = require'nvim-reload'
nnoremap({'<Leader>r', rld.Reload, silent = true})
nnoremap({'<Leader>R', rld.Restart, silent = false}) ]]

--
-- Vim plugins
--

