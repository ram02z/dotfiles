-- pears.nvim config
-- TODO: try out rules
local pears = require'pears'
local R = require'pears.rule'

pears.setup(function(conf)
  -- Don't expand pair character if alphanumeric/underscore is next character
  conf.pair("(", {
    close = ")",
    should_expand = R.not_(R.match_next "[a-zA-Z0-9_]"),
  })
  conf.pair("[", {
    close = "]",
    should_expand = R.not_(R.match_next "[a-zA-Z0-9_]"),
  })
  conf.pair("{", {
    close = "}",
    should_expand = R.not_(R.match_next "[a-zA-Z0-9_]"),
  })
  conf.pair("\"", {
    close = "\"",
    should_expand = R.all_of(
      R.not_(R.end_of_context "[a-zA-Z0-9_]"),
      R.not_(R.match_next "[a-zA-Z0-9_]"))
  })
  conf.pair("'", {
    close = "'",
    should_expand = R.all_of(
      R.not_(R.end_of_context "[a-zA-Z0-9_]"),
      R.not_(R.match_next "[a-zA-Z0-9_]"))
  })
  conf.pair("`", {
    close = "`",
    should_expand = R.not_(R.match_next "[a-zA-Z0-9_]"),
  })
  conf.preset "tag_matching"
  conf.remove_pair_on_outer_backspace(false)
  conf.on_enter(function(pear_handle)
    if vim.fn.pumvisible() == 1  and vim.fn.complete_info().selected ~= -1 then
      return vim.fn["compe#confirm"]("<CR>")
    else
      pear_handle()
    end
  end)
end)

