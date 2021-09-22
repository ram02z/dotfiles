local M = {}

local cached_tabs = {}

local disabled_fts = {
  "Outline",
  "undotree",
  "DiffviewFileHistory",
  "DiffviewFiles",
}

-- TODO: implement click tab switching
M.tabline = function()
  local cur_win, cur_buf, buf_name
  local line = ""
  local tabs = vim.api.nvim_list_tabpages()
  local cur_tab = vim.api.nvim_get_current_tabpage()

  for _, tab in ipairs(tabs) do
    cur_win = vim.api.nvim_tabpage_get_win(tab)
    cur_buf = vim.api.nvim_win_get_buf(cur_win)
    if tab == cur_tab then
      line = line .. "%#TabLineSel#"
    else
      line = line .. "%#TabLine#"
    end
    line = line .. " "
    buf_name = vim.api.nvim_buf_get_name(cur_buf)
    if
      buf_name == ""
      or vim.api.nvim_win_get_config(curr_win).relative ~= ""
      or vim.tbl_contains(disabled_fts, vim.bo[cur_buf].filetype)
    then
      buf_name = "[No Name]"
      if vim.bo[cur_buf].filetype ~= "" and cached_tabs[tab] then
        buf_name = cached_tabs[tab]
      end
    else
      buf_name = vim.fn.fnamemodify(buf_name, ":~:.")
      if vim.bo[cur_buf].modified then
        if tab == cur_tab then
          buf_name = buf_name .. "%#DraculaRed#"
        end
        buf_name = buf_name .. "*"
      else
        buf_name = buf_name .. " "
      end
      cached_tabs[tab] = buf_name
    end
    line = line .. buf_name
  end

  return line .. "%#TabLine#"
end

return M
