local M = {}

-- TODO: telescope.nvim #765
local opts = {
  theme = "ivy",

  sorting_strategy = "ascending",

  preview_title = "",

  layout_strategy = "bottom_pane",
  layout_config = {
    height = 10,
  },

  border = true,
  borderchars = {
    "z",
    prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
    results = { " " },
    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰"},
  }
}

M.project_files = function()
  opts['cwd'] = vim.fn.expand('%:p:h')
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then
    require'telescope.builtin'.find_files(opts)
  end
end

M.grep_cwd = function()
  require'telescope.builtin'.live_grep(opts)
end

M.grep_buffers = function()
  opts['grep_open_files'] = true
  require'telescope.builtin'.live_grep(opts)
end

return M
