local gitsigns = require("gitsigns")

local Hydra = require("hydra")
local gitsigns = require("gitsigns")

local hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full
 ^ ^              _S_: stage buffer      _t_: toggle blame
 ^
 ^ ^                            _q_: exit
]]

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

    Hydra({
      name = "Git",
      hint = hint,
      config = {
        buffer = bufnr,
        color = "pink",
        invoke_on_body = true,
        hint = {
          border = "rounded",
        },
        on_enter = function()
          vim.cmd("mkview")
          vim.cmd("silent! %foldopen!")
          vim.bo.modifiable = false
          gitsigns.toggle_signs(true)
          gitsigns.toggle_linehl(true)
        end,
        on_exit = function()
          local cursor_pos = vim.api.nvim_win_get_cursor(0)
          vim.cmd("loadview")
          vim.api.nvim_win_set_cursor(0, cursor_pos)
          vim.cmd("normal zv")
          gitsigns.toggle_signs(false)
          gitsigns.toggle_linehl(false)
          gitsigns.toggle_deleted(false)
        end,
      },
      mode = { "n", "x" },
      body = "<leader>g",
      heads = {
        {
          "J",
          function()
            if vim.wo.diff then
              return "J"
            end
            vim.schedule(function()
              gitsigns.next_hunk()
            end)
            return "<Ignore>"
          end,
          { expr = true, desc = "next hunk" },
        },
        {
          "K",
          function()
            if vim.wo.diff then
              return "K"
            end
            vim.schedule(function()
              gitsigns.prev_hunk()
            end)
            return "<Ignore>"
          end,
          { expr = true, desc = "prev hunk" },
        },
        { "s", gitsigns.stage_hunk, { silent = true, desc = "stage hunk" } },
        { "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
        { "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
        { "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
        { "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
        { "b", gitsigns.blame_line, { desc = "blame" } },
        { "t", gitsigns.toggle_current_line_blame, { desc = "toggle line blame" } },
        {
          "B",
          function()
            gitsigns.blame_line({ full = true })
          end,
          { desc = "blame show full" },
        },
        { "q", nil, { exit = true, nowait = true, desc = "exit" } },
      },
    })

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
  status_formatter = nil, -- Use default
  word_diff = false,
  diff_opts = {
    algorithm = "myers",
    internal = true,
    indent_heuristic = true,
  },
})
