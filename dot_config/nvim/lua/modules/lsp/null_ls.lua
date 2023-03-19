local null_ls = require("null-ls")
local on_attach = require("modules.lsp.config").on_attach

-- register any number of sources simultaneously
local sources = {
  null_ls.builtins.formatting.prettier.with({
    disabled_filetypes = { "markdown" },
  }),
  null_ls.builtins.formatting.black.with({
    timeout = 10000,
  }),
  null_ls.builtins.formatting.isort.with({
    extra_args = { "--profile", "black" },
  }),
  null_ls.builtins.formatting.fish_indent,
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.diagnostics.flake8.with({
    diagnostics_format = "[#{c}] #{m}",
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    extra_args = { "--extend-ignore", "E203", "--max-line-length", "88" },
  }),
  null_ls.builtins.code_actions.gitrebase,
  null_ls.builtins.formatting.buf,
  null_ls.builtins.formatting.gofumpt,
  null_ls.builtins.formatting.goimports,
  null_ls.builtins.formatting.pg_format,
}

null_ls.setup({ sources = sources, on_attach = on_attach, debug = true })
