local M = {}

local prettier = { "prettierd", "prettier" }

M.setup = function()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      go = { "goimports", { "gofumpt", "gofmt" } },
      javascript = { prettier },
      typescript = { prettier },
      javascriptreact = { prettier },
      typescriptreact = { prettier },
      css = { prettier },
      html = { prettier },
      json = { prettier },
      jsonc = { prettier },
      yaml = { prettier },
      graphql = { prettier },
      sql = { "pg_format" },
      fish = { "fish_indent" },
    },
  })

  vim.keymap.set("", "<Leader>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end)
end

return M
