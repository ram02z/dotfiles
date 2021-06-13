-- Install packer
local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
end
execute 'packadd packer.nvim'

local packer = require("packer")

return packer.startup(function(use)
  use {'wbthomason/packer.nvim', opt = true}

  -- Common dependancies
  use {
    'neovim/nvim-lspconfig',
    event = {'BufReadPre', 'BufNewFile'}
  }
  use {
    'nvim-lua/plenary.nvim',
    opt = true,
    config = function()
      require'plenary.filetype'.add_file('extra')
    end
  }
  use {
    'nvim-lua/popup.nvim',
    opt = true
  }

  --
  -- LSP, treesitter and completion
  --
  use {
    'kabouzeid/nvim-lspinstall',
    event = {'BufReadPre', 'BufNewFile'},
    cmd = {'LspInstall', 'LspUninstall'},
    config = [[require'modules.lspinstall']],
    requires = {'folke/lua-dev.nvim', opt = true}
  }

  use {
    'simrat39/symbols-outline.nvim',
    cmd = 'SymbolsOutline',
    setup = function ()
      vim.keymap.nnoremap({'<Leader>so',':SymbolsOutline<CR>', silent = true})
    end,
    config = function ()
      require'keychord'.cancel('<Leader>s')
    end
  }

  use {
    'hrsh7th/nvim-compe',
    event = 'BufReadPre',
    config = [[require'modules.compe']]
  }

  use {
    'hrsh7th/vim-vsnip',
    -- requires = {'hrsh7th/vim-vsnip-integ', disable = true},
    after = 'nvim-compe'
  }

  use {
    'rafamadriz/friendly-snippets',
    after = 'vim-vsnip'
  }


  use {
    -- '~/Downloads/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    cmd = 'TSUpdate',
    module = 'telescope',
    config = [[require'modules.treesitter']],
    run = ':TSUpdate',
    requires = {
      {'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle'}
    }
  }

  use {
    'p00f/nvim-ts-rainbow',
    after = 'nvim-treesitter'
  }

  -- #49
  use {
    'romgrk/nvim-treesitter-context',
    disable = true,
    after = 'nvim-treesitter'
  }

  use {
    'nvim-treesitter/nvim-treesitter-refactor',
    after = 'nvim-treesitter'
  }

  --
  -- UI
  --

  -- Icons
  use {
    'kyazdani42/nvim-web-devicons',
  }

  use {
    'glepnir/dashboard-nvim',
    setup = function()
      vim.g.dashboard_custom_header = {'', '', '', '', '[ dashboard ]', '', '', '', ''}
      vim.g.dashboard_default_executive = 'telescope'
      vim.g.dashboard_custom_footer = {
        '',
        'neovim loaded ' .. #vim.tbl_keys(packer_plugins) .. ' plugins',
        ''
      }
      vim.g.dashboard_custom_section = {
        a = {
          description = {"Recently closed files                                SPC p h"},
          command = ":lua require('modules.telescope.functions').old_files()"
        },
        b = {
          description = {"Packer plugins                                       SPC p p"},
          command = ":lua require('telescope').extensions.packer.plugins(opts)"
        },
        c = {
          description = {"Packer sync                                                 "},
          command = "PackerSync"
        },
      }
    end
  }

  -- Tabline
  use {
    'akinsho/nvim-bufferline.lua',
    event = 'BufReadPre',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = [[require'modules.bufferline']],
  }

  -- Statusline
  use {
    'glepnir/galaxyline.nvim',
    after = 'nvim-web-devicons',
    config = [[require'modules.statusline']],
    event = 'UIEnter'
  }

  -- Indentation line
  use {
    'lukas-reineke/indent-blankline.nvim',
    branch = 'lua',
    event = 'BufRead',
    after = {'dracula','nvim-treesitter'},
    config = function()
      vim.g.indent_blankline_char = '│'
      vim.g.indent_blankline_filetype_exclude = {
        'help',
        'vimwiki',
        'man',
        'dashboard',
        'TelescopePrompt',
        'undotree',
        'packer',
        'lspinfo',
        'tsplayground',
        ''
      }
      vim.g.indent_blankline_buftype_exclude = {'terminal'}
      vim.g.indent_blankline_show_first_indent_level = false
      vim.g.indent_blankline_show_current_context = true
      vim.g.indent_blankline_context_patterns = {
        'class',
        'function',
        'method',
        '^if',
        'while',
        'for',
        'with',
        'func_literal',
        'block',
        'try',
        'except',
        'argument_list',
        'object',
        'dictionary',
        'table'
      }
      -- Lazy load
      vim.cmd('autocmd CursorMoved * IndentBlanklineRefresh')
    end
  }

  -- Colorscheme
  use {
    'ram02z/vim',
    branch = 'nvim_plugs',
    as = 'dracula',
    opt = false,
    config = function()
      vim.cmd [[colorscheme dracula]]
    end
  }

  --
  -- Misc
  --

  -- Load my editor defaults
  use {'editorconfig/editorconfig-vim'}

  -- Fix CursorHold performance
  -- Remove if https://github.com/neovim/neovim/issues/12587 gets closed
  use {
    'antoinemadec/FixCursorHold.nvim',
    setup = function ()
      vim.g.cursorhold_updatetime = 50
    end
  }

  -- Change directory to project root
  use {
    'airblade/vim-rooter',
    cmd = 'Rooter',
    config = function()
      vim.g.rooter_manual_only = 1
      vim.g.rooter_change_directory_for_non_project_files = 'current'
    end
  }

  -- Git integration
  use {
    {
      'rhysd/committia.vim',
      event = 'BufReadPost COMMIT_EDITMSG,MERGE_MSG'
    },
    {
    'lewis6991/gitsigns.nvim',
    event = {'BufRead','BufNewFile'},
    config = [[require'modules.gitsigns']]
    }
  }
  -- File manager
  use {
    'mcchrish/nnn.vim',
    -- TODO: Use lua config instead
    config = function()
      local t = require'utils.misc'.t
      vim.keymap.nnoremap({'<Leader>n', t ':cd %:p:h | NnnPicker<CR>', silent = true})
      vim.keymap.nnoremap({'<Leader>N', ':Rooter | NnnPicker<CR>', silent = true})
      vim.g['nnn#command'] = 'n'
      vim.g['nnn#set_default_mappings'] = 0
      -- Disable netrw
      vim.g.loaded_netrwPlugin = 0
      vim.g['nnn#replace_netrw'] = 1
      vim.g['nnn#layout'] = {
        ['window'] = {
          ['width'] = 0.9,
          ['height'] = 0.6,
          ['highlight'] = 'Debug'
        }
      }
      vim.g['nnn#action'] = {
        ['<C-t>'] = 'tab split',
        ['<C-x>'] = 'split',
        ['<C-v>'] = 'vsplit'
      }
    end
  }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    keys = {'n', '<Leader>p'},
    cmd = 'Telescope',
    module = 'telescope',
    requires = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        after = 'telescope.nvim',
        run = 'make',
        config = function()
          require"telescope".load_extension("fzf")
        end
      },
      {
        'nvim-telescope/telescope-frecency.nvim',
        requires = 'tami5/sql.nvim',
        after = 'telescope.nvim',
        config = function()
          require"telescope".load_extension("frecency")
        end
      },
      {
        'sudormrfbin/cheatsheet.nvim',
        keys = {'n', '<Leader>?'}
      },
      {'nvim-telescope/telescope-packer.nvim'},
    },
    config = [[require'modules.telescope']]
  }

  -- Registers picker
  use {
    'tversteeg/registers.nvim',
    keys = {
      'n', '"',
      'x', '"',
      'i', '<C-R>'
    }
  }

  -- Zoxide wrapper
  use {
    'nanotee/zoxide.vim',
    cmd = {'Z', 'Lz', 'Tz'}
  }

  -- Highlight word under cursor
  -- TODO: Find a better plugin using matchit?
  use {
    'andymass/vim-matchup',
    event = 'CursorHold',
    setup = function ()
      vim.g.matchup_delim_noskips = 2
      vim.g.matchup_matchparen_pumvisible = 0
      vim.g.matchup_matchparen_singleton = 0
      vim.g.matchup_matchparen_nomode = 'ivV\\<c-v>'
      vim.g.matchup_surround_enabled = 1
      --[[ vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_show_delay = 60 ]]
      -- TODO: Remove if nvim-treesitter-context gets line number
      vim.g.matchup_matchparen_offscreen = {['method'] = 'popup'}
    end,
    config = function ()
     vim.cmd [[hi! link MatchParen Comment]]
     vim.cmd [[hi! link MatchParenCur Comment]]
     vim.cmd [[hi! link MatchWord CursorLine]]
     vim.cmd [[hi! link MatchWordCur CursorLine]]
    end
  }
  use {
    'RRethy/vim-illuminate',
    event = 'CursorMoved',
    disable = true,
    config = function()
      vim.g.Illuminate_delay = 500
      vim.g.Illuminate_ftblacklist = { 'TelescopePrompt', 'dashboard', 'vimwiki', 'man', 'help', 'packer', 'nnn', 'lspinfo', '' }
    end
  }

  -- Motions
  use {
    {
      -- FIX: Doesn't play well with vim-illuminate
      'b0o/vim-shot-f',
      disable = true,
      setup = function()
        vim.g.shot_f_highlight_graph = "guifg='#ff007c' ctermfg=155"
        vim.g.shot_f_highlight_blank = "guibg=NONE"
      end
    },
    {
      'rhysd/clever-f.vim',
      setup = function ()
        vim.keymap.map({';', '<Plug>(clever-f-repeat-forward)', silent = true})
        vim.keymap.map({',', '<Plug>(clever-f-repeat-back)', silent = true})
        vim.keymap.nmap({'<Esc>', '<Plug>(clever-f-reset)', silent = true})

        vim.g.clever_f_smart_case = 1
        vim.g.clever_f_chars_match_any_signs = ';'
        vim.g.clever_f_fix_key_direction = 1
        vim.g.clever_f_mark_direct = 1

      end
    },
    {
      'phaazon/hop.nvim',
      keys = {'<Leader>;'},
      config = function ()
        local hop = require'hop'
        vim.keymap.nnoremap({'<Leader>;', hop.hint_words, silent = true})
        hop.setup({keys = 'asdghklwertyuipzxcvbnmfj'})
      end
    }
  }

  -- Wrap and unwrap arguments
  use {
    'FooSoft/vim-argwrap',
    setup = function ()
      vim.keymap.nnoremap({'<Leader>j', ':ArgWrap<CR>', silent = true})
    end,
    cmd = 'ArgWrap'
  }

  use {
    'AckslD/nvim-revJ.lua',
    disable = true,
    config = function()
      require'revj'.setup{
        brackets = {first = '([{<', last = ')]}>'}, -- brackets to consider surrounding arguments
        new_line_before_last_bracket = true, -- add new line between last argument and last bracket (only if no last seperator)
        add_seperator_for_last_parameter = true, -- if a seperator should be added if not present after last parameter
        enable_default_keymaps = true,
      }
    end,
    requires = {
      'kana/vim-textobj-user',
      requires = {'sgur/vim-textobj-parameter'},
    },
  }

  use {
    'mizlan/iswap.nvim',
    setup = function ()
      vim.keymap.nnoremap({'gs', ':ISwap<CR>', silent = true})
    end,
    cmd = 'ISwap',
    after = 'nvim-treesitter'
  }

  -- Comments
  use {
    'b3nj5m1n/kommentary',
    setup = function ()
      -- Disable default binds
      vim.g.kommentary_create_default_mappings = false
      vim.keymap.nmap({'gcc', '<Plug>kommentary_line_default', silent = true })
      vim.keymap.nmap({'gc', '<Plug>kommentary_motion_default', silent = true })
      vim.keymap.imap({'<C-_>', '<C-o><Plug>kommentary_line_default', silent = true })
      vim.keymap.vmap({'gc', '<Plug>kommentary_visual_default', silent = true })
    end,
    keys = {
      {'i', '<C-o><Plug>kommentary_line_default'},
      '<Plug>kommentary_line_default',
      '<Plug>kommentary_visual_default',
      '<Plug>kommentary_motion_default'
    },
    config = function()
      require'keychord'.cancel('gcc')
      local kommentary = require'kommentary.config'

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
    end
  }

  -- Autopair
  use {
    'steelsojka/pears.nvim',
    event = 'BufReadPost',
    config = [[require'modules.pears']]
  }
  -- Manipulate pairs
  use {
    'machakann/vim-sandwich',
    setup = function ()
      vim.keymap.xmap({'is', '<Plug>(textobj-sandwich-query-i)', silent = true})
      vim.keymap.xmap({'as', '<Plug>(textobj-sandwich-query-a)', silent = true})
      vim.keymap.omap({'is', '<Plug>(textobj-sandwich-query-i)', silent = true})
      vim.keymap.omap({'as', '<Plug>(textobj-sandwich-query-a)', silent = true})
    end,
    keys = {
      {'n', 'ys'},
      {'n', 'yss'},
      {'n', 'yS'},
      {'n', 'cs'},
      {'n', 'css'},
      {'n', 'ds'},
      {'n', 'dss'},
      {'x', 'S'},
      {'x', 'is'},
      {'x', 'as'},
      {'o', 'is'},
      {'o', 'as'},
    },
    config = function ()
      vim.cmd[[runtime macros/sandwich/keymap/surround.vim]]
    end
  }

  -- Color highlighting
  use {
    'DarwinSenior/nvim-colorizer.lua',
    event = 'BufReadPre',
    config = function()
      require'colorizer'.setup(_, {
        RGB = false;
        RRGGBB = true;
        RRGGBBAA = true;
        css_fn = true;
        names = false;
        mode = 'virtualtext';
        virtualtext = '■';
      })
    end
  }

  -- Increment/decrement
  use {
    'monaqa/dial.nvim',
    keys = {'<Plug>(dial-decrement)', '<Plug>(dial-increment)'},
    setup = function ()
      vim.keymap.nmap({'<C-a>', '<Plug>(dial-increment)', silent = true})
      vim.keymap.nmap({'<C-x>', '<Plug>(dial-decrement)', silent = true})
      vim.keymap.vmap({'<C-a>', '<Plug>(dial-increment)', silent = true})
      vim.keymap.vmap({'<C-x>', '<Plug>(dial-decrement)', silent = true})
    end,
    config = function ()
      local dial = require'dial'
      dial.augends["custom#small#boolean"] = dial.common.enum_cyclic{
        name = "boolean",
        strlist = {"true", "false"},
      }

      dial.augends["custom#capital#boolean"] = dial.common.enum_cyclic{
        name = "boolean",
        strlist = {"True", "False"},
      }

      dial.config.searchlist.normal = {
        'number#decimal#int',
        'markup#markdown#header',
        'custom#capital#boolean',
        'custom#small#boolean'
      }

      dial.config.searchlist.visual = {
        'number#decimal#int',
        'markup#markdown#header',
        'number#hex',
        'number#binary',
        'color#hex'
      }
    end
  }

  -- Multiple cursors
  use {
    'mg979/vim-visual-multi',
    keys ={'<C-n>', '<C-Down>', '<C-Up>'}
  }

  -- Text manipulation
  use {
    't9md/vim-textmanip',
    keys = {
      {'i','<C-o><Plug>(textmanip-move-up)'},
      {'i','<C-o><Plug>(textmanip-move-down)'},
      '<Plug>(textmanip-move-down)',
      '<Plug>(textmanip-move-up)',
      '<Plug>(textmanip-move-left)',
      '<Plug>(textmanip-move-right)',
      '<Plug>(textmanip-duplicate-down)',
      '<Plug>(textmanip-duplicate-up)'
    },
    setup = function ()
      vim.keymap.map({'<A-j>', '<Plug>(textmanip-move-down)', silent = true})
      vim.keymap.map({'<A-k>', '<Plug>(textmanip-move-up)', silent = true})
      vim.keymap.imap({'<A-j>', '<C-o><Plug>(textmanip-move-down)', silent = true})
      vim.keymap.imap({'<A-k>', '<C-o><Plug>(textmanip-move-up)', silent = true})
      vim.keymap.xmap({'<A-h>', '<Plug>(textmanip-move-left)', silent = true})
      vim.keymap.xmap({'<A-l>', '<Plug>(textmanip-move-right)', silent = true})
      vim.keymap.map({'<C-j>', '<Plug>(textmanip-duplicate-down)', silent = true})
      vim.keymap.map({'<C-k>', '<Plug>(textmanip-duplicate-up)', silent = true})
    end
  }

  -- Smooth scrolling
  use {
    'karb94/neoscroll.nvim',
    event = 'WinScrolled',
    config = [[require'neoscroll'.setup()]]
  }

  -- Peek at lines
  use {
    'nacro90/numb.nvim',
    event = 'CmdlineEnter',
    config = [[require'numb'.setup({show_cursorline = true})]]
  }

  -- Reload config
  use {
    'famiu/nvim-reload',
    keys = {'<Leader>r', '<Leader>R'},
    config = function ()
      if not packer_plugins['plenary.nvim'].loaded then
        vim.cmd[[packadd plenary.nvim]]
      end
      local rld = require'nvim-reload'
      vim.keymap.nnoremap({'<Leader>r', rld.Reload, silent = true})
      vim.keymap.nnoremap({'<Leader>R', rld.Restart, silent = true})
    end
  }

  -- Undo tree
  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    setup = function ()
      vim.g.undotree_SplitWidth = 40
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.keymap.nnoremap({'<Leader>ut', ':UndotreeToggle<CR>', silent = true})
    end,
    config = function()
      require'keychord'.cancel('<Leader>u')
    end
  }

  -- Save undo file as filepath
  use { 'pixelastic/vim-undodir-tree' }

  -- Show warning if undoing change from before
  use {
    'ram02z/undofile_warn.vim',
    event = 'BufReadPre'
  }

  -- Make directory if it doesn't exist
  use {'pbrisbin/vim-mkdir'}

  -- Remove annoying search highlighting
  use {
    'romainl/vim-cool',
    event = 'InsertEnter',
  }

  -- Remember last position in file
  use {
    'ethanholz/nvim-lastplace',
    event = 'BufReadPre',
    config = [[require'nvim-lastplace'.setup()]]
  }

  -- Quickfix settings
  use {
    'romainl/vim-qf',
    event = {'FileType qf', 'QuickFixCmdPost'},
    config = function()
      vim.g.qf_shorten_path = 3
      vim.keymap.nmap({'<Leader>qq', '<Plug>(qf_qf_toggle)', silent = true})
      vim.keymap.nmap({'<Leader>ql', '<Plug>(qf_loc_toggle)', silent = true})
      vim.keymap.nmap({'<Leader>qs', '<Plug>(qf_qf_switch)', silent = true})
      vim.keymap.nmap({']q', '<Plug>(qf_qf_previous)', silent = true})
      vim.keymap.nmap({'[q', '<Plug>(qf_qf_next)', silent = true})
      vim.keymap.nmap({']l', '<Plug>(qf_loc_previous)', silent = true})
      vim.keymap.nmap({'[l', '<Plug>(qf_loc_next)', silent = true})
      require'keychord'.cancel('<Leader>q')
    end
  }

  -- Profiling
  use {'dstein64/vim-startuptime', cmd = 'StartupTime'}

end)
