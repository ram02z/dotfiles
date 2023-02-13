vim.filetype.add({
  extension = {
    tmpl = "gotmpl",
  },
  pattern = {
    ["srcpkgs/*/template"] = "sh",
  }
})
