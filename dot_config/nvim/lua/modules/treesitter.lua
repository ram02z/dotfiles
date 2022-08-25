-- TreeSitter Config
local tree_sitter = require("nvim-treesitter.configs")

local ts_config = {
  -- ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = { "html" },
    -- additional_vim_regex_highlighting = true,
  },
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     init_selection = "gnn",
  --     node_incremental = "grn",
  --     scope_incremental = "grc",
  --     node_decremental = "grm",
  --   },
  -- }
  -- NOTE: testing this after #2275
  -- indent = {
  --   enable = true,
  --   disable = { "html", "xml" },
  -- },
  -- refactor = {
  --   highlight_definitions = { enable = true },
  --   smart_rename = {
  --     enable = true,
  --     keymaps = {
  --       smart_rename = "grr",
  --     },
  --   },
  --   navigation = {
  --     enable = true,
  --     keymaps = {
  --       -- goto_definition_lsp_fallback = "gnd",
  --       list_definitions = "gnD",
  --       list_definitions_toc = "gO",
  --       goto_next_usage = "[r",
  --       goto_previous_usage = "]r",
  --     },
  --   },
  -- },
  -- vim-matchup
  -- matchup = {
  --   enable = true,
  -- },
  -- Query linter
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite" },
  },
  -- pairs
  pairs = {
    enable = true,
    disable = {},
    highlight_pair_events = { "CursorHoldI", "CursorHold" },
    highlight_self = true, -- whether to highlight also the part of the pair under cursor (or only the partner)
    goto_right_end = true, -- whether to go to the end of the right partner or the beginning
    fallback_cmd_normal = "",
    keymaps = {
      goto_partner = "<leader>%",
    },
  },
}

require("nvim-treesitter.install").compilers = { "clang", "gcc", "cc" }

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

parser_configs.norg_meta = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    files = { "src/parser.c" },
    branch = "main",
  },
}

parser_configs.norg_table = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    files = { "src/parser.c" },
    branch = "main",
  },
}
tree_sitter.setup(ts_config)
