local hydra = require("hydra")
local dap = require("dap")

local hint = [[
     ^ ^Step^ ^ ^      ^ ^     Action
----^-^-^-^--^-^----  ^-^-------------------
     ^ ^back^ ^ ^     ^_t_: toggle breakpoint
     ^ ^ _K_^ ^        _T_: clear breakpoints
out _H_ ^ ^ _L_ into  _c_: continue
     ^ ^ _J_ ^ ^       _x_: terminate
     ^ ^over ^ ^     ^^_r_: open repl

     ^ ^  _q_: exit
]]

local debug_hydra = hydra({
  name = "Debug",
  hint = hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      type = "window",
    },
  },
  mode = { "n" },
  body = "<leader>s",
  heads = {
    { "H", dap.step_out, { desc = "step out" } },
    { "J", dap.step_over, { desc = "step over" } },
    { "K", dap.step_back, { desc = "step back" } },
    { "L", dap.step_into, { desc = "step into" } },
    { "t", dap.toggle_breakpoint, { desc = "toggle breakpoint" } },
    { "T", dap.clear_breakpoints, { desc = "clear breakpoints" } },
    { "c", dap.continue, { desc = "continue" } },
    { "x", dap.terminate, { desc = "terminate" } },
    { "r", dap.repl.open, { exit = true, desc = "open repl" } },
    { "q", nil, { exit = true, nowait = true, desc = "exit" } },
  },
})

return debug_hydra
