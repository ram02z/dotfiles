local ls = require("luasnip")
local s = ls.s
local t = ls.t
local i = ls.i
-- local f = ls.function_node
local l = require("luasnip.extras").lambda
local m = require("luasnip.extras").match
local r = require("luasnip.extras").rep

-- TODO: use treesitter to for pairs
-- use tabout.nvim for inspiration
local function char_count_nequal(c1, c2)
  local line = vim.api.nvim_get_current_line()
  -- '%'-escape chars to force explicit match (gsub accepts patterns).
  -- second return value is number of substitutions.
  local _, ct1 = string.gsub(line, "%" .. c1, "")
  local _, ct2 = string.gsub(line, "%" .. c2, "")
  return ct1 ~= ct2
end

local function odd_count(c)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, c, "")
  return ct % 2 ~= 0
end

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
  return args[1]
end

-- This makes creation of pair-type snippets easier.
local function pair(pair_begin, pair_end, ...)
  -- triggerd by opening part of pair, wordTrig=false to trigger anywhere.
  -- ... is used to pass any args following the expand_func to it.
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
})

ls.snippets = {
  all = {
    pair("(", ")", { condition = partial(char_count_nequal, "(", ")") }),
    pair("{", "}", { condition = partial(char_count_nequal, "{", "}") }),
    pair("[", "]", { condition = partial(char_count_nequal, "[", "]") }),
    pair("<", ">", { condition = partial(char_count_nequal, "<", ">") }),
    pair("'", "'", { condition = partial(odd_count, "'") }),
    pair('"', '"', { condition = partial(odd_count, '"') }),
    pair("`", "`", { condition = partial(odd_count, "`") }),
    -- Expands to [\t\n]
    s({ trig = "[;", wordTrig = false }, {
      t({ "[", "\t" }),
      i(1),
      t({ "", "]" }),
      i(0),
    }),
    -- Expands to (\t\n)
    s({ trig = "(;", wordTrig = false }, {
      t({ "(", "\t" }),
      i(1),
      t({ "", ")" }),
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
    s("if", {
      t({ "if " }),
      i(1),
      t({ " then", "\t" }),
      i(2),
      t({ "", "end" }),
      i(0),
    }),
    s("el", {
      t({ "else", "\t" }),
      i(0),
    }),
    s("eli", {
      t({ "elseif " }),
      i(1),
      t({ " then", "\t" }),
      i(0),
    }),
  },
  go = {
    s("pkg", {
      t({ "package " }),
      i(0),
    }),
    s("func", {
      t({ "func " }),
      -- Placeholder/Insert.
      i(1),
      t("("),
      -- Placeholder with initial text.
      i(2, "name type"),
      t({ ") " }),
      -- Return type
      i(3, " "),
      -- Linebreak
      t({ " {", "\t" }),
      -- Expand to return only if return is not empty
      m(3, "^%a", "return "),
      i(4),
      t({ "", "}" }),
      -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
      i(0),
    }),
    s("funcm", {
      t({ "func main() {", "\t" }),
      i(1),
      t({ "", "}" }),
      i(0),
    }),
    s("if", {
      t({ "if " }),
      i(1),
      t({ " {", "\t" }),
      i(2),
      t({ "", "}" }),
      i(0),
    }),
    s("el", {
      t({ "else {", "\t" }),
      i(1),
      t({ "", "}" }),
      i(0),
    }),
    s("eli", {
      t({ "else if " }),
      i(1),
      t({ " {", "\t" }),
      i(2),
      t({ "", "}" }),
      i(0),
    }),
    s("iferr", {
      t({ "if " }),
      i(1, "err"),
      t({ " != nil {", "\t" }),
      i(2),
      t({ "", "}" }),
      i(0),
    }),
    s("for", {
      t({ "for " }),
      i(1, "i"),
      t({ " := " }),
      i(2, "0"),
      t({ "; " }),
      r(1),
      i(3, " < count"),
      t("; "),
      r(1),
      i(4, "++"),
      t({ " {", "\t" }),
      i(5),
      t({ "", "}" }),
      i(0),
    }),
    s("var", {
      t({ "var " }),
      i(1, "name"),
      t({ " " }),
      i(0, "type"),
    }),
    s("tys", {
      t({ "type " }),
      i(1, "name"),
      t({ " struct {", "\t" }),
      i(2),
      t({ "", "}" }),
      i(0),
    }),
    s("fpf", {
      t({ "fmt.Printf(" }),
      i(1),
      t({ ")" }),
      i(0),
    }),
    s("fpl", {
      t({ "fmt.Println(" }),
      i(1),
      t({ ")" }),
      i(0),
    }),
  },
}
