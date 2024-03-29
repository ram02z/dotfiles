local vi_mode_utils = require("feline.providers.vi_mode")
local colors = require("modules.feline.utils").colors
local vi_mode_colors = require("modules.feline.utils").vi_mode_colors

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
      bg = vi_mode_utils.get_mode_color(),
      fg = colors.bg,
    }
  end,
  right_sep = " ",
})

table.insert(components.active[1], {
  provider = function()
    local name = os.getenv("VIRTUAL_ENV")
    return string.format("(%s)", vim.fs.basename(name))
  end,
  hl = { fg = "light_gray" },
  right_sep = " ",
  truncate_hide = true,
  enabled = function()
    return os.getenv("VIRTUAL_ENV") ~= nil
  end,
})

table.insert(components.active[1], {
  provider = "file_type",
  hl = { fg = "light_gray" },
  enabled = function()
    return vim.bo.buftype == ""
  end,
  right_sep = " ",
})

table.insert(components.active[1], {
  provider = "file_size",
  hl = { fg = "light_gray" },
  enabled = function()
    return vim.bo.buftype == "" and vim.bo.filetype ~= ""
  end,
  truncate_hide = true,
  right_sep = " ",
})

table.insert(components.active[1], {
  provider = "diagnostic_errors",
  hl = { fg = "red" },
  truncate_hide = true,
})

table.insert(components.active[1], {
  provider = "diagnostic_warnings",
  hl = { fg = "orange" },
  truncate_hide = true,
})

table.insert(components.active[1], {
  provider = "diagnostic_hints",
  hl = { fg = "yellow" },
  icon = "  ",
  truncate_hide = true,
})

table.insert(components.active[1], {
  provider = "diagnostic_info",
  hl = { fg = "cyan" },
  truncate_hide = true,
})

table.insert(components.active[1], {
  provider = function()
    local vm_info = vim.fn["g:VMInfos"]()
    return vm_info.ratio
  end,
  hl = { fg = "light_gray" },
  left_sep = " ",
  enabled = function()
    return vim.b.visual_multi
  end,
})

--
-- Right active components
--
table.insert(components.active[2], {
  provider = "git_diff_added",
  hl = {
    fg = "green",
  },
  icon = " +",
  truncate_hide = true,
  priority = 1,
})

table.insert(components.active[2], {
  provider = "git_diff_changed",
  hl = {
    fg = "orange",
  },
  icon = " ~",
  truncate_hide = true,
  priority = 1,
})

table.insert(components.active[2], {
  provider = "git_diff_removed",
  hl = {
    fg = "red",
  },
  icon = " -",
  truncate_hide = true,
  priority = 1,
})

table.insert(components.active[2], {
  provider = "git_branch",
  hl = {
    fg = "pink",
  },
  icon = "  ",
  left_sep = " ",
  truncate_hide = true,
  priority = 2,
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

    local git_basename = vim.fs.basename(vim.b.gitsigns_status_dict["root"])
    cached_git_dirs[cwd] = git_basename

    return git_basename
  end,
  enabled = function()
    return vim.b.gitsigns_status_dict
  end,
  truncate_hide = true,
  hl = {
    fg = "cyan",
    style = "bold",
  },
  left_sep = " ",
})

table.insert(components.active[2], {
  provider = function()
    local current_tabpage = vim.api.nvim_get_current_tabpage()
    local no_tabpages = #vim.api.nvim_list_tabpages()

    return current_tabpage .. "/" .. no_tabpages
  end,
  hl = {
    fg = "white",
  },
  left_sep = " ",
  truncate_hide = true,
})

table.insert(components.active[2], {
  provider = "position",
  hl = {
    fg = "light_gray",
  },
  left_sep = " ",
  right_sep = " ",
  truncate_hide = true,
  priority = 1,
})

table.insert(components.active[2], {
  provider = "scroll_bar",
  hl = {
    fg = "light_gray",
  },
  left_sep = " ",
  truncate_hide = true,
})

--
-- Inactive components
--

table.insert(components.inactive[1], {
  provider = function()
    local mode = vi_mode_utils.get_vim_mode()
    if #mode > 0 then
      return " " .. mode:sub(1, 1) .. " "
    end
    return " // "
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
  theme = colors,
  components = components,
  force_inactive = force_inactive,
  vi_mode_colors = vi_mode_colors,
})
