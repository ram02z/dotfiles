local colors = require("modules.feline.utils").colors

local disable = {
  filetypes = {},
  buftypes = {},
  bufnames = {},
}

-- Initialize the components table
local components = {
  active = {
    {},
  },
  inactive = {
    {},
  },
}

disable.filetypes = {
  "Outline",
  "undotree",
  "DiffviewFileHistory",
  "DiffviewFiles",
  "TelescopePicker",
  "TelescopePrompt",
  "toggleterm",
}


disable.buftypes = {
  "terminal",
  "prompt",
  "nofile",
  "nowrite",
}

table.insert(components.active[1], {
  provider = "",
  hl = { fg = "red", bg = colors.bg },
  right_sep = " ",
  enabled = function()
      return vim.bo.readonly
  end,
})

table.insert(components.active[1], {
  provider = {
    name = "file_info",
    opts = {
      type = "relative",
      file_modified_icon = "",
      file_readonly_icon = "",
    },
  },
  icon = "",
  hl = { bg = colors.bg },
  left_sep = "left_filled",
  right_sep = function()
      local val = {}
      val.hl = { fg = "red" }
      if vim.bo.modified then
          val.str = "*"
      else
          val.str = " "
      end

      return val
  end,
})

table.insert(components.active[1], {
  provider = "",
  hl = { bg = "None" },
})

components.inactive = components.active

require("feline").winbar.setup({
  components = components,
  disable = disable,
})
