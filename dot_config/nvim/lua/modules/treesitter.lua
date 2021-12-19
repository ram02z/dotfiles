-- TreeSitter Config
local tree_sitter = require("nvim-treesitter.configs")

local ts_config = {
  -- ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = { "html", "markdown" },
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
  -- },
  -- Disabled until merge
  -- https://github.com/nvim-treesitter/nvim-treesitter/pull/1127
  indent = {
    enable = false,
    disable = { "html", "xml" },
  },
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
  matchup = {
    enable = true,
  },
  -- Query linter
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite" },
  },
}

require("nvim-treesitter.install").compilers = { "clang", "gcc", "cc" }

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

parser_configs.norg = {
  install_info = {
    url = "https://github.com/vhyrro/tree-sitter-norg",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
  },
}

tree_sitter.setup(ts_config)
