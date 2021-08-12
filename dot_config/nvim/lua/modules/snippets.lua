-- TODO: use treesitter to for pairs
-- use tabout.nvim for inspiration
local function char_count_same(c1, c2)
  local line = vim.api.nvim_get_current_line()
  local _, ct1 = string.gsub(line, c1, "")
  local _, ct2 = string.gsub(line, c2, "")
  return ct1 == ct2
end

local function even_count(c)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, c, "")
  return ct % 2 == 0
end

local function neg(fn, ...)
  return not fn(...)
end

local ls = require("luasnip")
local s = ls.s
local t = ls.t
local i = ls.i

-- Every unspecified option will be set to the default.
ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = false,
})

ls.snippets = {
  all = {
    -- Expands to ()
    s({ trig = "(", wordTrig = false }, {
      t({ "(" }),
      i(1),
      t({ ")" }),
      i(0),
    }, neg, char_count_same, "%(", "%)"),
    -- Expands to {}
    s({ trig = "{", wordTrig = false }, {
      t({ "{" }),
      i(1),
      t({ "}" }),
      i(0),
    }, neg, char_count_same, "%{", "%}"),
    -- Expands to []
    s({ trig = "[", wordTrig = false }, {
      t({ "[" }),
      i(1),
      t({ "]" }),
      i(0),
    }, neg, char_count_same, "%[", "%]"),
    -- Expands to <>
    s({ trig = "<", wordTrig = false }, {
      t({ "<" }),
      i(1),
      t({ ">" }),
      i(0),
    }, neg, char_count_same, "<", ">"),
    -- Expands to ''
    s({ trig = "'", wordTrig = false }, {
      t({ "'" }),
      i(1),
      t({ "'" }),
      i(0),
    }, neg, even_count, "'"),
    -- Expands to ""
    s({ trig = '"', wordTrig = false }, {
      t({ '"' }),
      i(1),
      t({ '"' }),
      i(0),
    }, neg, even_count, '"'),
    -- Expands to [\t\n]
    s({ trig = "[;", wordTrig = false }, {
      t({ "[", "\t" }),
      i(1),
      t({ "", "]" }),
      i(0),
    }),
    -- Expands to {\t\n}
    s({ trig = "{;", wordTrig = false }, {
      t({ "{", "\t" }),
      i(1),
      t({ "", "}" }),
      i(0),
    }),
    -- Expands to {\t\n},
    s({ trig = "{,;", wordTrig = false }, {
      t({ "{", "\t" }),
      i(1),
      t({ "", "}," }),
      i(0),
    }),
    ls.parser.parse_snippet({ trig = "date;", wordTrig = true }, os.date("%d-%m-%Y")),
    ls.parser.parse_snippet({ trig = "time;", wordTrig = true }, os.date("%H:%M")),
    ls.parser.parse_snippet({ trig = "datetime;", wordTrig = true }, os.date("%d-%m-%Y %H:%M")),
  },
  lua = {
    s({ trig = "if", wordTrig = true }, {
      t({ "if " }),
      i(1),
      t({ " then", "\t" }),
      i(0),
      t({ "", "end" }),
    }),
    s({ trig = "el", wordTrig = true }, {
      t({ "else", "\t" }),
      i(0),
    }),
    s({ trig = "eli", wordTrig = true }, {
      t({ "elseif", "\t" }),
      i(0),
    }),
  },
}
