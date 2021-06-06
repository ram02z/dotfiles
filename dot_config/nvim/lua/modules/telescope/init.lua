-- Nvim-telescope config
if not packer_plugins['plenary.nvim'].loaded then
  vim.cmd [[packadd plenary.nvim]]
  vim.cmd [[packadd popup.nvim]]
end

local telescope = require('telescope')

local tscope_config = {
  defaults = {
    layout_strategy = 'flex',
    scroll_strategy = 'cycle',
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_ignore_patterns = {".backup",".swap",".langservers",".session",".undo","GITCOMMMIT"},
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    frecency = {
      show_scores = true,
      show_unindexed = true,
      ignore_patterns = {"*.git/*", "*/tmp/*"},
      workspaces = {
        ["conf"]    = vim.fn.expand("~/.config"),
        ["czm"]    = vim.fn.expand("~/.local/share/chezmoi/dot_config"),
      }
    }
  },
}

telescope.setup(tscope_config)

local tscope = require'modules.telescope.functions'
local cancel = require'keychord'.cancel
-- View help pages
vim.keymap.nnoremap({'<Leader>pm', ':Telescope help_tags<CR>' , silent = true})
-- Git project files (fallback to cwd)
vim.keymap.nnoremap({'<Leader>pg', tscope.project_files, silent = true})
-- Live grep cwd
vim.keymap.nnoremap({'<Leader>pl', tscope.grep_cwd, silent = true})
-- Live grep open buffers
vim.keymap.nnoremap({'<Leader>po', tscope.grep_buffers, silent = true})
-- Current buffer search
vim.keymap.nnoremap({'<Leader>pb', ':Telescope current_buffer_fuzzy_find<CR>', silent = true})
-- List git status
vim.keymap.nnoremap({'<Leader>ps', ':cd %:p:h | Telescope git_status<CR>', silent = true})
-- Git branches
vim.keymap.nnoremap({'<Leader>pgb', ':cd %:p:h | Telescope git_branches<CR>', silent = true})
-- Treesitter picker
vim.keymap.nnoremap({'<Leader>pt', ':Telescope treesitter<CR>', silent = true})
-- Keymaps picker
vim.keymap.nnoremap({'<Leader>pk', ':Telescope keymaps<CR>', silent = true})
-- Commands picker
vim.keymap.nnoremap({'<Leader>pc', ':Telescope commands<CR>', silent = true})
-- File history picker (using frecency)
vim.keymap.nnoremap({'<Leader>ph', tscope.old_files, silent = true})
-- Packer plugin
vim.keymap.nnoremap({'<Leader>pp', telescope.extensions.packer.plugins, silent = true})

cancel('<Leader>p')
