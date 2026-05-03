local gitsigns = require("gitsigns")

gitsigns.setup({
  numhl = false,
  linehl = false,
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]g", function()
      if vim.wo.diff then
        return "]g"
      end
      vim.schedule(function()
        gitsigns.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })
    map("n", "[g", function()
      if vim.wo.diff then
        return "[g"
      end
      vim.schedule(function()
        gitsigns.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    -- Text object
    map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>")
  end,
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  current_line_blame = false,
  current_line_blame_opts = {
    delay = 0,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  word_diff = false,
  diff_opts = {
    algorithm = "myers",
    internal = true,
    indent_heuristic = true,
    linematch = true,
  },
})
