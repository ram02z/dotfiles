local hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd
local pcmd = require("hydra.keymap-util").pcmd

hydra({
  hint = [[
 ^^^^^^     Move     ^^^^^^   ^^     Split         ^^^^    Size
 ^^^^^^--------------^^^^^^   ^^---------------    ^^^^-------------
 ^ ^ _k_ ^ ^   ^ ^ _K_ ^ ^    _s_: horizontally    _+_ _-_: height
 _h_ ^ ^ _l_   _H_ ^ ^ _L_    _v_: vertically      _>_ _<_: width
 ^ ^ _j_ ^ ^   ^ ^ _J_ ^ ^    _q_, _c_: close       ^ _=_ ^: equalize
 focus^^^^^^   window^^^^^^   _z_: maximize
 ^ ^ ^ ^ ^ ^   ^ ^ ^ ^ ^ ^    _o_: remain only     ^ ^ ^ ^   _<Esc>_
]],
  config = {
    timeout = 4000,
    invoke_on_body = true,
    hint = {
      border = "rounded",
    },
  },
  mode = "n",
  body = "<C-w>",
  heads = {
    -- Move focus
    { "h", "<C-w>h" },
    { "j", "<C-w>j" },
    { "k", pcmd("wincmd k", "E11", "close") },
    { "l", "<C-w>l" },
    -- Move window
    { "H", cmd("WinShift left") },
    { "J", cmd("WinShift down") },
    { "K", cmd("WinShift up") },
    { "L", cmd("WinShift right") },
    -- Split
    { "s", "<C-w>s" },
    { "v", "<C-w>v" },
    { "z", cmd("WindowsMaximaze"), { exit = true, desc = "maximize" } },
    { "<C-z>", cmd("WindowsMaximaze"), { exit = true, desc = false } },
    { "c", pcmd("close", "E444") },
    { "q", pcmd("close", "E444"), { desc = "close window" } },
    { "<C-c>", pcmd("close", "E444"), { desc = false } },
    { "<C-q>", pcmd("close", "E444"), { desc = false } },
    { "o", "<C-w>o", { exit = true, desc = "remain only" } },
    { "<C-o>", "<C-w>o", { exit = true, desc = false } },
    -- Size
    { "+", "<C-w>+" },
    { "-", "<C-w>-" },
    { ">", "2<C-w>>", { desc = "increase width" } },
    { "<", "2<C-w><", { desc = "decrease width" } },
    { "=", "<C-w>=", { desc = "equalize" } },
    --
    { "<Esc>", nil, { exit = true } },
  },
})
