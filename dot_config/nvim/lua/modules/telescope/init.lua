-- Nvim-telescope config

local telescope = require("telescope")
local actions = require("telescope.actions")

local tscope_config = {
  defaults = {
    sorting_strategy = "ascending",

    preview_title = "",

    layout_strategy = "bottom_pane",
    layout_config = {
      height = 13,
    },

    border = true,
    borderchars = {
      "z",
      prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
      results = { " " },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    file_ignore_patterns = { ".backup", ".swap", ".langservers", ".session", ".undo" },
    mappings = {
      i = {
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
      },
      n = {
        ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["<C-d>"] = actions.delete_buffer,
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

telescope.setup(tscope_config)

local tscope = require("modules.telescope.functions")
local cancel = require("utils.keychord").cancel
-- View help pages
vim.keymap.set("n", "<Leader>pm", "<cmd>Telescope help_tags<CR>", { silent = true })
-- Git project files (fall back to cwd)
vim.keymap.set("n", "<Leader>pf", tscope.project_files, { silent = true })
-- Live grep cwd
vim.keymap.set("n", "<Leader>pl", "<cmd>Telescope live_grep<CR>", { silent = true })
-- Buffer picker
vim.keymap.set("n", "<Leader>pb", "<cmd>Telescope buffers<CR>", { silent = true })
-- Live grep open buffers
vim.keymap.set("n", "<Leader>po", "<cmd>Telescope live_grep grep_open_files=true<CR>", { silent = true })
-- List git status
vim.keymap.set("n", "<Leader>pgs", "<cmd>Telescope git_status<CR>", { silent = true })
-- Git branches
vim.keymap.set("n", "<Leader>pgb", "<cmd>Telescope git_branches<CR>", { silent = true })
-- Treesitter picker
vim.keymap.set("n", "<Leader>pt", "<cmd>Telescope treesitter<CR>", { silent = true })
-- Keymaps picker
vim.keymap.set("n", "<Leader>pk", tscope.keymaps, { silent = true })
-- Commands picker
vim.keymap.set("n", "<Leader>pc", tscope.commands, { silent = true })
-- File history picker
vim.keymap.set("n", "<Leader>pr", "<cmd>Telescope oldfiles<CR>", { silent = true })
-- Autocommands picker
vim.keymap.set("n", "<Leader>pa", "<cmd>Telescope autocommands<CR>", { silent = true })
-- View highlights
vim.keymap.set("n", "<Leader>ph", "<cmd>Telescope highlights<CR>", { silent = true })
-- Resume picker
vim.keymap.set("n", "<Leader>p<CR>", "<cmd>Telescope resume<CR>", { silent = true })
vim.keymap.set("n",
  "<Leader>ps",
  "<cmd>Telescope spell_suggest theme=get_cursor layout_config={height=6}<CR>",
  { silent = true }
)

cancel("<Leader>p")
