local kommentary = require'kommentary.config'

-- Disable default binds
vim.g.kommentary_create_default_mappings = false

kommentary.configure_language("default", {
  use_consistent_indent = true,
  ignore_whitespace = true,
})

kommentary.configure_language("dosini", {
  prefer_single_line_comments = true,
  single_line_comment_string = "#",
})

kommentary.configure_language("fish", {
  prefer_single_line_comments = true,
  single_line_comment_string = "#",
})
