-- TreeSitter Config
local tree_sitter = require('nvim-treesitter.configs')

-- Folding
-- vim.api.nvim_set_option("foldmethod","expr")
-- vim.api.nvim_set_option("foldexpr", "nvim_treesitter#foldexpr()")
local ts_config = {
  -- ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = { "html", "xml"},
    additional_vim_regex_highlighting = true,
    language_tree = true,
  },
  incremental_selection = { enable = true },
  -- Disabled until merge
  -- https://github.com/nvim-treesitter/nvim-treesitter/pull/1127
  indent = {
    enable = false,
    disable = { "html", "xml" },
  },
  refactor = {
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      }
    },
    navigation = {
      enable = true,
      keymaps = {
          goto_definition = "gnd",
          list_definitions = "gnD",
          list_definitions_toc = "gO",
          goto_next_usage = "[d",
          goto_previous_usage = "]d",
      },
    },
  },
  -- nvim-ts-rainbow
  rainbow = {
    enable = true,
    colors = {
      "#1795FD",
      "#43A64B",
      "#911EA3",
      "#FE6C7F",
      "#C7005C",
      "#DEA727",
      "#85E7FF",
    },
    -- extended_mode = true,
    -- max_file_lines = 200,
  },
  -- vim-matchup
  matchup = {
    enable = true
  }
}

tree_sitter.setup(ts_config)
