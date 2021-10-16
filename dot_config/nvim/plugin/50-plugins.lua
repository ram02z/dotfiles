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

vim.keymap.noremap({ "<C-S>", packer.sync, silent = true })

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
      "simrat39/symbols-outline.nvim",
      -- "~/Downloads/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      setup = function()
        vim.keymap.nnoremap({ "<Leader>s", "<cmd>SymbolsOutline<CR>", silent = true })
      end,
      config = function()
        require("symbols-outline").setup({
          highlight_hovered_item = false,
          auto_preview = false,
          keymaps = {
            toggle_preview = "p",
          },
          symbols = {
            File = { icon = "", hl = "TSURI" },
            Module = { icon = "", hl = "TSNamespace" },
            Namespace = { icon = "", hl = "TSNamespace" },
            Package = { icon = "", hl = "TSNamespace" },
            Class = { icon = "", hl = "TSType" },
            Method = { icon = "", hl = "TSMethod" },
            Property = { icon = "", hl = "TSMethod" },
            Field = { icon = "", hl = "TSField" },
            Constructor = { icon = "", hl = "TSConstructor" },
            Enum = { icon = "", hl = "TSType" },
            Interface = { icon = "", hl = "TSType" },
            Function = { icon = "", hl = "TSFunction" },
            Variable = { icon = "", hl = "TSConstant" },
            Constant = { icon = "", hl = "TSConstant" },
            String = { icon = "", hl = "TSString" },
            Number = { icon = "", hl = "TSNumber" },
            Boolean = { icon = "", hl = "TSBoolean" },
            Array = { icon = "", hl = "TSConstant" },
            Object = { icon = "", hl = "TSType" },
            Key = { icon = "", hl = "TSType" },
            Null = { icon = "NULL", hl = "TSType" },
            EnumMember = { icon = "", hl = "TSField" },
            Struct = { icon = "", hl = "TSType" },
            Event = { icon = "", hl = "TSType" },
            Operator = { icon = "", hl = "TSOperator" },
            TypeParameter = { icon = "", hl = "TSParameter" },
          },
        })
      end,
    })

    use({
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      module = "cmp",
      requires = {
        { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
        { "kdheepak/cmp-latex-symbols", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lua", ft = "lua" },
        { "hrsh7th/cmp-path", after = "nvim-cmp" },
        { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      },
      config = [[require'modules.cmp']],
    })

    use({
      "L3MON4D3/LuaSnip",
      event = "InsertCharPre",
      module_pattern = "luasnip.*",
      config = [[require'modules.snippets']],
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
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      setup = function()
        vim.keymap.nnoremap({ "<Leader>tp", "<cmd>TSPlaygroundToggle<CR>", silent = true })
        vim.keymap.nnoremap({ "<Leader>th", "<cmd>TSHighlightCapturesUnderCursor<CR>", silent = true })
      end,
      config = function()
        require("utils.keychord").cancel("<Leader>t")
      end,
    })

    use({
      "p00f/nvim-ts-rainbow",
      -- wants = "nvim-treesitter",
      event = "BufReadPre",
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
      event = "BufReadPost",
      config = function()
        vim.keymap.onoremap({ "m", require("tsht").nodes, silent = true })
        vim.keymap.vnoremap({ "m", [[:lua require'tsht'.nodes()<CR>]], silent = true })
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
      "famiu/feline.nvim",
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

    -- Change directory to project root
    use({
      "ram02z/rooter.nvim",
      event = "BufReadPre",
    })

    -- TODO: actually set this up
    use({
      "vhyrro/neorg",
      branch = "unstable",
      after = "nvim-treesitter",
      config = function()
        require("neorg").setup({
          load = {
            ["core.defaults"] = {}, -- Load all the default modules
            ["core.norg.concealer"] = {}, -- Allows for use of icons
            ["core.norg.dirman"] = { -- Manage your directories with Neorg
              config = {
                workspaces = {
                  my_workspace = "~/neorg",
                },
              },
            },
          },
        })
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
        vim.keymap.xmap({ "ga", "<Plug>(EasyAlign)", silent = true })
        vim.keymap.nmap({ "ga", "<Plug>(EasyAlign)", silent = true })
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
      "Julian/lean.nvim",
      module = "lean",
    })

    -- Git integration
    use({
      {
        "sindrets/diffview.nvim",
        cmd = {
          "DiffviewOpen",
          "DiffviewFileHistory",
          "DiffviewClose",
          "DiffviewFocusFiles",
          "DiffviewToggleFiles",
          "DiffviewRefresh",
        },
        setup = function()
          vim.keymap.nnoremap({ "<Leader>do", "<cmd>DiffviewOpen<CR>", silent = true })
          vim.keymap.nnoremap({ "<Leader>dc", "<cmd>DiffviewClose<CR>", silent = true })
          vim.keymap.nnoremap({ "<Leader>dh", "<cmd>DiffviewFileHistory<CR>", silent = true })
        end,
        config = function()
          require("diffview").setup({
            enhanced_diff_hl = true,
          })
          require("utils.keychord").cancel("<Leader>d")
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
        vim.cmd([[command! Ca TermExec cmd='chezmoi apply']])
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
        vim.keymap.noremap({ "<Leader>N", "<cmd>NnnPicker<CR>", silent = true })
        vim.keymap.noremap({
          "<Leader>n",
          require("utils.misc").t(":NnnPicker %:p:h<CR>"),
          silent = true,
        })
      end,
    })
    -- Fuzzy finder
    -- TODO: replace with snap unless it gets async
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
        vim.keymap.inoremap({
          "<C-r>",
          "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR>",
          silent = true,
        })
        vim.keymap.xnoremap({
          '"',
          "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR><Esc>",
          silent = true,
        })
        vim.keymap.nnoremap({
          '"',
          "<cmd>Telescope registers theme=get_cursor layout_config={height=18}<CR>",
          silent = true,
        })
      end,
      config = [[require'modules.telescope']],
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

    -- Matchit extension
    use({
      "andymass/vim-matchup",
      event = "BufReadPost",
      setup = function()
        vim.g.matchup_delim_noskips = 2
        vim.g.matchup_matchparen_pumvisible = 0
        vim.g.matchup_matchparen_singleton = 0
        vim.g.matchup_matchparen_nomode = "ivV\\<c-v>"
        vim.g.matchup_surround_enabled = 1
        vim.g.matchup_matchparen_offscreen = { ["method"] = "popup" }
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
        vim.keymap.map({ ";", "<Plug>(clever-f-repeat-forward)", silent = true })
        vim.keymap.map({ ",", "<Plug>(clever-f-repeat-back)", silent = true })
        -- FIX: Issue #61
        vim.keymap.nmap({ "<Esc>", "<Plug>(clever-f-reset)<cmd>noh<CR>", silent = true })
      end,
    })

    -- Jump anywhere on screen
    use({
      "phaazon/hop.nvim",
      keys = {
        { "n", "<Leader>;" },
      },
      config = function()
        local hop = require("hop")
        vim.keymap.nnoremap({ "<Leader>;", hop.hint_words, silent = true })
        hop.setup({ keys = "asdghklwertyuipzxcvbnmfj" })
      end,
    })

    -- Extends * motions
    use({
      "haya14busa/vim-asterisk",
      keys = {
        "<Plug>(asterisk-*)",
        "<Plug>(asterisk-#)",
        "<Plug>(asterisk-g*)",
        "<Plug>(askerisk-g#)",
      },
      setup = function()
        vim.keymap.map({ "*", "<Plug>(asterisk-*)", silent = true })
        vim.keymap.map({ "#", "<Plug>(asterisk-#)", silent = true })
        vim.keymap.map({ "g*", "<Plug>(asterisk-g*)", silent = true })
        vim.keymap.map({ "g#", "<Plug>(asterisk-g#)", silent = true })
        vim.g["asterisk#keeppos"] = 1
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
      cmd = "ISwap",
      setup = function()
        vim.keymap.nnoremap({ "gs", "<cmd>ISwap<CR>", silent = true })
        vim.keymap.nnoremap({ "gS", "<cmd>ISwapWith<CR>", silent = true })
      end,
    })

    -- Comments
    use({
      "b3nj5m1n/kommentary",
      setup = function()
        -- Disable default binds
        vim.g.kommentary_create_default_mappings = false
        vim.keymap.nmap({ "gcl", "<Plug>kommentary_line_default", silent = true })
        vim.keymap.nmap({ "gc", "<Plug>kommentary_motion_default", silent = true })
        vim.keymap.vmap({ "gc", "<Plug>kommentary_visual_default", silent = true })
      end,
      keys = {
        { "n", "<Plug>kommentary_line_default" },
        { "n", "<Plug>kommentary_motion_default" },
        { "v", "<Plug>kommentary_visual_default" },
      },
      config = function()
        require("utils.keychord").cancel("gc")
        local kommentary = require("kommentary.config")

        kommentary.configure_language("default", {
          use_consistent_indent = true,
          ignore_whitespace = true,
        })

        kommentary.configure_language("dosini", {
          prefer_single_line_comments = true,
          single_line_comment_string = "#",
        })

        kommentary.configure_language("fish", {
          prefer_single_line_comments = true,
          single_line_comment_string = "#",
        })
        kommentary.configure_language("lua", {
          prefer_single_line_comments = true,
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
        vim.keymap.nmap({ "<C-a>", "<Plug>(dial-increment)", silent = true })
        vim.keymap.nmap({ "<C-x>", "<Plug>(dial-decrement)", silent = true })
        vim.keymap.vmap({ "<C-a>", "<Plug>(dial-increment)", silent = true })
        vim.keymap.vmap({ "<C-x>", "<Plug>(dial-decrement)", silent = true })
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

    -- TODO: fork and implement left-right movement
    -- block movement
    -- duplicate feature maybe
    use({
      "fedepujol/move.nvim",
      module = "move",
      setup = function()
        vim.keymap.nmap({ "<A-k>", "<cmd>lua require('move').MoveLine(-1)<CR>", silent = true })
        vim.keymap.xmap({ "<A-j>", "<cmd>lua require('move').MoveBlock(1)<CR>", silent = true })
        vim.keymap.xmap({ "<A-k>", "<cmd>lua require('move').MoveBlock(-1)<CR>", silent = true })
        vim.keymap.nmap({ "<A-j>", "<cmd>lua require('move').MoveLine(1)<CR>", silent = true })
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
        vim.keymap.nnoremap({ "<Leader>ut", "<cmd>UndotreeToggle<CR>", silent = true })
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
