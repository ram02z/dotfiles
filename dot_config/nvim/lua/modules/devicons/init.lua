local icons = require("modules.devicons.mapping")

local function get(name)
  return vim.fn.nr2char(icons[name])
end

require "nvim-web-devicons".setup {
  default = true
}

return {
  get = get
}
