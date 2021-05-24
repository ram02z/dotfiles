-- Copyright (c) 2020-2021 shadmansaleh
-- LICENCE: MIT

-- To see what chord cancelation means checkout https://github.com/svermeulen/vimpeccable#chord-cancellation-maps

-- Uses
-- require'keychord'.cancel('<leader>')
-- Add more suffixes to suffixes table if needed

local M = {}

local keys = {}
-- Table of suffixes for which chord cancelation is applied
local suffixes = {'p','u','f','c','s', 'g', '<esc>', ''}

local function load_keys()
  keys = {}
  for _, map in pairs(vim.api.nvim_get_keymap('n')) do
    keys[vim.api.nvim_replace_termcodes(map.lhs, true, false, true)] = true
  end
end

local function create_map(key)
  for _, suffix in pairs(suffixes) do
    local raw_suffix = vim.api.nvim_replace_termcodes(suffix, true, false, true)
    if keys[key..raw_suffix] == nil then
      vim.api.nvim_set_keymap('n', key..raw_suffix, '<nop>', {noremap=true})
      keys[key .. raw_suffix] = true
    end
  end
end

-- Applies chord cancelation to all keymaps currently set
-- starting with prefix. prefix is a string
-- It can be any keymap start like "<leader>" or "<space>t"
function M.cancel(prefix)
  load_keys()
  local prefix_raw = vim.api.nvim_replace_termcodes(prefix, true, false, true)
  for key, _ in pairs(keys) do
    if vim.startswith(key, prefix_raw) then
      for i=#key-1,#prefix_raw,-1 do
        local k = key:sub(1,i)
        create_map(k)
      end
    end
  end
end

return M
