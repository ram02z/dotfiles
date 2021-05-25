local dial = require('dial')

dial.augends["custom#small#boolean"] = dial.common.enum_cyclic{
  name = "boolean",
  strlist = {"true", "false"},
}

dial.augends["custom#capital#boolean"] = dial.common.enum_cyclic{
  name = "boolean",
  strlist = {"True", "False"},
}

dial.config.searchlist.normal = {
  'number#decimal#int',
  'markup#markdown#header',
  'custom#capital#boolean',
  'custom#small#boolean'
}

dial.config.searchlist.visual = {
  'number#decimal#int',
  'markup#markdown#header',
  'number#hex',
  'number#binary',
  'color#hex'
}
