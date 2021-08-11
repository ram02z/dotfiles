local M = {}

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Checks if prev col doesn't exist
M.invalid_prev_col = function()
  local lnum, col_no = unpack(vim.api.nvim_win_get_cursor(0))
  if col_no == 0 then return true end
  local line = unpack(vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false))
  for i = col_no, 1, -1 do
    local prev_col = line:sub(i, i)
    if prev_col ~= " " then
      return false
    end
  end
end

-- Usage for current buffer
-- local lnum, _ = unpack(vim.api.nvim_win_get_cursor(0))
-- local buf = vim.api.nvim_get_current_buf()
-- require'utils.misc'.is_comment(buf, lnum - 1)
-- This method returns nil if this buf doesn't have a treesitter parser
-- @return true or false otherwise
M.is_comment = function(buf, line)
  local highlighter = require("vim.treesitter.highlighter")
  local hl = highlighter.active[buf]

  if not hl then
    return
  end

  local is_comment = false
  hl.tree:for_each_tree(function(tree, lang_tree)
    if is_comment then
      return
    end

    local query = hl:get_query(lang_tree:lang())
    if not (query and query:query()) then
      return
    end

    local iter = query:query():iter_captures(tree:root(), buf, line, line + 1)

    for capture, _ in iter do
      if query._query.captures[capture] == "comment" then
        is_comment = true
      end
    end
  end)
  return is_comment
end

-- NOTE: just use vim.inspect
-- From https://gist.github.com/ripter/4270799
-- M.tprint = function(tbl, indent)
--   indent = indent or 0
--   for k, v in pairs(tbl) do
--     local formatting = string.rep("  ", indent) .. k .. ": "
--     if type(v) == "table" then
--       print(formatting)
--       M.tprint(v, indent+1)
--     elseif type(v) == 'boolean' then
--       print(formatting .. tostring(v))
--     else
--       print(formatting .. v)
--     end
--   end
-- end

-- nvim_echo wrappers
function M.log(body, head, hl)
  hl = hl or "MsgArea"
  head = head or "[LOG]"
  vim.api.nvim_echo({ { head, hl }, { " " }, { body } }, true, {})
end

function M.note(body, head)
  head = head or "[NOTE]"
  M.log(body, head, "Todo")
end

function M.warn(body, head)
  head = head or "[WARNING]"
  M.log(body, head, "WarningMsg")
end

function M.error(body, head)
  head = head or "[ERROR]"
  M.log(body, head, "Error")
end

-- Returns path seperator based on OS
M.pathSep = function()
  local os = string.lower(U.os.name)
  if os == "linux" or os == "osx" or os == "bsd" then
    return "/"
  else
    return "\\"
  end
end

-- Returns path without last string
M.dirName = function(path, sep)
  sep = sep or M.pathSep()
  return path:match(".*" .. sep)
end

-- Returns last string in path
M.baseName = function(path, sep)
  sep = sep or M.pathSep()
  local split = vim.split(path, sep)

  return split[#split]
end

-- Expects undo files to be directories
-- TODO: check if files are undo files
-- TODO: handle swap files maybe?
M.purge_old_undos = function()
  local ok = pcall(require, "plenary")
  if not ok then
    M.warn("Plenary is not installed", "[PURGEUNDOS]")
    return
  end

  local scan = require("plenary.scandir")

  local dir = vim.api.nvim_get_option("undodir")
  if dir == "" then
    print("undodir not set")
    return
  end

  local files = scan.scan_dir(dir, { hidden = true })

  local P = require("plenary.path")
  local flag = 0
  for i, file in ipairs(files) do
    local rel_path = string.gsub(file, dir, "")
    if P:new(rel_path):is_file() == nil then
      P:new(file):rm()

      local parent = P:new(M.dirName(file))
      if parent:is_dir() then
        local dirs = scan.scan_dir(parent, { add_dirs = true, hidden = true })
        for x = #dirs, 1, -1 do
          P:new(dirs[x]):rm()
        end
        parent:rm()
      end
      M.note("Removed " .. file, "[PURGEUNDOS]")
      flag = i
    end
  end
  if flag == 0 then
    M.note("undodir is clean", "[PURGEUNDOS]")
  end
end

M.toggle_qf = function()
  local qf_open = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_open = true
    end
  end
  if qf_open == true then
    vim.cmd("cclose")
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd("copen")
  end
end

M.toggle_loc = function()
  local loc_open = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["loclist"] == 1 then
      loc_open = true
    end
  end
  if loc_open == true then
    vim.cmd("lclose")
    return
  end
  if not vim.tbl_isempty(vim.fn.getloclist(0)) then
    vim.cmd("lopen")
  end
end

return M
