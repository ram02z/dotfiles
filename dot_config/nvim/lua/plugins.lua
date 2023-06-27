return {
  -- Common dependencies
  {
    "nvim-lua/plenary.nvim",
    config = function()
      require("plenary.filetype").add_file("extra")
    end,
  },

  --
  -- LSP, treesitter and completion
  --
  {
    "neovim/nvim-lspconfig",
    init = function()
      require("modules.lsp").setup_servers()
    end,
  },

  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",

  {
    "j-hui/fidget.nvim",
    init = function()
      require("fidget").setup({
        window = {
          blend = 0,
        },
      })
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    init = function()
      require("modules.lsp.null_ls")
    end,
  },

  "b0o/schemastore.nvim",

  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    init = function()
      vim.keymap.set("n", "<Leader>a", "<cmd>AerialToggle<CR>", { silent = true })
    end,
    config = function()
      require("aerial").setup({
        nerd_font = false,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "jc-doyle/cmp-pandoc-references" },
    },
    init = function()
      require("modules.cmp")
    end,
  },

  "ii14/emmylua-nvim",

  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("modules.snippets")
    end,
  },

  "rafamadriz/friendly-snippets",

  "kosayoda/nvim-lightbulb",

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = function()
      require("modules.treesitter")
    end,
  },

  {
    -- "~/src/dev-comments.nvim",
    "ram02z/dev-comments.nvim",
    init = function()
      require("dev_comments").setup()
    end,
  },

  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    init = function()
      vim.keymap.set("n", "<Leader>tp", "<cmd>TSPlaygroundToggle<CR>", { silent = true })
      vim.keymap.set("n", "<Leader>th", "<cmd>TSHighlightCapturesUnderCursor<CR>", { silent = true })
    end,
    config = function()
      require("utils.keychord").cancel("<Leader>t")
    end,
  },

  {
    "monkoose/matchparen.nvim",
    init = function()
      require("matchparen").setup({})
    end,
  },

  {
    "ram02z/nvim-treesitter-pairs",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },

  {
    "mfussenegger/nvim-treehopper",
    init = function()
      vim.keymap.set({ "o", "x" }, "m", ":lua require'tsht'.nodes()<CR>", { silent = true })
    end,
  },

  --
  -- UI
  --

  -- Icons
  "kyazdani42/nvim-web-devicons",

  -- Statusline
  {
    "feline-nvim/feline.nvim",
    init = function()
      require("modules.feline")
    end,
  },

  --
  -- Misc
  --

  -- OSC52 yank
  "ojroques/nvim-osc52",

  -- Wrapper around codicons
  "mortepau/codicons.nvim",

  -- Repeat support
  "tpope/vim-repeat",

  --
  -- Language support
  --

  "alker0/chezmoi.vim",

  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    config = function()
      require("mkdnflow").setup({
        to_do = {
          symbols = { " ", "x", " " },
          complete = "x",
        },
        mappings = {
          MkdnEnter = false,
          MkdnCreateLinkFromClipboard = false,
          MkdnNextLink = { "n", "]l" },
          MkdnPrevLink = { "n", "[l" },
          MkdnTableNextCell = false,
          MkdnTablePrevCell = false,
          MkdnUpdateNumbering = false,
        },
      })
    end,
  },

  {
    "AckslD/nvim-FeMaco.lua",
    cmd = "FeMaco",
    init = function()
      vim.keymap.set("n", "<Leader>m", "<cmd>FeMaco<CR>")
    end,
    config = function()
      require("femaco").setup({
        prepare_buffer = function(opts)
          vim.cmd("belowright split")
          local win = vim.api.nvim_get_current_win()
          local buf = vim.api.nvim_create_buf(false, false)
          return vim.api.nvim_win_set_buf(win, buf)
        end,
      })
    end,
  },

  -- Tex support
  {
    "lervag/vimtex",
    ft = "tex",
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_syntax_enabled = 0
      vim.g.vimtex_view_method = "zathura"
      vim.g.tex_conceal = "abdmg"
      vim.g.vimtex_matchparen_enabled = 0
    end,
  },

  -- SQL
  "nanotee/sqls.nvim",

  -- Comment snippets
  {
    "danymat/neogen",
    cmd = "Neogen",
    config = function()
      require("neogen").setup({ snippet_engine = "luasnip" })
    end,
  },

  -- Git integration
  {
    "rhysd/committia.vim",
    event = "BufReadPost COMMIT_EDITMSG,MERGE_MSG",
  },
  {
    "lewis6991/gitsigns.nvim",
    init = function()
      require("modules.gitsigns")
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = 'BufReadPost',
    init = function()
      require("git-conflict").setup({
        disable_diagnostics = true,
        highlights = {
          -- FIXME: lazy loads before colorscheme highlights
          -- incoming = "DiffIncoming",
          current = "DiffAdd",
        },
      })
      vim.keymap.set("n", "cq", "<cmd>GitConflictListQf<CR>")
    end,
  },

  -- Toggle terminal
  {
    "akinsho/toggleterm.nvim",
    init = function()
      vim.api.nvim_create_user_command("Ca", "TermExec cmd='chezmoi apply'", {})
      vim.cmd([[cabbrev ca Ca]])
      require("toggleterm").setup({
        shell = "/usr/bin/env fish",
        open_mapping = [[<C-/>]],
      })
    end,
  },

  -- File manager
  {
    "mcchrish/nnn.vim",
    init = function()
      require("nnn").setup({
        set_default_mappings = false,
        -- NOTE: might not work because we are using bash as shell
        -- command = 'n',
        action = {
          ["<c-t>"] = "tab split",
          ["<c-s>"] = "split",
          ["<c-v>"] = "vsplit",
        },
        layout = {
          window = {
            width = 0.9,
            height = 0.6,
            highlight = "FloatBorder",
          },
        },
        replace_netrw = true,
        statusline = false,
      })
      vim.keymap.set("", "<Leader>n", "<cmd>NnnPicker<CR>", { silent = true })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    init = function()
      require("telescope").load_extension("fzf")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    init = function()
      -- Register pickers
      vim.keymap.set("i", "<C-r>", "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR>")
      vim.keymap.set({ "x", "n" }, '"', "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR><Esc>")
    end,
    config = function()
      require("modules.telescope")
    end,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    init = function()
      require("telescope").load_extension("ui-select")
    end,
  },

  -- Extends f/t motions
  {
    "rhysd/clever-f.vim",
    event = "BufReadPost",
    init = function()
      vim.g.clever_f_smart_case = 1
      vim.g.clever_f_chars_match_any_signs = "#"
      vim.g.clever_f_fix_key_direction = 1
      vim.g.clever_f_mark_direct = 1
    end,
    config = function()
      vim.keymap.set("", ";", "<Plug>(clever-f-repeat-forward)", { silent = true })
      vim.keymap.set("", ",", "<Plug>(clever-f-repeat-back)", { silent = true })
      -- FIXME: Issue #61
      vim.keymap.set("n", "<Esc>", "<Plug>(clever-f-reset)<cmd>nod<CR>", { silent = true })
    end,
  },

  -- Jump anywhere on screen
  {
    "phaazon/hop.nvim",
    cmd = { "HopWord", "HopPattern" },
    init = function()
      vim.keymap.set("n", "<Leader>;", "<cmd>HopWord<CR>", { silent = true })
      vim.keymap.set("n", "<Leader>/", "<cmd>HopPattern<CR>", { silent = true })
    end,
    config = function()
      require("hop").setup({ keys = "asdghklwertyuipzxcvbnmfj" })
    end,
  },

  {
    "Wansmer/treesj",
    init = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "*",
        callback = function()
          local opts = { buffer = true }
          local langs = require("treesj.langs")["presets"]
          if langs[vim.bo.filetype] then
            vim.keymap.set("n", "gJ", "<Cmd>TSJSplit<CR>", opts)
            vim.keymap.set("n", "J", "<Cmd>TSJJoin<CR>", opts)
          end
        end,
      })
      require("treesj").setup({ use_default_keymaps = false })
    end,
  },

  -- Swap delimiter seperated items
  {
    "mizlan/iswap.nvim",
    cmd = { "ISwap", "ISwapWith" },
    init = function()
      vim.keymap.set("n", "gs", "<cmd>ISwap<CR>", { silent = true })
      vim.keymap.set("n", "gS", "<cmd>ISwapWith<CR>", { silent = true })
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    init = function()
      local ft = require("Comment.ft")
      ft.dosini = "#%s"
      require("Comment").setup({
        ignore = "^$",
      })
    end,
  },

  -- Manipulate pairs
  {
    "machakann/vim-sandwich",
    event = "BufReadPost",
    config = function()
      vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])
    end,
  },

  -- Color highlighting
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = false,
          RRGGBB = true,
          RRGGBBAA = true,
          css_fn = true,
          names = false,
          mode = "virtualtext",
          virtualtext = "■",
        },
      })
    end,
  },

  -- Increment/decrement
  {
    "monaqa/dial.nvim",
    init = function()
      local augend = require("dial.augend")

      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal_int,
          augend.semver.alias.semver,
          augend.constant.new({
            elements = { "true", "false" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "True", "False" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          }),
        },
        visual = {
          augend.integer.new({
            radix = 16,
            prefix = "0x",
            natural = true,
            case = "upper",
          }),
        },
      })
      vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { silent = true })
      vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { silent = true })
      vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { silent = true })
      vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { silent = true })
    end,
  },

  -- Emacs hydra for neovim
  {
    "anuvyklack/hydra.nvim",
    commit = "928855b69f55c7abcaa6594d20968c33ab2317e6",
    init = function()
      require("modules.hydra")
    end,
  },

  {
    "anuvyklack/windows.nvim",
    dependencies = { "anuvyklack/middleclass" },
    init = function()
      require("windows").setup()
    end,
  },

  -- Window shift
  {
    "sindrets/winshift.nvim",
    cmd = "WinShift",
    config = function()
      require("winshift").setup()
    end,
  },

  -- Multiple cursors
  {
    "mg979/vim-visual-multi",
    keys = {
      "<c-down>",
      { "<c-n>", mode = "n" },
      { "<c-n>", mode = "x" },
      "<c-up",
    },
    init = function()
      vim.g.VM_set_statusline = 0
    end,
  },

  -- Text manipulation
  {
    "booperlv/nvim-gomove",
    init = function()
      require("gomove").setup()
    end,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "BufReadPost",
    config = function()
      require("neoscroll").setup()
    end,
  },

  -- Peek at lines
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = function()
      require("numb").setup({ show_cursorline = true })
    end,
  },

  -- Undo tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
      vim.g.undotree_SplitWidth = 40
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_DiffAutoOpen = 0
      vim.keymap.set("n", "<Leader>ut", "<cmd>UndotreeToggle<CR>", { silent = true })
    end,
    config = function()
      require("utils.keychord").cancel("<Leader>u")
    end,
  },

  -- Remove annoying search highlighting
  {
    "romainl/vim-cool",
    event = { "InsertEnter", "CmdlineEnter" },
  },

  -- Quickfix helper
  {
    "kevinhwang91/nvim-bqf",
    event = { "FileType qf", "QuickFixCmdPre" },
    config = function()
      require("bqf").setup({
        preview = {
          auto_preview = false,
          delay_syntax = 0,
        },
      })
    end,
  },

  -- Profiling
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },
}
