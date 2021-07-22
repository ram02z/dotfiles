-- Nvim-telescope config
-- if not packer_plugins['popup.nvim'].loaded then
--   vim.cmd [[packadd plenary.nvim]]
--   vim.cmd [[packadd popup.nvim]]
-- end

local telescope = require('telescope')
local actions = require("telescope.actions")

local tscope_config = {
  defaults = {
    layout_strategy = 'flex',
    scroll_strategy = 'cycle',
    layout_config = {
      width = 0.9
    },
    file_ignore_patterns = {'.backup','.swap','.langservers','.session','.undo'},
    mappings = {
      i = {
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        ['<C-Down>'] = require'telescope.actions'.cycle_history_next,
        ['<C-Up>'] = require'telescope.actions'.cycle_history_prev,
      },
      n = {
        ['<C-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}

telescope.setup(tscope_config)

local tscope = require'modules.telescope.functions'
local cancel = require'keychord'.cancel
-- View help pages
vim.keymap.nnoremap({'<Leader>pm', '<cmd>Telescope help_tags<CR>' , silent = true})
-- Git project files (fall back to cwd)
vim.keymap.nnoremap({'<Leader>pf', tscope.project_files, silent = true})
-- Live grep cwd
vim.keymap.nnoremap({'<Leader>pl', tscope.grep_cwd, silent = true})
-- Live grep open buffers
vim.keymap.nnoremap({'<Leader>po', tscope.grep_buffers, silent = true})
-- List git status
vim.keymap.nnoremap({'<Leader>pgs', '<cmd>Telescope git_status<CR>', silent = true})
-- Git branches
vim.keymap.nnoremap({'<Leader>pgb', '<cmd>Telescope git_branches<CR>', silent = true})
-- Treesitter picker
vim.keymap.nnoremap({'<Leader>pt', '<cmd>Telescope treesitter<CR>', silent = true})
-- Keymaps picker
vim.keymap.nnoremap({'<Leader>pk', '<cmd>Telescope keymaps<CR>', silent = true})
-- Commands picker
vim.keymap.nnoremap({'<Leader>pc', '<cmd>Telescope commands<CR>', silent = true})
-- File history picker
vim.keymap.nnoremap({'<Leader>pr', '<cmd>Telescope oldfiles<CR>', silent = true})
-- Autocommands picker
vim.keymap.nnoremap({'<Leader>pa', '<cmd>Telescope autocommands<CR>', silent = true})
-- View highlights
vim.keymap.nnoremap({'<Leader>ph', '<cmd>Telescope highlights<CR>', silent = true})

cancel('<Leader>p')
