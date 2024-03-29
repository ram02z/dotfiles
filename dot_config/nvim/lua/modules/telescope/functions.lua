local M = {}

-- Default config
local opts = {
  layout_strategy = "flex",
  scroll_strategy = "cycle",
  layout_config = {
    center = {
      preview_cutoff = 40,
    },
    cursor = {
      preview_cutoff = 40,
    },
    height = 0.9,
    horizontal = {
      preview_cutoff = 120,
      prompt_position = "bottom",
    },
    vertical = {
      preview_cutoff = 40,
    },
    width = 0.9,
  },
  borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
}

M.keymaps = function()
  require("telescope.builtin").keymaps(opts)
end

M.commands = function()
  require("telescope.builtin").commands(opts)
end

return M
