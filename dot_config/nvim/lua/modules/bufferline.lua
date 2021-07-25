local bline = require("bufferline")

local bline_conf = {
  options = {
    numbers = "ordinal",
    number_style = "none",
    show_buffer_close_icons = false,
    right_mouse_command = function(bufnum)
      require("utils.buffer").bufwipeout(bufnum)
    end,
    close_command = function(bufnum)
      require("utils.buffer").bufwipeout(bufnum)
    end,
    always_show_bufferline = false,
    diagnostics = "nvim_lsp",
    mappings = false,
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
        highlight = "Normal",
      },
    },
    modified_selected = {
      guifg = "#C6C7D1",
    },
    modified_visible = {
      guifg = "#ADAEBE",
    },
  },
}

bline.setup(bline_conf)

-- Maps
vim.keymap.nnoremap({ "<Leader>b", bline.pick_buffer, silent = true })
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
      bline.go_to_buffer(i)
    end,
    silent = true,
  })
end
