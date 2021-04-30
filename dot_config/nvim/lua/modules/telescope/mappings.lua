local vimp = require'vimp'
local tscope = require'modules.telescope'
local opts = {'override', 'silent'}

-- Mappings

-- View help pages
vimp.nnoremap(opts, '<Leader>h', tscope.help_pages)

-- View mappings
vimp.nnoremap(opts, '<Leader>?', tscope.key_binds)

-- Project files via git fallback to cwd
vimp.nnoremap(opts, '<Leader>pg', tscope.project_files)

-- Live grep cwd
vimp.nnoremap(opts, '<Leader>pl', tscope.grep_cwd)

-- Live grep open files
vimp.nnoremap(opts, '<Leader>po', tscope.grep_buffers)

-- Current buffer search
vimp.nnoremap(opts, '<Leader>pb', tscope.fz_buffer)

-- List git commits
vimp.nnoremap(opts, '<Leader>pc', tscope.git_commits)

-- Treesitter picker
vimp.nnoremap(opts, '<Leader>pt', tscope.treesitter)

-- Register picker
vimp.nnoremap(opts, '<Leader>pr', tscope.registers)

-- File history picker
vimp.nnoremap(opts, '<Leader>ph', tscope.old_files)

-- Mark picker
vimp.nnoremap(opts, '<Leader>pm', tscope.bmarks)
