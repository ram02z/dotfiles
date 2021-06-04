local M = {}

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

M.check_not_comment = function()
  local success = pcall(require, "nvim-treesitter.ts_utils")
  if not success then return true end
  local node = require'nvim-treesitter.ts_utils'.get_node_at_cursor()
  -- If treesitter breaks, return false
  if node == nil then return false end
  -- Not sure if source == comment
  if node:type() == "source"  then
    return true
  else
    return false
  end
end

M.getPath = function(str)
  return str:match("(.*[/\\])")
end

-- Expects undo files to be directories
-- TODO: check if files are undo files
-- TODO: Could probably remove the plenary dependancy
M.purge_old_undos = function()
  if not packer_plugins['plenary.nvim'].loaded then
    vim.cmd[[packadd plenary.nvim]]
  end
  local scan = require'plenary.scandir'

  local dir = vim.api.nvim_get_option('undodir')
  if dir == "" then print("undodir not set") return -1 end

  local files = scan.scan_dir(dir, { hidden = true })

  local P = require'plenary.path'
  local x = 0
  for i,file in ipairs(files) do
    local rel_path = string.gsub(file, dir, "")
    if P:new(rel_path):is_file() == nil then
      P:new(file):rm()

      local parent = P:new(M.getPath(file))
      if parent:is_dir() then
        local dirs = scan.scan_dir(parent, { add_dirs = true, hidden = true })
        for i = #dirs, 1, -1 do
          P:new(dirs[i]):rm()
        end
        parent:rm()
      end
      print("Removed " .. file)
      x = i
    end
  end
  if x == 0 then print("undodir is clean") end
end

return M
