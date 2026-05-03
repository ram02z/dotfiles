local ls = require("luasnip")
local s = ls.s
local t = ls.t
local i = ls.i

local function char_count_nequal(c1, c2)
  local line = vim.api.nvim_get_current_line()
  local _, ct1 = string.gsub(line, "%" .. c1, "")
  local _, ct2 = string.gsub(line, "%" .. c2, "")
  return ct1 ~= ct2
end

local function odd_count(ch)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, ch, "")
  return ct % 2 ~= 0
end

local function pair(pair_begin, pair_end, ...)
  return s({ trig = pair_begin, wordTrig = false }, {
    t({ pair_begin }),
    i(1),
    t({ pair_end }),
  }, ...)
end

local function partial(func, ...)
  local args = { ... }
  return function()
    return func(unpack(args))
  end
end

ls.config.set_config({
  history = true,
  delete_check_events = "InsertLeave",
  region_check_events = "CursorHold",
  ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,
})

ls.add_snippets(nil, {
  all = {
    pair("(", ")", { condition = partial(char_count_nequal, "(", ")") }),
    pair("{", "}", { condition = partial(char_count_nequal, "{", "}") }),
    pair("[", "]", { condition = partial(char_count_nequal, "[", "]") }),
    pair("<", ">", { condition = partial(char_count_nequal, "<", ">") }),
    pair("'", "'", { condition = partial(odd_count, "'") }),
    pair('"', '"', { condition = partial(odd_count, '"') }),
    pair("`", "`", { condition = partial(odd_count, "`") }),
    s({ trig = "[;", wordTrig = false }, {
      t({ "[", "\t" }),
      i(1),
      t({ "", "]" }),
      i(0),
    }),
    s({ trig = "(;", wordTrig = false }, {
      t({ "(", "\t" }),
      i(1),
      t({ "", ")" }),
      i(0),
    }),
    s({ trig = "{;", wordTrig = false }, {
      t({ "{", "\t" }),
      i(1),
      t({ "", "}" }),
      i(0),
    }),
    s({ trig = "{,;", wordTrig = false }, {
      t({ "{", "\t" }),
      i(1),
      t({ "", "}," }),
      i(0),
    }),
  },
  python = {
    s({ trig = '"""', wordTrig = false }, {
      t({ '"""' }),
      i(0),
      t({ '"""' }),
    }),
  },
})

ls.filetype_set("cpp", { "c", "cpp" })

require("luasnip/loaders/from_vscode").lazy_load({ paths = { "~/.config/nvim/snippets/" } })
require("luasnip/loaders/from_vscode").lazy_load({ include = { "html", "java", "python", "latex", "go" } })
