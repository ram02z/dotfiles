local map = vim.keymap.map
local nnoremap = vim.keymap.nnoremap
local nmap = vim.keymap.nmap
local inoremap = vim.keymap.inoremap
local imap = vim.keymap.imap
local snoremap = vim.keymap.snoremap
local vnoremap = vim.keymap.vnoremap
local vmap = vim.keymap.vmap
local cancel = require'keychord'.cancel

--
-- Standard
--

-- Vim move
nnoremap({'<A-j>', ':m .+1<CR>==', silent = true})
nnoremap({'<A-k>', ':m .-2<CR>==', silent = true})
inoremap({'<A-j>', '<C-O>:m .+1<CR>', silent = true})
inoremap({'<A-k>', '<C-O>:m .-2<CR>', silent = true})
vnoremap({'<A-j>', ':m \'>+1<CR>==gv', silent = true})
vnoremap({'<A-k>', ':m \'<-2<CR>==gv', silent = true})

-- PageUp/PageDown
map({'<PageUp>', '<C-b>', silent = true})
map({'<PageDown>', '<C-f>', silent = true})
imap({'<PageUp>', '<C-O><C-b>', silent = true})
imap({'<PageDown>', '<C-O><C-f>', silent = true})

-- Buffer manipulation
local buffer = require'utils.buffer'
nnoremap({'<Leader>q', buffer.bufwipeout, silent = true})
nnoremap({'<Leader>l', ':e#<CR>', silent = true})

-- Toggle line numbers
nnoremap({'<Leader>d', ':set nu! rnu! <CR>', silent = true})

-- Create terminal buffer
-- TODO: Use nvim-toggleterm
nnoremap({'<Leader><CR>', ':term<CR>', silent = true})


--
-- Lua plugins
--

-- Nvim-compe
inoremap({'<CR>', 'compe#complete(\'<CR>\')', silent = true, expr = true})
inoremap({'<C-Space>', 'pumvisible() ? compe#close() : compe#complete()', silent = true, expr = true})

inoremap({'<TAB>', 'v:lua.require\'modules.compe\'.tab_complete()', silent = true, expr = true})
snoremap({'<TAB>', 'v:lua.require\'modules.compe\'.tab_complete()', silent = true, expr = true})

inoremap({'<S-TAB>', 'v:lua.require\'modules.compe\'.s_tab_complete()', silent = true, expr = true})
snoremap({'<S-TAB>', 'v:lua.require\'modules.compe\'.s_tab_complete()', silent = true, expr = true})

-- Nvim-bufferline.lua
local bline = require'bufferline'
nnoremap({'<Leader><Leader>', bline.pick_buffer, silent = true})
nnoremap({'<Leader>,', function() bline.cycle(-1) end, silent = true})
nnoremap({'<Leader>.', function() bline.cycle(1) end, silent = true})
nnoremap({'<Leader><lt>', function() bline.move(-1) end, silent = true})
nnoremap({'<Leader>>', function() bline.move(1) end, silent = true})
for i=1,9 do
  nnoremap({'<Leader>'..tostring(i), function() bline.go_to_buffer(i) end, silent = true})
end

--  Hop.nvim
local hop = require'hop'
nnoremap({'<Leader>]', hop.hint_words, silent = true})
nnoremap({'<Leader>[', hop.hint_lines, silent = true})

-- Kommentary
nmap({'<C-_>', '<Plug>kommentary_line_default', silent = true })
imap({'<C-_>', '<C-O><Plug>kommentary_line_default', silent = true })
vmap({'<C-_>', '<Plug>kommentary_visual_default', silent = true })

-- Gitsigns
local gitsigns = require'gitsigns'
nnoremap({']g', gitsigns.next_hunk, silent = true})
nnoremap({'[g', gitsigns.prev_hunk, silent = true})
nnoremap({'<Leader>gp', gitsigns.preview_hunk, silent = true})
nnoremap({'<Leader>gs', gitsigns.stage_hunk, silent = true})
nnoremap({'<Leader>gu', gitsigns.undo_stage_hunk, silent = true})
nnoremap({'<Leader>gR', gitsigns.reset_buffer, silent = true})
nnoremap({'<Leader>gb', function() gitsigns.blame_line(true) end, silent = true})

cancel('<Leader>g')

-- Telescope.nvim
local tscope = require'modules.telescope'
-- View help pages
nnoremap({'<Leader>h', tscope.help_pages, silent = true})
-- View mappings
nnoremap({'<Leader>?', tscope.key_binds, silent = true})
-- Git project files (fallback to cwd)
nnoremap({'<Leader>pg', tscope.project_files, silent = true})
-- Live grep cwd
nnoremap({'<Leader>pl', tscope.grep_cwd, silent = true})
-- Live grep open buffers
nnoremap({'<Leader>po', tscope.grep_buffers, silent = true})
-- Current buffer search
nnoremap({'<Leader>pb', tscope.fz_buffer, silent = true})
-- List git commits
nnoremap({'<Leader>pc', tscope.git_commits, silent = true})
-- Treesitter picker
nnoremap({'<Leader>pt', tscope.treesitter, silent = true})
-- File history picker
nnoremap({'<Leader>ph', tscope.old_files, silent = true})
-- Mark picker
nnoremap({'<Leader>pm', tscope.bmarks, silent = true})

cancel('<Leader>p')

-- Dial.nvim
nmap({'<C-a>', '<Plug>(dial-increment)', silent = true})
nmap({'<C-x>', '<Plug>(dial-decrement)', silent = true})
vmap({'<C-a>', '<Plug>(dial-increment)', silent = true})
vmap({'<C-x>', '<Plug>(dial-decrement)', silent = true})

-- Nvim-reload
--[[ local rld = require'nvim-reload'
nnoremap({'<Leader>r', rld.Reload, silent = true})
nnoremap({'<Leader>R', rld.Restart, silent = false}) ]]

--
-- Vim plugins
--

