local M = {}
local dap = require("dap")

local setup_hydra = function()
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
  require("hydra")({
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
end

M.setup = function()
  dap.adapters.python = function(cb, config)
    if config.request == "attach" then
      local port = (config.connect or config).port
      local host = (config.connect or config).host or "127.0.0.1"
      cb({
        type = "server",
        port = assert(port, "`connect.port` is required for a python `attach` configuration"),
        host = host,
        options = {
          source_filetype = "python",
        },
      })
    else
      cb({
        type = "executable",
        command = "/usr/bin/python",
        args = { "-m", "debugpy.adapter" },
        options = {
          source_filetype = "python",
        },
      })
    end
  end

  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",

      program = "${file}",
      pythonPath = function()
        local cwd = vim.fn.getcwd()
        if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
          return cwd .. "/venv/bin/python"
        elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
          return cwd .. "/.venv/bin/python"
        else
          return "/usr/bin/python"
        end
      end,
    },
  }
  setup_hydra()
end

return M
