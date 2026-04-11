vim.pack.add({ 'https://github.com/nvim-mini/mini.misc' })

require("utils.pack").setup({
  {
    src = "https://github.com/nvim-lua/plenary.nvim",
  },

  {
    src = "https://github.com/neovim/nvim-lspconfig",
    setup = function()
      require("modules.language.servers").setup()
    end,
  },

  {
    src = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  },

  {
    src = "https://github.com/j-hui/fidget.nvim",
    setup = function()
      require("fidget").setup({
        notification = {
          window = {
            winblend = 0,
            relative = "editor",
          },
        },
      })
    end,
  },

  {
    src = "https://github.com/Wansmer/symbol-usage.nvim",
    setup = function()
      require("symbol-usage").setup({ hl = { link = "DiagnosticUnnecessary" } })
    end,
  },

  {
    src = "https://github.com/mfussenegger/nvim-dap",
    setup = function()
      require("modules.language.debuggers").setup()
    end,
  },

  {
    src = "https://github.com/stevearc/conform.nvim",
    setup = function()
      require("modules.language.formatters").setup()
    end,
  },

  {
    src = "https://github.com/mfussenegger/nvim-lint",
    setup = function()
      require("modules.language.linters").setup()
    end,
  },

  {
    src = "https://github.com/b0o/schemastore.nvim",
  },

  {
    src = "https://github.com/lewis6991/hover.nvim",
    setup = function()
      require("hover").config({
        init = function()
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.man")
        end,
        preview_opts = {
          border = nil,
        },
        preview_window = false,
        title = true,
      })
      vim.keymap.set("n", "K", function()
        require("hover").open()
      end, { desc = "hover.nvim (open)" })
      vim.keymap.set("n", "gK", function()
        require("hover").enter()
      end, { desc = "hover.nvim (enter)" })
    end,
  },

  {
    src = "https://github.com/ii14/emmylua-nvim",
  },

  {
    src = "https://github.com/L3MON4D3/LuaSnip",
    setup = function()
      require("modules.snippets")
    end,
  },

  {
    src = "https://github.com/rafamadriz/friendly-snippets",
  },

  {
    src = "https://github.com/kosayoda/nvim-lightbulb",
  },

  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
    data = {
      load = function(plugin)
        vim.opt.rtp:prepend(vim.fs.joinpath(plugin.path, "runtime"))
      end,
      run = function(plugin)
        if not plugin.active then
          vim.cmd.packadd("nvim-treesitter")
        end
        vim.cmd("TSUpdate")
      end,
    },
  },

  {
    src = "https://github.com/monkoose/matchparen.nvim",
    setup = function()
      require("matchparen").setup()
    end,
  },

  {
    src = "https://github.com/mfussenegger/nvim-treehopper",
    setup = function()
      vim.keymap.set({ "o", "x" }, "m", function()
        require("tsht").nodes()
      end, { silent = true })
    end,
  },

  {
    src = "https://github.com/kyazdani42/nvim-web-devicons",
  },

  {
    src = "https://github.com/feline-nvim/feline.nvim",
    setup = function()
      require("modules.feline")
    end,
  },

  {
    src = "https://github.com/ojroques/nvim-osc52",
  },

  {
    src = "https://github.com/tpope/vim-repeat",
  },

  {
    src = "https://github.com/alker0/chezmoi.vim",
  },

  {
    src = "https://github.com/lewis6991/gitsigns.nvim",
    setup = function()
      require("modules.gitsigns")
    end,
  },

  {
    src = "https://github.com/akinsho/git-conflict.nvim",
    setup = function()
      require("git-conflict").setup({
        disable_diagnostics = true,
        highlights = {
          incoming = "DiffIncoming",
          current = "DiffAdd",
        },
      })
      vim.keymap.set("n", "cq", "<cmd>GitConflictListQf<CR>")
    end,
  },

  {
    src = "https://github.com/mcchrish/nnn.vim",
    setup = function()
      require("nnn").setup({
        set_default_mappings = false,
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

  {
    src = "https://github.com/nvim-telescope/telescope.nvim",
    setup = function()
      vim.keymap.set("i", "<C-r>", "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR>")
      vim.keymap.set(
        { "x", "n" },
        '"',
        "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR><Esc>"
      )
      require("modules.telescope")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
    end,
  },

  {
    src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    data = {
      run = function(plugin)
        vim.system({ "make" }, { cwd = plugin.path }):wait()
      end,
    },
  },

  {
    src = "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  },

  {
    src = "https://github.com/chrisgrieser/nvim-spider",
    setup = function()
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>")
      vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>")
    end,
  },

  {
    src = "https://github.com/phaazon/hop.nvim",
    setup = function()
      require("hop").setup({ keys = "asdghklwertyuipzxcvbnmfj" })
    end,
    keys = {
      { mode = "n", lhs = "<Leader>;", rhs = function() vim.cmd.HopWord() end, opts = { silent = true } },
      { mode = "n", lhs = "<Leader>/", rhs = function() vim.cmd.HopPattern() end, opts = { silent = true } },
    },
  },

  {
    src = "https://github.com/mizlan/iswap.nvim",
    keys = {
      { mode = "n", lhs = "gs", rhs = function() vim.cmd.ISwap() end, opts = { silent = true } },
      { mode = "n", lhs = "gS", rhs = function() vim.cmd.ISwapWith() end, opts = { silent = true } },
    },
  },

  {
    src = "https://github.com/machakann/vim-sandwich",
    event = "BufReadPost",
    setup = function()
      vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])
    end,
  },

  {
    src = "https://github.com/monaqa/dial.nvim",
    setup = function()
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

  {
    src = "https://github.com/ram02z/hydra.nvim",
    setup = function()
      require("modules.hydra")
    end,
  },

  {
    src = "https://github.com/sindrets/winshift.nvim",
    setup = function()
      require("winshift").setup()
    end,
  },

  {
    src = "https://github.com/mg979/vim-visual-multi",
    setup = function()
      vim.g.VM_set_statusline = 0
    end,
  },

  {
    src = "https://github.com/booperlv/nvim-gomove",
    setup = function()
      require("gomove").setup()
    end,
  },

  {
    src = "https://github.com/karb94/neoscroll.nvim",
    event = "BufReadPost",
    setup = function()
      require("neoscroll").setup()
    end,
  },

  {
    src = "https://github.com/nacro90/numb.nvim",
    event = "CmdlineEnter",
    setup = function()
      require("numb").setup({ show_cursorline = true })
    end,
  },

  {
    pack = "nvim.undotree",
    keys = {
      {
        mode = "n",
        lhs = "<Leader>ut",
        rhs = function()
          require("undotree").open({ command = "40vnew" })
        end,
        opts = { silent = true },
      },
    },
    setup = function()
      require("utils.keychord").cancel("<Leader>u")
    end,
  },

  {
    src = "https://github.com/romainl/vim-cool",
    event = "InsertEnter,CmdlineEnter",
  },
})