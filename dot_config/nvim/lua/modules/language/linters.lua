local M = {}

M.setup = function()
  local flake8 = require("lint").linters.flake8
  flake8.args = {
    "--format=%(code)s:%(text)s",
    "--no-show-source",
    "--extend-ignore=E203",
    "--max-line-length=88",
    "-",
  }
  require("lint").linters_by_ft = {
    python = { "flake8" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end
  })
end

return M
