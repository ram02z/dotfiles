local ls = require("luasnip")
local s = ls.s
local sn = ls.snippet_node
local t = ls.t
local i = ls.i
local d = ls.dynamic_node
local c = ls.choice_node
-- local f = ls.function_node
local dl = require("luasnip.extras").dynamic_lambda
local l = require("luasnip.extras").lambda
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

-- complicated function for dynamicNode.
local function jdocsnip(args, _, old_state)
  -- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
  -- Using a restoreNode instead is much easier.
  -- View this only as an example on how old_state functions.
  local nodes = {
    t({ "/**", " * " }),
    i(1, "A short Description"),
    t({ "", "" }),
  }

  -- These will be merged with the snippet; that way, should the snippet be updated,
  -- some user input eg. text can be referred to in the new snippet.
  local param_nodes = {}

  if old_state then
    nodes[2] = i(1, old_state.descr:get_text())
  end
  param_nodes.descr = nodes[2]

  -- At least one param.
  if string.find(args[2][1], ", ") then
    vim.list_extend(nodes, { t({ " * ", "" }) })
  end

  local insert = 2
  for _, arg in ipairs(vim.split(args[2][1], ", ", true)) do
    -- Get actual name parameter.
    arg = vim.split(arg, " ", true)[2]
    if arg then
      local inode
      -- if there was some text in this parameter, use it as static_text for this new snippet.
      if old_state and old_state[arg] then
        inode = i(insert, old_state["arg" .. arg]:get_text())
      else
        inode = i(insert)
      end
      vim.list_extend(nodes, { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) })
      param_nodes["arg" .. arg] = inode

      insert = insert + 1
    end
  end

  if args[1][1] ~= "void" then
    local inode
    if old_state and old_state.ret then
      inode = i(insert, old_state.ret:get_text())
    else
      inode = i(insert)
    end

    vim.list_extend(nodes, { t({ " * ", " * @return " }), inode, t({ "", "" }) })
    param_nodes.ret = inode
    insert = insert + 1
  end

  if vim.tbl_count(args[3]) ~= 1 then
    local exc = string.gsub(args[3][2], " throws ", "")
    local ins
    if old_state and old_state.ex then
      ins = i(insert, old_state.ex:get_text())
    else
      ins = i(insert)
    end
    vim.list_extend(nodes, { t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) })
    param_nodes.ex = ins
    insert = insert + 1
  end

  vim.list_extend(nodes, { t({ " */" }) })

  local snip = sn(nil, nodes)
  -- Error on attempting overwrite.
  snip.old_state = param_nodes
  return snip
end

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
    ls.parser.parse_snippet({ trig = "date;", wordTrig = true }, os.date("%d-%m-%Y")),
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
  java = {
    s("classn", {
      c(1, {
        t("public "),
        t("private "),
        t("protected "),
      }),
      t("class "),
      dl(2, l.TM_FILENAME:match("([^.]*)"), {}),
      t({ " {", "\t" }),
      i(3),
      t({ "", "}" }),
      i(0),
    }),
    -- Very long example for a java class.
    s("fn", {
      d(7, jdocsnip, { 3, 5, 6 }),
      t({ "", "" }),
      c(1, {
        t("public "),
        t("private "),
        t("protected "),
      }),
      c(2, {
        t("static "),
        i(nil, ""),
      }),
      i(3, "void"),
      t(" "),
      i(4, "myFunc"),
      t("("),
      i(5),
      t(")"),
      c(6, {
        t(""),
        sn(nil, {
          t({ "", " throws " }),
          i(1),
        }),
      }),
      t({ " {", "\t" }),
      i(0),
      t({ "", "}" }),
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
    s("fori", {
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
})

-- in a cpp file: search c-snippets, then all-snippets only (no cpp-snippets!!).
ls.filetype_set("cpp", { "c", "cpp" })

require("luasnip/loaders/from_vscode").lazy_load({ paths = { "~/.config/nvim/snippets/" } })
-- friendly-snippets
require("luasnip/loaders/from_vscode").lazy_load({ include = { "html", "java", "latex" } })
