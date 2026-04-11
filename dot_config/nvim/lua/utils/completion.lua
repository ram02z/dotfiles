local uv = vim.uv or vim.loop

local M = {}

local function current_line_before_cursor()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1] or ""
  return line:sub(1, col), col
end

local function current_buffer_dir()
  return vim.fn.expand(("#%d:p:h"):format(vim.api.nvim_get_current_buf()))
end

local function is_slash_comment()
  local commentstring = vim.bo.commentstring or ""
  local no_filetype = vim.bo.filetype == ""
  local slash_comment = commentstring:match("/%*") or commentstring:match("//")
  return slash_comment and not no_filetype
end

local function is_valid_absolute_prefix(prefix)
  if prefix:match("%a+:%s*$") then
    return false
  end

  if prefix:match("</%s*$") then
    return false
  end

  if prefix:match("[%d%)]%s*$") then
    return false
  end

  if prefix:match("^[%s/]*$") and is_slash_comment() then
    return false
  end

  return true
end

local function detect_path_context(line)
  local start_col, _, _, token = line:find("([\"'])([%./~$][^\"']*)$")
  if start_col and token then
    return start_col + 1, token
  end

  start_col, _, token = line:find("(%$[%a_][%w_]*/[^%s\"'`|<>]*)$")
  if start_col and token then
    return start_col, token
  end

  start_col, _, token = line:find("(~/[^%s\"'`|<>]*)$")
  if start_col and token then
    return start_col, token
  end

  start_col, _, token = line:find("(%.%./[^%s\"'`|<>]*)$")
  if start_col and token then
    return start_col, token
  end

  start_col, _, token = line:find("(%./[^%s\"'`|<>]*)$")
  if start_col and token then
    return start_col, token
  end

  start_col, _, token = line:find("(/[^%s\"'`|<>]*)$")
  if start_col and token and is_valid_absolute_prefix(line:sub(1, start_col - 1)) then
    return start_col, token
  end

  return nil
end

local function split_token(token)
  local dirname, partial = token:match("^(.*[/])([^/]*)$")
  return dirname, partial or ""
end

local function resolve_dir(dirname)
  if dirname:match("^%./") or dirname:match("^%.%./") then
    return vim.fs.normalize(current_buffer_dir() .. "/" .. dirname)
  end

  if dirname:match("^~/") then
    return vim.fs.normalize(vim.fn.expand("~") .. dirname:sub(2))
  end

  local env_var = dirname:match("^%$([%a_][%w_]*)/")
  if env_var then
    local value = vim.fn.getenv(env_var)
    if value ~= vim.NIL and value ~= "" then
      return vim.fs.normalize(value .. dirname:sub(#env_var + 2))
    end
  end

  if dirname:match("^/") then
    return vim.fs.normalize(dirname)
  end

  return nil
end

local function scandir_matches(path, partial)
  local fs, err = uv.fs_scandir(path)
  if not fs or err then
    return {}
  end

  local include_hidden = partial:sub(1, 1) == "."
  local items = {}

  while true do
    local name, file_type = uv.fs_scandir_next(fs)
    if not name then
      break
    end

    if (include_hidden or name:sub(1, 1) ~= ".") and name:sub(1, #partial) == partial then
      local is_dir = file_type == "directory"
      items[#items + 1] = {
        word = is_dir and (name .. "/") or name,
        abbr = is_dir and (name .. "/") or name,
        menu = "[path]",
        kind = is_dir and "d" or "f",
      }
    end
  end

  table.sort(items, function(a, b)
    if a.kind ~= b.kind then
      return a.kind == "d"
    end

    return a.abbr < b.abbr
  end)

  return items
end

function M.path_complete(findstart, base)
  local line, cursor_col = current_line_before_cursor()
  local start_col, token = detect_path_context(line)

  if findstart == 1 then
    if not start_col or not token then
      return cursor_col
    end

    local dirname, _ = split_token(token)
    if not dirname then
      return cursor_col
    end

    return start_col + #dirname - 1
  end

  if not start_col or not token then
    return {}
  end

  local dirname = split_token(token)
  local path = dirname and resolve_dir(dirname)
  if not path then
    return {}
  end

  return scandir_matches(path, base)
end

_G.native_path_complete = M.path_complete

return M
