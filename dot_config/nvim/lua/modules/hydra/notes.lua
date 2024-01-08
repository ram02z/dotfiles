local hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

local function open_existing_file(file)
  file = vim.fs.normalize(file)
  if vim.fn.filereadable(file) == 1 then
    vim.cmd("e " .. file)
  end
end

hydra({
  hint = [[
 ^^    Notes
 ^^---------------
 _t_: todo
 _g_: goals
 _s_: scratchpad
 _r_: resumes
 ^ ^ ^ ^  _<Esc>_
  ]],
  config = {
    timeout = 4000,
    invoke_on_body = true,
    hint = {
      float_opts = {
        border = "rounded",
      },
    },
  },
  mode = "n",
  body = "<Leader>e",
  heads = {
    {
      "t",
      function()
        open_existing_file("~/Notes/todo.md")
      end,
      { exit = true },
    },
    {
      "g",
      function()
        open_existing_file("~/Notes/goals.md")
      end,
      { exit = true },
    },
    {
      "s",
      function()
        open_existing_file("~/Notes/scratch_pad.md")
      end,
      { exit = true },
    },
    { "r", cmd("NnnPicker ~/Notes/career/cv/"), { exit = true } },
    { "<Esc>", nil, { exit = true } },
  },
})
