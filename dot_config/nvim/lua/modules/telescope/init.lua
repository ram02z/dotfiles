-- Nvim-telescope config

local telescope = require("telescope")
local actions = require("telescope.actions")

local tscope_config = {
  defaults = {
    sorting_strategy = "ascending",

    preview_title = "",

    layout_strategy = "bottom_pane",
    layout_config = {
      height = 13,
    },

    border = true,
    borderchars = {
      "z",
      prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
      results = { " " },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    file_ignore_patterns = { ".backup", ".swap", ".langservers", ".session", ".undo" },
    mappings = {
      i = {
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
      },
      n = {
        ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["<C-d>"] = actions.delete_buffer,
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    ["ui-select"] = {
      require("telescope.themes").get_cursor({}),
    },
  },
}

telescope.setup(tscope_config)

local hydra = require("hydra")
local tscope = require("modules.telescope.functions")
local cancel = require("utils.keychord").cancel
local function cmd(command)
  return table.concat({ "<cmd>", command, "<CR>" })
end
local hint = [[
 _f_: project files       _l_:  live grep       _h_: highlights   _r_: old files
 _s_: spell suggest       _c_: commands         _k_: keymaps      _b_: buffers
 _o_: live grep open      _a_: autocommands     _m_: help tags    _d_: comments
 ^
 ^ ^     _<Enter>_: Resume     ^ ^     _?_: all     ^ ^       _<Esc>_
]]

hydra({
  hint = hint,
  config = {
    invoke_on_body = true,
    hint = {
      border = "rounded",
    },
  },
  mode = "n",
  body = "<Leader>p",
  heads = {
    { "f", tscope.project_files },
    { "l", cmd("Telescope live_grep") },
    { "h", cmd("Telescope highlights") },
    { "r", cmd("Telescope oldfiles") },
    { "s", cmd("Telescope spell_suggest theme=get_cursor layout_config={height=6}"), { desc = "Spell suggest" } },
    { "c", tscope.commands },
    { "k", tscope.keymaps },
    { "b", cmd("Telescope buffers") },
    { "o", cmd("Telescope live_grep grep_open_files=true"), { desc = "Grep only open files" } },
    { "a", cmd("Telescope autocommands") },
    { "m", cmd("Telescope help_tags") },
    { "d", cmd("Telescope dev_comments") },
    { "<Enter>", cmd("Telescope resume") },
    { "?", cmd("Telescope"), { exit = true, desc = "List all pickers" } },
    { "<Esc>", nil, { exit = true, nowait = true } },
  },
})

cancel("<Leader>p")
