vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return cursor to the last known position when opening a file",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Flash the yanked text and copy it to the system clipboard",
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      vim.highlight.on_yank()
      local status, osc52 = pcall(require, "osc52")
      if status then
        osc52.copy_register('"')
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Force consistent text-wrapping and list-formatting rules",
  callback = function()
    -- t: wrap text, c: wrap comments, q: format comments,
    -- n: numbered lists, j: remove comment leaders on join
    vim.opt_local.formatoptions = "tcqnbj"
  end,
})

local numbertoggle_group = vim.api.nvim_create_augroup("numbertoggle", {})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "WinEnter" }, {
  group = numbertoggle_group,
  desc = "Switch to relative numbering when the window is active",
  callback = function()
    if vim.opt_local.number._value == true then
      vim.opt_local.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "WinLeave" }, {
  group = numbertoggle_group,
  desc = "Switch to absolute numbering when the window loses focus",
  callback = function()
    if vim.opt_local.number._value == true then
      vim.opt_local.relativenumber = false
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)

    if lang and vim.treesitter.language.add(lang) then
      pcall(vim.treesitter.start, args.buf, lang)
    end
  end,
})

-- Enable native LSP completion
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('native_completion', {}),
  desc = "Enable native LSP autocompletion",
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
        convert = function(item)
          local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind] or ""
          local icon = U.completion.lsp_kind_icons[kind_name] or ""
          return {
            abbr = icon ~= "" and (icon .. " " .. item.label) or item.label,
            menu = "[LSP]",
          }
        end,
      })
    end
  end,
})
