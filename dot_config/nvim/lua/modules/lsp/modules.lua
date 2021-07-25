local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local logWarn = require("utils.misc").warn
local logNote = require("utils.misc").note
local Menu = require("nui.menu")

local mod = {}
-- TODO: add code action multi select

-- Copied from https://muniftanjim.dev/blog/neovim-build-ui-using-nui-nvim/
function mod.rename()
  local curr_name = vim.fn.expand("<cword>")

  -- Check if line is commented
  local lnum, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local buf = vim.api.nvim_get_current_buf()
  local is_comment = require("utils.misc").is_comment(buf, lnum - 1)
  if #curr_name == 0 or is_comment then
    logWarn("Select a non-commented word to rename!", "[RENAME]")
    return
  end

  local params = vim.lsp.util.make_position_params()

  local function on_submit(new_name)
    if not new_name or #new_name == 0 or curr_name == new_name then
      return
    end

    params.newName = new_name

    -- TODO: implement prepare rename request to check validity
    vim.lsp.buf_request(0, "textDocument/rename", params, function(_, _, result)
      if not result then
        return
      end

      local total_files = vim.tbl_count(result.changes)

      vim.lsp.util.apply_workspace_edit(result)

      logNote(
        string.format("Changed %s file%s. To save them run ':wa'", total_files, total_files > 1 and "s" or ""),
        "[RENAME]"
      )
    end)
  end

  local input = Input({
    border = {
      style = "rounded",
      highlight = "FloatBorder",
      text = {
        top = "[Rename]",
        top_align = "left",
      },
    },
    highlight = "Normal:Normal",
    relative = {
      type = "buf",
      position = {
        row = params.position.line,
        col = params.position.character,
      },
    },
    position = {
      row = 1,
      col = 0,
    },
    size = {
      width = 25,
      height = 1,
    },
  }, {
    prompt = "",
    default_value = curr_name,
    on_submit = on_submit,
  })

  input:mount()

  input:on(event.BufLeave, input.input_props.on_close, { once = true })

  input:map("n", "<esc>", input.input_props.on_close, { noremap = true })
end

function mod.code_actions()
  local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local params = vim.lsp.util.make_range_params()
  params.context = context
  vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, _, actions)
    if actions == nil or vim.tbl_isempty(actions) then
      logNote("No code actions on current line", "[CODE ACTIONS]")
      return nil
    end
    -- TODO: implement menu
    print("da!")
  end)
end

return mod

