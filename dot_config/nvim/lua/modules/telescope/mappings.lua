local vimp = require'vimp'
local tscope = require'modules.telescope'

-- Mappings

-- View help pages
vimp.nnoremap({'silent'}, '<Leader>h', tscope.help_pages)

-- View mappings
vimp.nnoremap({'silent'}, '<Leader>?', tscope.key_binds)

-- Project files via git fallback to cwd
vimp.nnoremap({'silent'}, '<Leader>pg', tscope.project_files)

-- Live grep cwd
vimp.nnoremap({'silent'}, '<Leader>pl', tscope.grep_cwd)

-- Live grep open files
vimp.nnoremap({'silent'}, '<Leader>po', tscope.grep_buffers)

-- Current buffer search
vimp.nnoremap({'silent'}, '<Leader>pb', tscope.fz_buffer)

-- List git commits
vimp.nnoremap({'silent'}, '<Leader>pc', tscope.git_commits)
