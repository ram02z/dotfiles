local vi_mode_utils = require("feline.providers.vi_mode")

local force_inactive = {
  filetypes = {},
  buftypes = {},
  bufnames = {},
}

-- Initialize the components table
local components = {
  active = {
    {}, -- left
    {}, -- right
  },
  inactive = {
    {},
  },
}

force_inactive.filetypes = {
  "packer",
  "undotree",
  "Outline",
  "help",
  "nnn",
  "toggleterm",
  "TelescopePrompt",
  "TelescopeResults",
  "tsplayground",
  "fzf",
  "qf",
}

force_inactive.buftypes = {
  "terminal",
  "prompt",
  "nofile",
  "nowrite",
}

--
-- Helper functions
--

-- Returns true if 1/2 window width is greater than cols
local has_width_gt = function(cols, winid)
  winid = winid or 0
  return vim.api.nvim_win_get_width(winid) / 2 > cols
end

-- Returns number of buffers
local no_buffers = function()
  return #vim.fn.getbufinfo({ buflisted = 1 })
end

-- Dracula-esque colors
local colors = {
  bg = "#21222C",
  fg = "#F8F8F2",
  gray = "#3A3C4E",
  light_gray = "#8791A5",
  purple = "#BD93F9",
  cyan = "#62D6E8",
  green = "#50FA8B",
  orange = "#FFB86C",
  red = "#FF5555",
  magenta = "#EA51B2",
  pink = "#FF79C6",
  yellow = "#F1FA8C",
}

-- This table is equal to the default vi_mode_colors table
local vi_mode_colors = {
  NORMAL = "purple",
  OP = "purple",
  INSERT = "green",
  VISUAL = "yellow",
  LINES = "yellow",
  BLOCK = "cyan",
  REPLACE = "red",
  ["V-REPLACE"] = "red",
  ENTER = "cyan",
  MORE = "cyan",
  SELECT = "magenta",
  COMMAND = "orange",
  SHELL = "orange",
  TERM = "orange",
  NONE = "purple",
}

-- HACK: figure out which components are most important on smaller windows
-- Possibly create a system that prioritises based on the enabled components
-- and screen size

--
-- Left active components
--
table.insert(components.active[1], {
  provider = function()
    local mode = vi_mode_utils.get_vim_mode()
    if #mode > 0 then
      return " " .. mode:sub(1, 1) .. " "
    end
    return " // "
  end,
  hl = function()
    return {
      name = vi_mode_utils.get_mode_highlight_name(),
      bg = vi_mode_utils.get_mode_color(),
      fg = colors.bg,
    }
  end,
  right_sep = " ",
})

table.insert(components.active[1], {
  provider = "",
  hl = { fg = "red" },
  right_sep = " ",
  enabled = function()
    return vim.bo.readonly
  end,
})

table.insert(components.active[1], {
  provider = function()
    local file_name = "%f"
    if not has_width_gt(55) then
      file_name = "%t"
    end

    if file_name == "" then
      file_name = "[No Name]"
    end

    return file_name
  end,
  enabled = function()
    -- Nvim-bufferline shows them instead
    return no_buffers() == 1
  end,
  right_sep = function()
    local val = {}
    if vim.bo.modified then
      val.hl = { fg = "red" }
      val.str = "* "
    else
      val.str = "  "
    end

    return val
  end,
})

table.insert(components.active[1], {
  provider = "file_type",
  hl = { fg = "light_gray" },
  enabled = function()
    return vim.bo.buftype == "" and has_width_gt(25)
  end,
  right_sep = " ",
})

table.insert(components.active[1], {
  provider = "file_size",
  hl = { fg = "light_gray" },
  enabled = function()
    return vim.bo.buftype == "" and vim.bo.filetype ~= "" and has_width_gt(30)
  end,
  -- right_sep = ' '
})

table.insert(components.active[1], {
  provider = "diagnostic_errors",
  enabled = function()
    return no_buffers() == 1 and has_width_gt(40)
  end,
  hl = { fg = "red" },
})

table.insert(components.active[1], {
  provider = "diagnostic_warnings",
  enabled = function()
    return no_buffers() == 1 and has_width_gt(40)
  end,
  hl = { fg = "orange" },
})

table.insert(components.active[1], {
  provider = "diagnostic_hints",
  enabled = function()
    return no_buffers() == 1 and has_width_gt(40)
  end,
  hl = { fg = "cyan" },
})

table.insert(components.active[1], {
  provider = "diagnostic_info",
  enabled = function()
    return no_buffers() == 1 and has_width_gt(40)
  end,
  hl = { fg = "cyan" },
})

--
-- Right active components
--
table.insert(components.active[2], {
  provider = "git_diff_added",
  enabled = function()
    return has_width_gt(30)
  end,
  hl = {
    fg = "green",
  },
  icon = " +",
})

table.insert(components.active[2], {
  provider = "git_diff_changed",
  enabled = function()
    return has_width_gt(30)
  end,
  hl = {
    fg = "orange",
  },
  icon = " ~",
})

table.insert(components.active[2], {
  provider = "git_diff_removed",
  enabled = function()
    return has_width_gt(30)
  end,
  hl = {
    fg = "red",
  },
  icon = " -",
  right_sep = function()
    local val = {}
    if vim.b.gitsigns_status_dict then
      val.str = " "
    else
      val.str = ""
    end

    return val
  end,
})

table.insert(components.active[2], {
  provider = "git_branch",
  hl = {
    fg = "pink",
  },
  icon = "  ",
})

local cached_git_dirs = {}

table.insert(components.active[2], {
  provider = function()
    local cwd = vim.loop.cwd()

    if not vim.tbl_isempty(cached_git_dirs) then
      local keys = vim.tbl_keys(cached_git_dirs)
      for i = 1, #keys do
        if keys[i] == cwd then
          return cached_git_dirs[keys[i]]
        end
      end
    end

    local baseName = require("utils.misc").baseName
    local git_basename = baseName(vim.b.gitsigns_status_dict["root"])
    cached_git_dirs[cwd] = git_basename

    return git_basename
  end,
  enabled = function()
    return vim.b.gitsigns_status_dict and has_width_gt(50)
  end,
  hl = {
    fg = "cyan",
    style = "bold",
  },
  left_sep = function()
    local val = {}
    if vim.b.gitsigns_status_dict then
      val.str = " "
    else
      val.str = ""
    end

    return val
  end,
})

table.insert(components.active[2], {
  provider = "position",
  enabled = function()
    return has_width_gt(25)
  end,
  hl = {
    fg = "light_gray",
  },
  left_sep = " ",
  right_sep = " ",
})

table.insert(components.active[2], {
  provider = "scroll_bar",
  hl = {
    fg = "light_gray",
  },
  left_sep = function()
    local val = {}
    if has_width_gt(25) then
      val.str = ""
    else
      val.str = " "
    end

    return val
  end,
})

--
-- Inactive components
--
local get_char = require("utils.window").get_char
-- TODO: add window character if the window is not active
table.insert(components.inactive[1], {
  provider = function(_, winid)
    return " "..get_char(vim.api.nvim_win_get_number(winid)).." "
  end,
  hl = function()
    return {
      bg = vi_mode_utils.get_mode_color(),
      fg = colors.bg,
    }
  end,
  right_sep = " ",
})

table.insert(components.inactive[1], {
  provider = "file_type",
  hl = { fg = "light_gray" },
})

require("feline").setup({
  colors = colors,
  components = components,
  force_inactive = force_inactive,
  vi_mode_colors = vi_mode_colors,
})
