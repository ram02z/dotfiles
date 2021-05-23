local gl = require('galaxyline')
local condition = require('galaxyline.condition')
-- local diagnostic = require('galaxyline.provider_diagnostic')

local gls = gl.section
gl.short_line_list = {'nnn', 'undotree', 'TelescopePrompt', 'help'}

local colors = {
  bg = '#21232b',
  fg = '#f8f8f2',
  section_bg = '#3a3c4e',
  blue = '#62d6e8',
  green = '#50fa8b',
  purple = '#bd93f9',
  orange = '#ffb86c',
  red1 = '#ff5555',
  red2 = '#ea51b2',
  pink = '#ff69c6',
  yellow = '#f1fa8c',
  gray1 = '#626483',
  gray2 = '#44475a',
  gray3 = '#3a3c4e',
  darkgrey = '#4d4f68',
  grey = '#848586',
  middlegrey = '#8791A5'
}


local mode_map = {
  [110]  = {'NORMAL', colors.purple},
  [105]  = {'INSERT', colors.green},
  [82]   = {'REPLACE', colors.red1},
  [118]  = {'VISUAL', colors.yellow},
  [86]   = {'V-LINE', colors.yellow},
  [99]   = {'COMMAND', colors.orange},
  [115]  = {'SELECT', colors.red2},
  [83]   = {'S-LINE', colors.red2},
  [116]  = {'TERMINAL', colors.gray1},
  [22]   = {'V-BLOCK', colors.blue},
}

-- Local helper functions
local function has_value(tab, val)
  for _, value in ipairs(tab) do
    if value[1] == val then return true end
  end
  return false
end

local function is_buffer_empty()
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

local function no_buffers()
  return #vim.fn.getbufinfo({buflisted = 1})
end

local function has_width_gt(cols)
  return vim.fn.winwidth(0) / 2 > cols
end

local buffer_not_empty = function() return not is_buffer_empty() end

local checkwidth = function()
  return has_width_gt(35) and buffer_not_empty()
end


local function file_readonly()
  if vim.bo.filetype == 'help' then return '' end
  if vim.bo.readonly == true then return '' end
  return ''
end

local function get_current_file_name()
  local file = vim.fn.expand('%:t')
  if vim.fn.empty(file) == 1 then return '' end
  if string.len(file_readonly()) ~= 0 then return file .. file_readonly() end
  if vim.bo.modifiable and no_buffers() < 2 then
    if vim.bo.modified then return file .. ' + ' end
  end
  return file .. ' '
end

local function highlight(group, fg, bg, gui)
  local cmd = string.format('highlight %s guifg=%s guibg=%s', group, fg, bg)
  if gui ~= nil then cmd = cmd .. ' gui=' .. gui end
  vim.cmd(cmd)
end

local function mode_label()
  local mode = mode_map[vim.fn.mode():byte()]
  if mode ~= nil then
    return mode[1]
  end
  return "N/A"
end

local function mode_hl()
  local mode = mode_map[vim.fn.mode():byte()]
  if mode ~= nil then
    return mode[2]
  end
  return colors.darkgrey
end

-- local function trailing_whitespace()
  --     local trail = vim.fn.search('\\s$', 'nw')
  --     if trail ~= 0 then
  --         return '  '
  --     else
  --         return nil
  --     end
  -- end

  -- local function tab_indent()
  --     local tab = vim.fn.search('^\\t', 'nw')
  --     if tab ~= 0 then
  --         return ' → '
  --     else
  --         return nil
  --     end
  -- end

  -- local function buffers_count()
  --     local buffers = {}
  --     for _, val in ipairs(vim.fn.range(1, vim.fn.bufnr('$'))) do
  --         if vim.fn.bufexists(val) == 1 and vim.fn.buflisted(val) == 1 then
  --             table.insert(buffers, val)
  --         end
  --     end
  --     return #buffers
  -- end

local function get_basename(file) return file:match("^.+/(.+)$") end

local GetGitRoot = function()
  local git_dir = require('galaxyline.provider_vcs').get_git_dir()
  if not git_dir then return '' end

  local git_root = git_dir:gsub('/.git/?$', '')
  return get_basename(git_root)
end

--[[ local LspStatus = function()
  -- if #vim.lsp.buf_get_clients() > 0 then
  if #vim.lsp.get_active_clients() > 0 then
    return require'lsp-status'.status()
  end
  return ''
end ]]

--[[ local LspCheckDiagnostics = function()
  if #vim.lsp.get_active_clients() > 0 and diagnostic.get_diagnostic_error() ==
    nil and diagnostic.get_diagnostic_warn() == nil and
    diagnostic.get_diagnostic_info() == nil then return ' ' end
    return ''
end ]]

