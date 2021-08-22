local gitsigns = require("gitsigns")

local gs_conf = {
  signs = {
    add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "DiffDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "DiffChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ["n ]g"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
    ["n [g"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },

    ["n <leader>gs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ["n <leader>gu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ["n <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ["n <leader>gR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ["n <leader>gp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
    ["n <leader>gt"] = '<cmd>Gitsigns toggle_current_line_blame<CR>',

    -- Text objects
    ["o gh"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ["x gh"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
  },
  watch_index = {
    interval = 1000,
    follow_files = true,
  },
  current_line_blame = false,
  current_line_blame_delay = 0,
  current_line_blame_position = 'eol',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = false,
  use_internal_diff = true, -- If luajit is present
}

gitsigns.setup(gs_conf)

local cancel = require("utils.keychord").cancel
cancel("<Leader>g")
