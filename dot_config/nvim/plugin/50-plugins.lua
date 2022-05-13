-- Install packer
local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
execute("packadd packer.nvim")
-- NOTE: can fail on before installed
-- pcall(execute, "packadd chezmoi.vim")

local packer = require("packer")

vim.keymap.set("", "<C-S>", packer.sync, { silent = true, desc = "Sync packer" })

packer.startup({
  function(use)
    use({
      "wbthomason/packer.nvim",
      opt = true,
    })

    -- Common dependancies
    use({
      "nvim-lua/plenary.nvim",
      module_pattern = "plenary.*",
      config = function()
        require("plenary.filetype").add_file("extra")
      end,
    })

    --
    -- LSP, treesitter and completion
    --
    use({
      "neovim/nvim-lspconfig",
      config = [[require'modules.lsp'.setup_servers()]],
    })

    use({
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        -- FIXME: diagnostic config shouldn't rely on this plugin
        require("modules.diagnostic")
        require("lsp_lines").register_lsp_virtual_lines()
      end,
    })

    use({
      "j-hui/fidget.nvim",
      module = "fidget",
      config = function()
        require("fidget").setup({
          window = {
            blend = 0,
          },
        })
      end,
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    })

    use({
      "mfussenegger/nvim-jdtls",
    })

    use({
      "p00f/clangd_extensions.nvim",
    })

    use({
      "b0o/schemastore.nvim",
      module = "schemastore",
    })

    use({
      "stevearc/aerial.nvim",
      cmd = "AerialToggle",
      setup = function()
        vim.keymap.set("n", "<Leader>a", "<cmd>AerialToggle<CR>", { silent = true })
      end,
      config = function()
        require("aerial").setup({
          nerd_font = false,
        })
      end,
    })

    use({
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
      },
      config = [[require'modules.cmp']],
    })

    use({
      "L3MON4D3/LuaSnip",
      -- event = "BufReadPost",
      -- module_pattern = "luasnip.*",
      config = [[require'modules.snippets']],
    })

    use({
      "rafamadriz/friendly-snippets",
    })

    use({
      "kosayoda/nvim-lightbulb",
      module = "nvim-lightbulb",
    })

    use({
      -- '~/Downloads/nvim-treesitter',
      "nvim-treesitter/nvim-treesitter",
      -- NOTE: maybe don't lazyload?
      -- with lazyload, if file is opened directly ts plugins won't work until :e!
      -- might have something to do with BufReadPre event and after key idk
      config = [[require'modules.treesitter']],
      run = ":TSUpdate",
    })

    use({
      "lewis6991/spellsitter.nvim",
      config = function()
        require("spellsitter").setup()
      end,
    })

    use({
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      setup = function()
        vim.keymap.set("n", "<Leader>tp", "<cmd>TSPlaygroundToggle<CR>", { silent = true })
        vim.keymap.set("n", "<Leader>th", "<cmd>TSHighlightCapturesUnderCursor<CR>", { silent = true })
      end,
      config = function()
        require("utils.keychord").cancel("<Leader>t")
      end,
    })

    use({
      "monkoose/matchparen.nvim",
      config = function()
        require("matchparen").setup()
      end,
    })

    use({
      -- "~/Projects/forks/nvim-treesitter-pairs",
      "ram02z/nvim-treesitter-pairs",
    })

    -- FIXME: this causes slow down in big files
    use({
      "nvim-treesitter/nvim-treesitter-refactor",
      disable = true,
      event = "CursorHold",
      -- wants = "nvim-treesitter"
    })

    use({
      "mfussenegger/nvim-treehopper",
      config = function()
        vim.keymap.set({ "o", "x" }, "m", ":lua require'tsht'.nodes()<CR>", { silent = true })
      end,
    })

    --
    -- UI
    --

    -- Icons
    use({
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
    })

    -- Statusline
    use({
      "feline-nvim/feline.nvim",
      -- tag = "v0.3",
      -- branch = "develop",
      -- event = { "BufNewFile", "BufReadPre" },
      -- event = "FileType nix",
      config = [[require'modules.feline']],
      -- config = [[require'feline'.setup()]]
    })

    --
    -- Misc
    --

    -- Load my editor defaults
    use({ "gpanders/editorconfig.nvim" })

    -- See https://github.com/neovim/neovim/pull/15436
    use({ "lewis6991/impatient.nvim" })

    -- OSC52 yank
    use({
      "ojroques/vim-oscyank",
      cmd = "OSCYankReg",
      setup = function()
        vim.g.oscyank_max_length = 1000000
      end,
    })

    -- Wrapper around codicons
    use({
      "mortepau/codicons.nvim",
      module = "codicons",
    })

    use({
      "jbyuki/venn.nvim",
      cmd = "VBox",
      setup = function()
        vim.keymap.set("n", "<Leader>\\", function()
          local venn_enabled = vim.inspect(vim.b.venn_enabled)
          if venn_enabled == "nil" then
            print("Entered venn mode")
            vim.b.venn_enabled = true
            vim.cmd([[setlocal ve=all]])
            -- draw a line on HJKL keystokes
            vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { buffer = true })
            vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { buffer = true })
            vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { buffer = true })
            vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { buffer = true })
            -- draw a box by pressing "f" with visual selection
            vim.keymap.set("v", "f", ":VBox<CR>", { buffer = true })
          else
            print("Exited venn mode")
            vim.cmd([[setlocal ve=block]])
            vim.cmd([[mapclear <buffer>]])
            vim.b.venn_enabled = nil
          end
        end, { desc = "Toggle venn mode" })
      end,
    })

    -- TODO: telescope plugin? #749
    use({
      "mhinz/vim-startify",
      cmd = { "SLoad", "SSave", "SDelete", "SClose" },
      setup = function()
        vim.g.startify_change_to_dir = 0
        vim.g.startify_disable_at_vimenter = true
      end,
    })

    -- Repeat support
    use({
      "tpope/vim-repeat",
    })

    use({
      "junegunn/vim-easy-align",
      keys = "<Plug>(EasyAlign)",
      setup = function()
        vim.keymap.set({ "x", "n" }, "ga", "<Plug>(EasyAlign)", { silent = true })
      end,
    })

    --
    -- Language support
    --

    -- Chezmoi template support
    -- NOTE: needs to be loaded first
    use({
      "alker0/chezmoi.vim",
      opt = true,
    })

    -- TODO: move to own file
    use({
      "nvim-neorg/neorg",
      config = [[require'modules.neorg']],
    })

    -- Lean language support
    use({
      "Julian/lean.nvim",
    })

    -- CPP docs
    use({
      "skywind3000/vim-cppman",
    })

    use({
      "lervag/vimtex",
      ft = "tex",
      setup = function()
        vim.g.tex_flavor = "latex"
        vim.g.vimtex_syntax_enabled = 0
        vim.g.vimtex_view_method = "zathura"
        vim.g.tex_conceal = "abdmg"
        vim.g.vimtex_matchparen_enabled = 0
      end,
    })

    -- Git integration
    use({
      {
        "sindrets/diffview.nvim",
        cmd = "Diffview*",
        setup = function()
          vim.keymap.set("n", "<Leader>vo", "<cmd>DiffviewOpen<CR>", { silent = true })
          vim.keymap.set("n", "<Leader>vr", "<cmd>DiffviewRefresh<CR>", { silent = true })
          vim.keymap.set("n", "<Leader>vc", "<cmd>DiffviewClose<CR>", { silent = true })
          vim.keymap.set("n", "<Leader>vh", "<cmd>DiffviewFileHistory<CR>", { silent = true })
        end,
        config = function()
          require("diffview").setup({
            enhanced_diff_hl = true,
          })
          require("utils.keychord").cancel("<Leader>v")
        end,
      },
      {
        "rhysd/committia.vim",
        event = "BufReadPost COMMIT_EDITMSG,MERGE_MSG",
      },
      {
        "lewis6991/gitsigns.nvim",
        module = "gitsigns",
        event = { "BufRead", "BufNewFile" },
        config = [[require'modules.gitsigns']],
      },
      {
        "akinsho/git-conflict.nvim",
        config = function()
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
    })

    -- Toggle terminal
    use({
      "akinsho/toggleterm.nvim",
      cmd = { "ToggleTerm", "TermExec" },
      keys = [[<C-/>]],
      setup = function()
        vim.api.nvim_create_user_command("Ca", "TermExec cmd='chezmoi apply'", {})
        vim.cmd([[cabbrev ca Ca]])
      end,
      config = function()
        require("toggleterm").setup({
          shell = "/usr/bin/env fish",
          open_mapping = [[<C-/>]],
        })
      end,
    })

    -- File manager
    use({
      "mcchrish/nnn.vim",
      config = function()
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
          replace_netrw = 1,
        })
        vim.keymap.set("", "<Leader>n", "<cmd>NnnPicker<CR>", { silent = true })
      end,
    })

    -- Fuzzy finder
    use({
      "nvim-telescope/telescope.nvim",
      -- keys = {
      --   { "n", "<Leader>p" },
      -- },
      -- cmd = "Telescope",
      -- module = "telescope",
      requires = {
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          after = "telescope.nvim",
          run = "make",
          config = function()
            require("telescope").load_extension("fzf")
          end,
        },
      },
      setup = function()
        -- Register pickers
        vim.keymap.set("i", "<C-r>", "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR>")
        vim.keymap.set(
          { "x", "n" },
          '"',
          "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR><Esc>"
        )
      end,
      config = [[require'modules.telescope']],
    })

    use({
      "nvim-telescope/telescope-ui-select.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("ui-select")
      end,
    })

    -- Extends f/t motions
    use({
      "rhysd/clever-f.vim",
      event = "BufReadPost",
      setup = function()
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
    })

    -- Jump anywhere on screen
    use({
      "phaazon/hop.nvim",
      cmd = "Hop*",
      setup = function()
        vim.keymap.set("n", "<Leader>;", "<cmd>HopWord<CR>", { silent = true })
        vim.keymap.set("n", "<Leader>/", "<cmd>HopPattern<CR>", { silent = true })
      end,
      config = function()
        require("hop").setup({ keys = "asdghklwertyuipzxcvbnmfj" })
      end,
    })

    use({
      "AckslD/nvim-trevJ.lua",
      module = "trevj",
      setup = function()
        vim.keymap.set("n", "gJ", function()
          require("trevj").format_at_cursor()
        end)
      end,
    })

    -- Swap delimiter seperated items
    use({
      "mizlan/iswap.nvim",
      cmd = "ISwap*",
      setup = function()
        vim.keymap.set("n", "gs", "<cmd>ISwap<CR>", { silent = true })
        vim.keymap.set("n", "gS", "<cmd>ISwapWith<CR>", { silent = true })
      end,
    })

    -- Comments
    use({
      "numToStr/Comment.nvim",
      keys = { "gc", "gb" },
      config = function()
        local ft = require("Comment.ft")
        ft.dosini = "#%s"
        ft.norg = { "$comment%s", "@comment\r%s@end" }
        require("Comment").setup({
          ignore = "^$",
        })
      end,
    })

    -- Manipulate pairs
    use({
      "machakann/vim-sandwich",
      event = "BufReadPost",
      config = function()
        vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])
      end,
    })

    -- Color highlighting
    use({
      "DarwinSenior/nvim-colorizer.lua",
      event = "BufReadPre",
      config = function()
        require("colorizer").setup({ "*" }, {
          RGB = false,
          RRGGBB = true,
          RRGGBBAA = true,
          css_fn = true,
          names = false,
          mode = "virtualtext",
          virtualtext = "■",
        })
      end,
    })

    -- Increment/decrement
    use({
      "monaqa/dial.nvim",
      config = function()
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
    })

    -- Multiple cursors
    use({
      "mg979/vim-visual-multi",
      keys = {
        "<C-n>",
        "<C-Down>",
        "<C-Up>",
        "<S-Right>",
        "<S-Left>",
        "\\\\",
      },
    })

    -- Text manipulation
    use({
      "booperlv/nvim-gomove",
      config = function()
        require("gomove").setup()
      end,
    })

    -- Smooth scrolling
    use({
      "karb94/neoscroll.nvim",
      event = "BufReadPost",
      config = [[require'neoscroll'.setup()]],
    })

    -- Peek at lines
    use({
      "nacro90/numb.nvim",
      event = "CmdlineEnter",
      config = [[require'numb'.setup({show_cursorline = true})]],
    })

    -- Undo tree
    use({
      "mbbill/undotree",
      cmd = "UndotreeToggle",
      setup = function()
        vim.g.undotree_SplitWidth = 40
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_DiffAutoOpen = 0
        vim.keymap.set("n", "<Leader>ut", "<cmd>UndotreeToggle<CR>", { silent = true })
      end,
      config = function()
        require("utils.keychord").cancel("<Leader>u")
      end,
    })

    -- Show warning if undoing change from before
    use({
      "ram02z/undofile_warn.vim",
      event = "BufReadPost",
    })

    -- Remove annoying search highlighting
    use({
      "romainl/vim-cool",
      event = { "InsertEnter", "CmdlineEnter" },
    })

    -- Remember last position in file
    use({
      "ethanholz/nvim-lastplace",
      event = "BufReadPost",
      config = [[require'nvim-lastplace'.setup()]],
    })

    -- Quickfix helper
    use({
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
    })

    -- Profiling
    use({
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
    })
  end,
  config = {
    profile = {
      enable = true,
    },
    display = {
      prompt_border = "single",
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },
  },
})