-- Left side
gls.left[2] = {
  ViMode = {
    provider = function()
      local modehl = mode_hl()
      highlight('GalaxyViMode', colors.bg, modehl, 'bold')
      if buffer_not_empty() then
        highlight('GalaxyViModeInv', modehl, colors.section_bg, 'bold')
      else
        highlight('GalaxyViModeInv', modehl, colors.bg, 'bold')
      end
      return string.format('  %s ', mode_label())
    end,
    separator = '',
    separator_highlight = 'GalaxyViModeInv',
  }
}
gls.left[3] = {
  FileIcon = {
    provider = {function() return ' ' end, 'FileIcon'},
    condition = buffer_not_empty,
    highlight = {
      require('galaxyline.provider_fileinfo').get_file_icon,
      colors.section_bg
    }
  }
}
gls.left[4] = {
  FileName = {
    provider = get_current_file_name,
    condition = buffer_not_empty,
    highlight = {colors.fg, colors.section_bg},
    separator = '',
    separator_highlight = {colors.section_bg, colors.bg}
  }
}


--[[ gls.left[8] = {
  DiagnosticsCheck = {
    provider = {LspCheckDiagnostics},
    highlight = {colors.middlegrey, colors.bg}
  }
} ]]
gls.left[9] = {
  DiagnosticError = {
    provider = {'DiagnosticError'},
    icon = '  ',
    highlight = {colors.red1, colors.bg}
    -- separator = ' ',
    -- separator_highlight = {colors.bg, colors.bg}
  }
}
-- gls.left[10] = {
--     Space = {
--         provider = function() return ' ' end,
--         highlight = {colors.section_bg, colors.bg}
--     }
-- }
gls.left[11] = {
  DiagnosticWarn = {
    provider = {'DiagnosticWarn'},
    icon = '  ',
    highlight = {colors.orange, colors.bg}
    -- separator = ' ',
    -- separator_highlight = {colors.bg, colors.bg}
  }
}
-- gls.left[12] = {
--     Space = {
--         provider = function() return ' ' end,
--         highlight = {colors.section_bg, colors.bg}
--     }
-- }
gls.left[13] = {
  DiagnosticInfo = {
    provider = {'DiagnosticInfo'},
    icon = '  ',
    highlight = {colors.blue, colors.bg}
    -- separator = ' ',
    -- separator_highlight = {colors.section_bg, colors.bg}
  }
}
--[[ gls.left[14] = {
  LspStatus = {
    provider = {LspStatus},
    -- separator = ' ',
    -- separator_highlight = {colors.bg, colors.bg},
    highlight = {colors.middlegrey, colors.bg}
  }
} ]]

gls.right[1] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = '+',
    highlight = {colors.green, colors.bg},
    separator = ' ',
    separator_highlight = {colors.section_bg, colors.bg}
  }
}
gls.right[2] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = '~',
    highlight = {colors.orange, colors.bg}
  }
}
gls.right[3] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = '-',
    highlight = {colors.red1, colors.bg}
  }
}
gls.right[4] = {
  Space = {
    provider = function() return ' ' end,
    highlight = {colors.section_bg, colors.bg}
  }
}
gls.right[6] = {
  GitBranch = {
    provider = {function() return '  ' end, 'GitBranch'},
    condition = condition.check_git_workspace,
    highlight = {colors.pink, colors.bg}
  }
}
gls.right[7] = {
  GitRoot = {
    provider = {GetGitRoot},
    condition = function()
      return has_width_gt(50) and condition.check_git_workspace
    end,
    -- icon = '  ',
    highlight = {colors.blue, colors.bg},
    separator = ' ',
    separator_highlight = {colors.bg, colors.bg}
    -- separator = ' ',
    -- separator_highlight = {colors.section_bg, colors.bg}
  }
}
gls.right[8] = {
  PositionInfo = {
    provider = {
      function()
        return string.format(
        '%s:%s', vim.fn.line('.'), vim.fn.col('.')
        )
      end,
    },
    highlight = {colors.middlegrey, colors.bg},
    condition = buffer_not_empty,
    separator = ' ',
    separator_highlight = {colors.bg, colors.bg}
  }
}
-- gls.right[9] = {
--     ScrollBar = {
--         provider = 'ScrollBar',
--         highlight = {colors.purple, colors.section_bg}
--     }
-- }

-- Short status line
gls.short_line_left[1] = {
  FileIcon = {
    provider = {function() return '  ' end, 'FileIcon'},
    condition = function()
      return buffer_not_empty and
      has_value(gl.short_line_list, vim.bo.filetype)
    end,
    highlight = {
      require('galaxyline.provider_fileinfo').get_file_icon,
      colors.section_bg
    }
  }
}
gls.short_line_left[2] = {
  FileName = {
    provider = get_current_file_name,
    condition = buffer_not_empty,
    highlight = {colors.fg, colors.section_bg},
    separator = ' ',
    separator_highlight = {colors.section_bg, colors.bg}
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider = 'BufferIcon',
    highlight = {colors.yellow, colors.section_bg},
    separator = '',
    separator_highlight = {colors.section_bg, colors.bg}
  }
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
