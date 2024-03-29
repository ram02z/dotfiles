local ls = require("luasnip")
local s = ls.s
local sn = ls.snippet_node
local t = ls.t
local i = ls.i
local d = ls.dynamic_node
local m = require("luasnip.extras").match
local r = require("luasnip.extras").rep

-- TODO: use treesitter to for pairs
-- ref tabout.nvim for inspiration
local function char_count_nequal(c1, c2)
  local line = vim.api.nvim_get_current_line()
  -- '%'-escape chars to force explicit match (gsub accepts patterns).
  -- second return value is number of substitutions.
  local _, ct1 = string.gsub(line, "%" .. c1, "")
  local _, ct2 = string.gsub(line, "%" .. c2, "")
  return ct1 ~= ct2
end

local function odd_count(ch)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, ch, "")
  return ct % 2 ~= 0
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
  delete_check_events = "InsertLeave",
  region_check_events = "CursorHold",
  ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,
})

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  local utils = require("utils.misc")
  if require("utils.misc").invalid_prev_col() then
    vim.fn.feedkeys(utils.t("<Tab>"), "n")
  elseif ls.expand_or_locally_jumpable() then
    ls.expand_or_jump()
  else
    vim.fn.feedkeys(utils.t("<Tab>"), "n")
  end
end, { desc = "Expand/jump snippet or tab" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  local utils = require("utils.misc")
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    vim.fn.feedkeys(utils.t("<C-d>"), "n")
  end
end, { desc = "Jump to last snippet or shift tab" })

vim.keymap.set({ "i", "s" }, "<C-E>", "<Plug>luasnip-next-choice")

ls.add_snippets(nil, {
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
    ls.parser.parse_snippet({ trig = "date;", wordTrig = true }, os.date("%d %B %Y")),
    ls.parser.parse_snippet({ trig = "time;", wordTrig = true }, os.date("%H:%M")),
    ls.parser.parse_snippet({ trig = "datetime;", wordTrig = true }, os.date("%d-%m-%Y %H:%M")),
  },
  norg = {
    pair("/", "/", { condition = partial(odd_count, "/") }),
    pair("_", "_", { condition = partial(odd_count, "_") }),
    pair("*", "*", { condition = partial(odd_count, "*") }),
    pair("#", "#", { condition = partial(odd_count, "#") }),
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
  lean3 = {
    -- s("\\and", {
    --   t({ "∧" }),
    --   i(0),
    -- }),
    -- s("\\or", {
    --   t({ "∨" }),
    --   i(0),
    -- }),
    -- s("\\->", {
    --   t({ "→" }),
    --   i(0),
    -- }),
    -- s("\\neg", {
    --   t({ "¬" }),
    --   i(0),
    -- }),
    -- s("\\<->", {
    --   t({ "↔" }),
    --   i(0),
    -- }),
    s("begin", {
      t({ "begin", "\t" }),
      i(0),
      t({ "", "end" }),
    }),
    s("theorem", {
      t({ "theorem " }),
      i(1, "I"),
      t({ " : " }),
      i(2),
      t({ " :=", "" }),
      i(0),
    }),
    s("example", {
      t({ "example " }),
      t({ " : " }),
      i(1),
      t({ " :=", "" }),
      i(0),
    }),
  },
  c = {
    s("if", {
      t({ "if (" }),
      i(1),
      t({ ") {", "\t" }),
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
      t({ "else if (" }),
      i(1),
      t({ ") {", "\t" }),
      i(2),
      t({ "", "}" }),
      i(0),
    }),
    s("#inc", {
      t({ "#include " }),
      i(0),
    }),
    s("#def", {
      t({ "#define " }),
      i(0),
    }),
    s("main", {
      t({ "int main (int argc, char *argv[])", "" }),
      t({ "{", "\t" }),
      i(1),
      t({ "", "}" }),
      i(0),
    }),
    s("ret", {
      t({ "return " }),
      i(1),
      t({ ";" }),
      i(0),
    }),
    s("pf", {
      t({ "printf(" }),
      i(1),
      t(");"),
      i(0),
    }),
    s("sf", {
      t({ "scanf(" }),
      i(1),
      t(");"),
      i(0),
    }),
    s("for", {
      t({ "for (" }),
      i(1),
      t({ "; " }),
      i(2),
      t({ "; " }),
      i(3),
      t({ ") {", "\t" }),
      i(4),
      t({ "", "}" }),
      i(0),
    }),
    s("fori", {
      t({ "for (" }),
      i(1, "i"),
      t({ " = " }),
      i(2, "0"),
      t({ "; " }),
      r(1),
      i(3, " < num"),
      t({ "; " }),
      r(1),
      i(4, "++"),
      t({ ") {", "\t" }),
      i(5),
      t({ "", "}" }),
      i(0),
    }),
    s("struct", {
      t({ "struct " }),
      i(1),
      t({ " {", "\t" }),
      i(2),
      t({ "", "}" }),
      i(3),
      t({ ";" }),
      i(0),
    }),
    s("enum", {
      t({ "enum " }),
      i(1),
      t({ " {", "\t" }),
      i(2),
      t({ "", "};" }),
      i(0),
    }),
    s("switch", {
      t({ "switch (" }),
      i(1),
      t({ ") {", "\t" }),
      i(2),
      t({ "", "}" }),
      i(0),
    }),
  },
  cpp = {
    s("class", {
      t({ "class " }),
      i(1),
      t({ " {", "\t" }),
      i(2),
      t({ "", "}" }),
      i(3),
      t({ ";" }),
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
  markdown_inline = {
    s({ trig = "table(%d+)x(%d+)", regTrig = true }, {
      d(1, function(args, snip)
        local nodes = {}
        local i_counter = 0
        local hlines = ""
        for _ = 1, snip.captures[2] do
          i_counter = i_counter + 1
          table.insert(nodes, t("| "))
          table.insert(nodes, i(i_counter, "Column" .. i_counter))
          table.insert(nodes, t(" "))
          hlines = hlines .. "|---"
        end
        table.insert(nodes, t({ "|", "" }))
        hlines = hlines .. "|"
        table.insert(nodes, t({ hlines, "" }))
        for _ = 1, snip.captures[1] do
          for _ = 1, snip.captures[2] do
            i_counter = i_counter + 1
            table.insert(nodes, t("| "))
            table.insert(nodes, i(i_counter))
            print(i_counter)
            table.insert(nodes, t(" "))
          end
          table.insert(nodes, t({ "|", "" }))
        end
        return sn(nil, nodes)
      end),
    }),
  },
})

-- in a cpp file: search c-snippets, then all-snippets only (no cpp-snippets!!).
ls.filetype_set("cpp", { "c", "cpp" })

require("luasnip/loaders/from_vscode").lazy_load({ paths = { "~/.config/nvim/snippets/" } })
-- friendly-snippets
require("luasnip/loaders/from_vscode").lazy_load({ include = { "html", "java", "python", "latex", "go" } })
