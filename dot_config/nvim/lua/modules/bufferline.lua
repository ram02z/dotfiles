local bline = require("bufferline")

local bline_conf = {
  options = {
    numbers = function(opts)
      return string.format("%s.", opts.ordinal)
    end,
    show_buffer_close_icons = false,
    right_mouse_command = function(bufnum)
      require("utils.buffer").bufwipeout(bufnum, { force = false })
    end,
    close_command = function(bufnum)
      require("utils.buffer").bufwipeout(bufnum, { force = true })
    end,
    always_show_bufferline = false,
    diagnostics = "nvim_lsp",
    offsets = {
      { filetype = "undotree", highlight = "StatusLine", text_align = "left" },
      { filetype = "Outline", highlight = "StatusLine", text_align = "right" },
    },
    custom_filter = function(bufno)
      if vim.bo[bufno].filetype ~= "qf" then
        return true
      end
    end,
  },
  -- TODO: (lowprio) move to theme
  highlights = {
    fill = {
      guibg = {
        attribute = "bg",
        highlight = "StatusLine",
      },
    },
    background = {
      guibg = {
        attribute = "bg",
        highlight = "StatusLine",
      },
    },
    separator = {
      guibg = {
        attribute = "bg",
        highlight = "StatusLine",
      },
    },
    modified = {
      guifg = {
        attribute = "bg",
        highlight = "PmenuSel",
      },
    },
    indicator_selected = {
      guifg = {
        attribute = "fg",
        highlight = "VertSplit",
      },
    },
    pick = {
      guibg = {
        attribute = "bg",
        highlight = "StatusLine",
      },
    },
    pick_selected = {
      guibg = {
        attribute = "bg",
        highlight = "TabLineSel",
      },
    },
    modified_selected = {
      guifg = "#C6C7D1",
      guibg = {
        attribute = "bg",
        highlight = "TabLineSel",
      },
    },
    modified = {
      guifg = {
        attribute = "bg",
        highlight = "Visual",
      },
      guibg = {
        attribute = "bg",
        highlight = "StatusLine",
      },
    },
    modified_visible = {
      guifg = {
        attribute = "bg",
        highlight = "Visual",
      },
    },
  },
}

bline.setup(bline_conf)

-- Maps
vim.keymap.nnoremap({
  "<Leader>,",
  function()
    bline.cycle(-1)
  end,
  silent = true,
})
vim.keymap.nnoremap({
  "<Leader>.",
  function()
    bline.cycle(1)
  end,
  silent = true,
})
vim.keymap.nnoremap({
  "<Leader><lt>",
  function()
    bline.move(-1)
  end,
  silent = true,
})
vim.keymap.nnoremap({
  "<Leader>>",
  function()
    bline.move(1)
  end,
  silent = true,
})
for i = 1, 9 do
  vim.keymap.nnoremap({
    "<Leader>" .. tostring(i),
    function()
      bline.go_to_buffer(i, true)
    end,
    silent = true,
  })
end
