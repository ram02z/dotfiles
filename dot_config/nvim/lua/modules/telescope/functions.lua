local M = {}
local cwd_opt = {
  cwd = vim.fn.expand("%:p:h"),
}

M.project_files = function()
  local ok = pcall(require'telescope.builtin'.git_files)
  if not ok then
    require'telescope.builtin'.find_files(cwd_opt)
  end
end

M.grep_cwd = function()
  require'telescope.builtin'.live_grep(cwd_opt)
end

M.grep_buffers = function()
  require'telescope.builtin'.live_grep({
    grep_open_files = true,
  })
end

M.old_files = function()
  local ok = pcall(require'telescope'.extensions.frecency.frecency)
  if not ok then
    require'telescope.builtin'.oldfiles()
  end
end

return M
