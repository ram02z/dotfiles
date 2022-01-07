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

vim.keymap.set("", "<C-S>", packer.sync, {silent=true})

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
      config = [[require'modules.lsp']],
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    })

    use({
      "stevearc/aerial.nvim",
      cmd = "AerialToggle",
      setup = function()
        vim.keymap.set("n", "<Leader>a", "<cmd>AerialToggle!<CR>", {silent=true})
        vim.g.aerial = { nerd_font = false }
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

    -- FIXME: this causes slow down in big files
    use({
      "nvim-treesitter/nvim-treesitter-refactor",
      disable = true,
      event = "CursorHold",
      -- wants = "nvim-treesitter"
    })

    use({
      "mfussenegger/nvim-ts-hint-textobject",
      config = function()
        vim.keymap.set({"o", "v"}, "m", "<cmd>lua require'tsht'.nodes()<CR>", {silent = true})
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
      branch = "develop",
      -- "~/Downloads/feline.nvim",
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
        vim.keymap.set(
          "n",
          "<Leader>\\",
          function()
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
              vim.keymap.set("v", "f", ":VBox<CR>", {buffer=true})
            else
              print("Exited venn mode")
              vim.cmd([[setlocal ve=block]])
              vim.cmd([[mapclear <buffer>]])
              vim.b.venn_enabled = nil
            end
          end
        )
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
        vim.keymap.set({"x", "n"}, "ga", "<Plug>(EasyAlign)", {silent=true})
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

    use({
      "nvim-neorg/neorg",
      config = function()
        require("neorg").setup({
          load = {
            ["core.defaults"] = {}, -- Load all the default modules
            ["core.norg.concealer"] = {}, -- Allows for use of icons
            ["core.norg.completion"] = {
              config = {
                engine = "nvim-cmp",
              },
            },
            -- ["core.norg.dirman"] = { -- Manage your directories with Neorg
            --   config = {
            --     workspaces = {
            --       my_workspace = "~/Notes",
            --     },
            --   },
            -- },
          },
        })
      end,
    })

    use({
      "Julian/lean.nvim",
      module = "lean",
    })

    -- Git integration
    use({
      {
        "sindrets/diffview.nvim",
        cmd = "Diffview*",
        setup = function()
          vim.keymap.set("n", "<Leader>vo", "<cmd>DiffviewOpen<CR>", { silent = true })
          vim.keymap.set("n", "<Leader>vr", "<cmd>DiffviewRefresh<CR>",  { silent = true })
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
    })

    -- Toggle terminal
    use({
      "akinsho/toggleterm.nvim",
      cmd = { "ToggleTerm", "TermExec" },
      keys = "<C-_>",
      setup = function()
        vim.api.nvim_add_user_command("Ca", "TermExec cmd='chezmoi apply'", {})
        vim.cmd([[cabbrev ca Ca]])
      end,
      config = function()
        require("toggleterm").setup({
          shell = "/usr/bin/env fish",
          open_mapping = [[<C-_>]],
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
        vim.keymap.set("", "<Leader>n", "<cmd>NnnPicker<CR>", {silent=true})
      end,
    })

    -- Fuzzy finder
    use({
      "nvim-telescope/telescope.nvim",
      keys = {
        { "n", "<Leader>p" },
      },
      cmd = "Telescope",
      module = "telescope",
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
        vim.keymap.set(
          "i",
          "<C-r>",
          "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR>"
        )
        vim.keymap.set(
          {"x", "n"},
          '"',
          "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR><Esc>"
        )
      end,
      config = [[require'modules.telescope']],
    })

    use({
      "delphinus/dwm.nvim",
      config = function()
        local dwm = require("dwm")
        dwm.setup({
          key_maps = false,
          master_pane_count = 1,
          master_pane_width = "50%",
        })
        dwm.map("<C-j>", "<C-w>w")
        dwm.map("<C-k>", "<C-w>W")
        dwm.map("<A-f>", dwm.focus)
        dwm.map("<C-Space>", dwm.focus)
        dwm.map("<C-l>", dwm.grow)
        dwm.map("<C-h>", dwm.shrink)
        dwm.map("<C-\\>", dwm.new)
        dwm.map("<C-c>", function()
          -- You can use any Lua function to map.
          vim.api.nvim_echo({ { "closing!", "WarningMsg" } }, false, {})
          dwm.close()
        end)

        -- When b:dwm_disabled is set, all features are disabled.
        vim.cmd([[au BufRead * if &previewwindow | let b:dwm_disabled = 1 | endif]])
      end,
    })

    -- Helper for resizing splits
    use({
      "simeji/winresizer",
      keys = {
        { "n", "<Leader>r" },
      },
      setup = function()
        vim.g.winresizer_start_key = "<Leader>r"
        vim.g.winresizer_vert_resize = 5
        vim.g.winresizer_horiz_resize = 5
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
        vim.keymap.set("", ";", "<Plug>(clever-f-repeat-forward)", {silent=true})
        vim.keymap.set("", ",", "<Plug>(clever-f-repeat-back)", {silent=true})
        -- FIXME: Issue #61
        vim.keymap.set("n", "<Esc>", "<Plug>(clever-f-reset)<cmd>nod<CR>", {silent=true})
      end,
    })

    -- Jump anywhere on screen
    use({
      "phaazon/hop.nvim",
      cmd = "Hop*",
      setup = function()
        vim.keymap.set("n", "<Leader>;", "<cmd>HopWord<CR>", {silent=true})
        vim.keymap.set("n", "<Leader>/", "<cmd>HopPattern<CR>", {silent=true})
      end,
      config = function()
        require("hop").setup({ keys = "asdghklwertyuipzxcvbnmfj" })
      end,
    })

    -- Wrap and unwrap arguments
    use({
      "AndrewRadev/splitjoin.vim",
      -- FIXME: keys don't load instantly (seems to be a vim plugin issue)
      -- experienced the same with vim-sandwich
      event = "BufRead",
      setup = function()
        vim.g.splitjoin_split_mapping = "sj"
        vim.g.splitjoin_join_mapping = "sk"
      end,
    })

    -- Swap delimiter seperated items
    use({
      "mizlan/iswap.nvim",
      cmd = "ISwap*",
      setup = function()
        vim.keymap.set("n", "gs", "<cmd>ISwap<CR>", {silent=true})
        vim.keymap.set("n", "gS", "<cmd>ISwapWith<CR>", {silent=true})
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
      keys = { "<Plug>(dial-decrement)", "<Plug>(dial-increment)" },
      setup = function()
        vim.keymap.set({"n", "v"}, "<C-a>", "<Plug>(dial-increment)", {silent=true})
        vim.keymap.set({"n", "v"}, "<C-x>", "<Plug>(dial-decrement)", {silent=true})
      end,
      config = function()
        local dial = require("dial")
        dial.augends["custom#small#boolean"] = dial.common.enum_cyclic({
          name = "boolean",
          strlist = { "true", "false" },
        })

        dial.augends["custom#capital#boolean"] = dial.common.enum_cyclic({
          name = "boolean",
          strlist = { "True", "False" },
        })

        dial.config.searchlist.normal = {
          "number#decimal#int",
          "markup#markdown#header",
          "custom#capital#boolean",
          "custom#small#boolean",
        }

        dial.config.searchlist.visual = {
          "number#decimal#int",
          "markup#markdown#header",
          "number#hex",
          "number#binary",
          "color#hex",
        }
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
        vim.keymap.set("n", "<Leader>ut", "<cmd>UndotreeToggle<CR>", {silent=true})
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
