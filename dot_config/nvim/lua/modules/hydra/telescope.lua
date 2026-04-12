local hydra = require("hydra")
local tscope = require("modules.telescope.functions")

local function cmd(command)
  return table.concat({ "<cmd>", command, "<CR>" })
end

local hint = [[
 _g_: git status       _l_:  live grep       _h_: highlights   _r_: old files
 _s_: spell suggest       _c_: commands         _k_: keymaps      _b_: buffers
 _o_: live grep open      _a_: autocommands     _m_: help tags
 ^
 ^ ^     _<Enter>_: Resume     ^ ^     _?_: all     ^ ^       _<Esc>_
]]

local telescope_hydra = hydra({
  hint = hint,
  config = {
    invoke_on_body = true,
    color = "teal",
    hint = {
      float_opts = {
        border = "rounded",
      },
    },
  },
  mode = "n",
  body = "<Leader>p",
  heads = {
    { "g", cmd("Telescope git_status") },
    { "l", cmd("Telescope live_grep") },
    { "h", cmd("Telescope highlights") },
    { "r", cmd("Telescope oldfiles") },
    { "s", cmd("Telescope spell_suggest theme=get_cursor layout_config={height=6}"), desc = "Spell suggest" },
    { "c", tscope.commands },
    { "k", tscope.keymaps },
    { "b", cmd("Telescope buffers") },
    { "o", cmd("Telescope live_grep grep_open_files=true"), desc = "Grep only open files" },
    { "a", cmd("Telescope autocommands") },
    { "m", cmd("Telescope help_tags") },
    { "<Enter>", cmd("Telescope resume") },
    { "?", cmd("Telescope"), desc = "List all pickers" },
    { "<Esc>", nil, { nowait = true } },
  },
})

return telescope_hydra