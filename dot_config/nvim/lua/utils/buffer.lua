local M = {}

-- Function from https://github.com/ojroques/nvim-bufdel
M.bufwipeout = function()
  local buflisted = vim.fn.getbufinfo({buflisted = 1})
  local cur_winnr, cur_bufnr = vim.fn.winnr(), vim.fn.bufnr()
  if #buflisted < 2 then
    -- Requires Dashboard
    if vim.fn.getbufvar(cur_bufnr, '&filetype') ~= 'dashboard' then
      vim.cmd 'silent! confirm bwipeout'
      vim.cmd 'Dashboard'
      -- Ensure that tab line is hidden
      vim.o.showtabline = 0
    else
      vim.cmd 'confirm qall'
    end
    return
  end
  for _, winid in ipairs(vim.fn.getbufinfo(cur_bufnr)[1].windows) do
    vim.cmd(string.format('%d wincmd w', vim.fn.win_id2win(winid)))
    vim.cmd(cur_bufnr == buflisted[#buflisted].bufnr and 'bp' or 'bn')
  end
  vim.cmd(string.format('%d wincmd w', cur_winnr))
  local is_terminal = vim.fn.getbufvar(cur_bufnr, '&buftype') == 'terminal'
  vim.cmd(is_terminal and 'bwipeout! #' or 'silent! confirm bwipeout #')
end

return M
