U = {}

-- Os
U.os = {
  home = os.getenv("HOME"),
  data = vim.fn.stdpath("data"),
  cache = vim.fn.stdpath("cache"),
  config = vim.fn.stdpath("config"),
  name = jit.os,
}

-- Completion
U.completion = {
  lsp_kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
}
