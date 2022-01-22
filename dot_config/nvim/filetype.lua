-- use filetype.lua only
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.filetype.add({
  extension = {
    tmpl = "gotmpl",
  }
})
