-- Install packer
local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

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
      "neovim/nvim-lspconfig",
      module_pattern = "lspconfig.*",
    })

    use({
      "nvim-lua/plenary.nvim",
      module_pattern = "plenary.*",
      config = function()
        require("plenary.filetype").add_file("extra")
      end,
    })

    use({
      "nvim-lua/popup.nvim",
    })

    -- UI library
    use({
      "MunifTanjim/nui.nvim",
    })

    --
    -- LSP, treesitter and completion
    --
    use({
      "kabouzeid/nvim-lspinstall",
      event = { "BufReadPre", "BufNewFile" },
      cmd = { "LspInstall", "LspUninstall", "LspPrintInstalled" },
      config = [[require'modules.lsp']],
      requires = { "folke/lua-dev.nvim", module = "lua-dev" },
    })

    use({
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      setup = function()
        vim.keymap.nnoremap({ "<Leader>o", "<cmd>SymbolsOutline<CR>", silent = true })
      end,
    })

    use({
      "hrsh7th/nvim-compe",
      event = "InsertEnter",
      -- disable = true,
      config = [[require'modules.compe']],
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
      end,
      config = function()
        require("utils.keychord").cancel("<Leader>t")
      end,
    })

    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- wants = 'nvim-treesitter',
      -- TODO: use 'keys' key instead
      event = "CursorHold",
    })

    use({
      "p00f/nvim-ts-rainbow",
      wants = "nvim-treesitter",
      -- event = "BufReadPre",
    })

    use({
      "nvim-treesitter/nvim-treesitter-refactor",
      event = "CursorHold",
      -- wants = "nvim-treesitter"
    })

    use({
      "mfussenegger/nvim-ts-hint-textobject",
      keys = {
        { "o", "m" },
        { "v", "m" },
      },
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

    -- Buffer/Tabline
    use({
      "akinsho/nvim-bufferline.lua",
      event = "BufReadPre",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = [[require'modules.bufferline']],
    })

    -- Statusline
    use({
      "famiu/feline.nvim",
      event = { "BufNewFile", "BufReadPre" },
      config = [[require'modules.feline']],
    })

    -- Indentation line
    use({
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPost",
      config = function()
        -- #59
        vim.o.colorcolumn = "99999"
        vim.g.indent_blankline_char = "│"
        vim.g.indent_blankline_filetype_exclude = {
          "help",
          "vimwiki",
          "man",
          "dashboard",
          "TelescopePrompt",
          "undotree",
          "packer",
          "lspinfo",
          "qf",
          "tsplayground",
          "",
        }
        vim.g.indent_blankline_buftype_exclude = { "terminal" }
        vim.g.indent_blankline_show_first_indent_level = false
        vim.g.indent_blankline_show_current_context = true
        vim.g.indent_blankline_context_patterns = {
          "class",
          "function",
          "method",
          "^if",
          "while",
          "for",
          "with",
          "func_literal",
          "block",
          "try",
          "except",
          "argument_list",
          "object",
          "dictionary",
          "table",
        }
        -- Lazy load
        vim.cmd([[autocmd CursorHold,CursorHoldI * IndentBlanklineRefresh]])
      end,
    })

    -- Colorscheme
    -- FIXME: Syntax files in the after directory aren't reloaded on PackerCompile
    use({
      "ram02z/vim",
      branch = "nvim_plugs",
      -- '~/Downloads/vim',
      -- 'bloop132435/dracula.nvim',
      as = "dracula",
      config = function()
        vim.cmd([[colorscheme dracula]])
      end,
    })

    use({
      "folke/tokyonight.nvim",
      disable = true,
      config = function()
        vim.g.tokyonight_terminal_colors = false
        vim.g.tokyonight_style = "night"
        vim.cmd([[colorscheme tokyonight]])
      end,
    })

    --
    -- Misc
    --

    -- Load my editor defaults
    use({ "gpanders/editorconfig.nvim" })

    -- Fix CursorHold performance
    -- REMOVE: if https://github.com/neovim/neovim/issues/12587 gets closed
    use({
      "antoinemadec/FixCursorHold.nvim",
      -- disable = true,
      setup = function()
        vim.g.cursorhold_updatetime = 50
      end,
    })

    -- OSC52 yank
    use({
      "ojroques/vim-oscyank",
      cmd = "OSCYankReg",
      setup = function()
        vim.g.oscyank_max_length = 1000000
      end,
    })

    -- Change directory to project root
    use({
      "airblade/vim-rooter",
      config = function()
        vim.g.rooter_cd_cmd = "tcd"
        vim.g.rooter_change_directory_for_non_project_files = "current"
      end,
    })

    -- TODO: actually set this up
    use({
      "vhyrro/neorg",
      branch = "unstable",
      ft = "norg",
      wants = { "nvim-compe", "nvim-treesitter" },
      config = function()
        require("neorg").setup({
          load = {
            ["core.defaults"] = {},
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

    use({
      "junegunn/vim-easy-align",
      keys = "<Plug>(EasyAlign)",
      setup = function()
        vim.keymap.xmap({ "ga", "<Plug>(EasyAlign)", silent = true })
        vim.keymap.nmap({ "ga", "<Plug>(EasyAlign)", silent = true })
      end,
    })

    -- Chezmoi template support
    -- NOTE: needs to be loaded first
    use({
      "alker0/chezmoi.vim",
      opt = true,
    })

    -- Reload nvim
    -- TODO: do I really need this?
    use({
      "ram02z/nvim-reload",
      cmd = "Reload",
      setup = function()
        vim.keymap.nnoremap({ "<Leader>r", ":Reload<CR>", silent = true })
      end,
      config = function()
        local reload = require("nvim-reload")
        reload.pre_reload_hook = function()
          require("packer").compile()
        end
        reload.post_reload_hook = function()
          require("feline").reset_highlights()
        end
      end,
    })

    -- Git integration
    use({
      {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        requires = { "sindrets/diffview.nvim", module = "diffview" },
        config = function()
          require("neogit").setup({
            integrations = {
              diffview = true,
            },
          })
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

    -- Zen-mode
    use({
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      setup = function()
        vim.keymap.nnoremap({ "<Leader>z", "<cmd>ZenMode<CR>", silent = true })
      end,
      config = function()
        require("zen-mode").setup({
          window = {
            backdrop = 1,
            width = 0.85,
          },
          plugins = {
            gitsigns = { enabled = true },
            twilight = { enabled = true },
          },
        })
      end,
    })

    -- Highlight active portion with zenmode
    use({
      "folke/twilight.nvim",
      module = "twilight",
    })

    -- Toggle terminal
    use({
      "akinsho/nvim-toggleterm.lua",
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
      keys = { "n", "<Leader>p" },
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
      config = [[require'modules.telescope']],
    })

    use({
      "tversteeg/registers.nvim",
      keys = {
        { "n", '"' },
        { "x", '"' },
        { "i", "<C-R>" },
      },
    })

    -- Matchit extension
    use({
      "andymass/vim-matchup",
      event = "BufReadPost",
      -- disable = true,
      setup = function()
        vim.g.matchup_delim_noskips = 2
        vim.g.matchup_matchparen_pumvisible = 0
        vim.g.matchup_matchparen_singleton = 0
        vim.g.matchup_matchparen_nomode = "ivV\\<c-v>"
        vim.g.matchup_surround_enabled = 1
        vim.g.matchup_matchparen_offscreen = { ["method"] = "popup" }
      end,
    })

    -- Motions
    use({
      {
        "rhysd/clever-f.vim",
        event = "BufReadPost",
        setup = function()
          vim.keymap.map({ ";", "<Plug>(clever-f-repeat-forward)", silent = true })
          vim.keymap.map({ ",", "<Plug>(clever-f-repeat-back)", silent = true })
          -- FIX: Issue #61
          vim.keymap.nmap({ "<Esc>", "<Plug>(clever-f-reset):noh<CR>", silent = true })
          vim.g.clever_f_smart_case = 1
          vim.g.clever_f_chars_match_any_signs = ";"
          vim.g.clever_f_fix_key_direction = 1
          vim.g.clever_f_mark_direct = 1
        end,
      },
      {
        "phaazon/hop.nvim",
        keys = {
          { "n", "<Leader>;" },
        },
        config = function()
          local hop = require("hop")
          vim.keymap.nnoremap({ "<Leader>;", hop.hint_words, silent = true })
          hop.setup({ keys = "asdghklwertyuipzxcvbnmfj" })
        end,
      },
    })

    -- Wrap and unwrap arguments
    use({
      "AndrewRadev/splitjoin.vim",
      -- FIXME: keys don't load instantly (seems to be a vim plugin issue)
      -- experienced the same with vim-sandwich
      event = "CursorHold",
      setup = function()
        vim.g.splitjoin_split_mapping = "sj"
        vim.g.splitjoin_join_mapping = "sk"
      end,
      config = function()
        require("utils.keychord").cancel("s")
      end,
    })

    use({
      "mizlan/iswap.nvim",
      cmd = "ISwap",
      setup = function()
        vim.keymap.nnoremap({ "gs", "<cmd>ISwap<CR>", silent = true })
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
        vim.keymap.imap({ "<C-_>", "<C-o><Plug>kommentary_line_default", silent = true })
        vim.keymap.vmap({ "gc", "<Plug>kommentary_visual_default", silent = true })
      end,
      keys = {
        { "i", "<C-o><Plug>kommentary_line_default" },
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
        vim.keymap.xmap({ "is", "<Plug>(textobj-sandwich-query-i)", silent = true })
        vim.keymap.xmap({ "as", "<Plug>(textobj-sandwich-query-a)", silent = true })
        vim.keymap.omap({ "is", "<Plug>(textobj-sandwich-query-i)", silent = true })
        vim.keymap.omap({ "as", "<Plug>(textobj-sandwich-query-a)", silent = true })
      end,
    })

    -- Color highlighting
    use({
      "DarwinSenior/nvim-colorizer.lua",
      event = "BufReadPre",
      config = function()
        require("colorizer").setup(_, {
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
      keys = { "<C-n>", "<C-Down>", "<C-Up>" },
    })

    -- Text manipulation
    use({
      "t9md/vim-textmanip",
      keys = {
        { "i", "<C-o><Plug>(textmanip-move-up)" },
        { "i", "<C-o><Plug>(textmanip-move-down)" },
        "<Plug>(textmanip-move-down)",
        "<Plug>(textmanip-move-up)",
        "<Plug>(textmanip-move-left)",
        "<Plug>(textmanip-move-right)",
        "<Plug>(textmanip-duplicate-down)",
        "<Plug>(textmanip-duplicate-up)",
        "<Plug>(textmanip-blank-above)",
        "<Plug>(textmanip-blank-below)",
      },
      setup = function()
        vim.keymap.map({ "<A-j>", "<Plug>(textmanip-move-down)", silent = true })
        vim.keymap.map({ "<A-k>", "<Plug>(textmanip-move-up)", silent = true })
        vim.keymap.imap({ "<A-j>", "<C-o><Plug>(textmanip-move-down)", silent = true })
        vim.keymap.imap({ "<A-k>", "<C-o><Plug>(textmanip-move-up)", silent = true })
        vim.keymap.xmap({ "<A-h>", "<Plug>(textmanip-move-left)", silent = true })
        vim.keymap.xmap({ "<A-l>", "<Plug>(textmanip-move-right)", silent = true })
        vim.keymap.map({ "<C-j>", "<Plug>(textmanip-duplicate-down)", silent = true })
        vim.keymap.map({ "<C-k>", "<Plug>(textmanip-duplicate-up)", silent = true })
        vim.keymap.map({ "[<Space>", "<Plug>(textmanip-blank-above)", silent = true })
        vim.keymap.map({ "]<Space>", "<Plug>(textmanip-blank-below)", silent = true })
      end,
      config = function()
        -- TODO: lua :)
        vim.api.nvim_exec(
          [[
          let g:textmanip_hooks = {}
          function! g:textmanip_hooks.finish(tm)
            let tm = a:tm
            let helper = textmanip#helper#get()
            if tm.linewise
              call helper.indent(tm)
            else
              " When blockwise move/duplicate, remove trailing white space.
              " To use this feature without feeling counterintuitive,
              " I recommend you to ':set virtualedit=block',
              call helper.remove_trailing_WS(tm)
            endif
          endfunction
          ]],
          true
        )
      end,
    })

    -- Smooth scrolling
    use({
      "karb94/neoscroll.nvim",
      event = "WinScrolled",
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
        require("bqf").setup()
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