-- TreeSitter Config
local tree_sitter = require("nvim-treesitter.configs")

-- Folding
-- vim.api.nvim_set_option("foldmethod","expr")
-- vim.api.nvim_set_option("foldexpr", "nvim_treesitter#foldexpr()")
local ts_config = {
  -- ensure_installed = 'maintained',
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  -- Disabled until merge
  -- https://github.com/nvim-treesitter/nvim-treesitter/pull/1127
  indent = {
    enable = false,
    disable = { "html", "xml" },
  },
  refactor = {
    highlight_definitions = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        -- goto_definition_lsp_fallback = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "[r",
        goto_previous_usage = "]r",
      },
    },
  },
  -- textobjects
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["ac"] = "@comment.outer",
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
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
    termcolors = {
      "Blue",
      "Green",
      "Magenta",
      "White",
      "Red",
      "Yellow",
      "Cyan",
    },
    extended_mode = true,
    max_file_lines = 2500,
  },
  -- vim-matchup
  matchup = {
    enable = true,
  },
  -- Query linter
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
}

tree_sitter.setup(ts_config)
