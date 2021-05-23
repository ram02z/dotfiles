local bline = require'bufferline'
local vimp = require'vimp'
local opts = {'override', 'silent'}


-- nvim-bufferline manipulation using leader + key

-- Magic buffer picker
vimp.nnoremap(opts, '<Leader><Leader>', bline.pick_buffer)
-- Ordering
vimp.nnoremap(opts, '<Leader>,', function() bline.cycle(-1) end)
vimp.nnoremap(opts, '<Leader>.', function() bline.cycle(1) end)
vimp.nnoremap(opts, '<Leader><', function() bline.move(-1) end)
vimp.nnoremap(opts, '<Leader>>', function() bline.move(1) end)
-- Position
vimp.nnoremap(opts, '<Leader>1', function() bline.go_to_buffer(1) end)
vimp.nnoremap(opts, '<Leader>2', function() bline.go_to_buffer(2) end)
vimp.nnoremap(opts, '<Leader>3', function() bline.go_to_buffer(3) end)
vimp.nnoremap(opts, '<Leader>4', function() bline.go_to_buffer(4) end)
vimp.nnoremap(opts, '<Leader>5', function() bline.go_to_buffer(5) end)
vimp.nnoremap(opts, '<Leader>6', function() bline.go_to_buffer(6) end)
vimp.nnoremap(opts, '<Leader>7', function() bline.go_to_buffer(7) end)
vimp.nnoremap(opts, '<Leader>8', function() bline.go_to_buffer(8) end)
vimp.nnoremap(opts, '<Leader>9', function() bline.go_to_buffer(9) end)
-- Last used buffer
vimp.nnoremap(opts, '<Leader>l', ':e#<CR>')
-- Close buffer
-- Function from https://github.com/ojroques/nvim-bufdel
vimp.nnoremap(opts, "<Leader>q", function()
  local buflisted = vim.fn.getbufinfo({buflisted = 1})
  local cur_winnr, cur_bufnr = vim.fn.winnr(), vim.fn.bufnr()
  if #buflisted < 2 then vim.cmd 'confirm qall' return end
  for _, winid in ipairs(vim.fn.getbufinfo(cur_bufnr)[1].windows) do
    vim.cmd(string.format('%d wincmd w', vim.fn.win_id2win(winid)))
    vim.cmd(cur_bufnr == buflisted[#buflisted].bufnr and 'bp' or 'bn')
  end
  vim.cmd(string.format('%d wincmd w', cur_winnr))
  local is_terminal = vim.fn.getbufvar(cur_bufnr, '&buftype') == 'terminal'
  vim.cmd(is_terminal and 'bwipeout! #' or 'silent! confirm bwipeout #')
end)
