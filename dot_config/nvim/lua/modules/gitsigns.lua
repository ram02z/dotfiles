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
    map("n", "]g", "&diff ? ']g' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
    map("n", "[g", "&diff ? '[g' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

    -- Actions
    map({ "n", "v" }, "<leader>gs", gitsigns.stage_hunk)
    map({ "n", "v" }, "<leader>gr", gitsigns.reset_hunk)
    map("n", "<leader>gS", gitsigns.stage_buffer)
    map("n", "<leader>gu", gitsigns.undo_stage_hunk)
    map("n", "<leader>gR", gitsigns.reset_buffer)
    map("n", "<leader>gp", gitsigns.preview_hunk)
    map("n", "<leader>gb", function()
      gitsigns.blame_line({ full = true })
    end)
    map("n", "<leader>gt", gitsigns.toggle_current_line_blame)

    -- Text object
    map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>")

    local cancel = require("utils.keychord").cancel
    cancel("<Leader>g")
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
  status_formatter = nil, -- Use default
  word_diff = false,
  diff_opts = {
    algorithm = "myers",
    internal = true,
    indent_heuristic = true,
  },
})
