local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  -- TODO: add implementation, declaration and signature help
  if client.resolved_capabilities.goto_definition then
    vim.keymap.nmap({
      "<Leader>lgd",
      [[<cmd>lua vim.lsp.buf.definition()<CR>]],
      silent = true,
      buffer = true,
    })
  end
  if client.resolved_capabilities.hover then
    vim.keymap.nmap({
      "<CR>",
      [[<cmd>lua vim.lsp.buf.hover()<CR>]],
      silent = true,
      buffer = true,
    })
  end
  if client.resolved_capabilities.code_action then
    vim.cmd(
    [[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua require'nvim-lightbulb'.update_lightbulb()]]
    )
    -- vim.keymap.nmap({ "<Leader>la", [[<cmd>lua vim.lsp.buf.code_action()<CR>]], silent = true, buffer = true })
    vim.keymap.nmap({
      "<Leader>la",
      [[<cmd>lua require'modules.lsp.modules'.code_actions()<CR>]],
      silent = true,
      buffer = true,
    })
  end
  if client.resolved_capabilities.rename then
    vim.keymap.nmap({
      "<Leader>lr",
      [[<cmd>lua require'modules.lsp.modules'.rename()<CR>]],
      silent = true,
      buffer = true,
    })
  end
  if client.resolved_capabilities.find_references then
    vim.keymap.nmap({
      "<Leader>*",
      [[<cmd>lua vim.lsp.buf.references()<CR>]],
      silent = true,
      buffer = true,
    })
  end

  vim.keymap.nmap({
    "]d",
    [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]],
    silent = true,
    buffer = true,
  })
  vim.keymap.nmap({
    "[d",
    [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]],
    silent = true,
    buffer = true,
  })
  vim.keymap.nmap({
    "<Leader>ll",
    [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]],
    silent = true,
    buffer = true,
  })

  require("utils.keychord").cancel("<Leader>l", true)

  -- Additional plugins
end

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
    autostart = true,
    flags = {
      debounce_text_changes = 250,
    },
  }
end

-- Requires codicon font
require("vim.lsp.protocol").CompletionItemKind = {
  "  Text", -- = 1
  "  Function", -- = 2;
  "  Method", -- = 3;
  "  Constructor", -- = 4;
  "  Field", -- = 5;
  "  Variable", -- = 6;
  "  Class", -- = 7;
  "  Interface", -- = 8;
  "  Module", -- = 9;
  "  Property", -- = 10;
  "  Unit", -- = 11;
  "  Value", -- = 12;
  "  Enum", -- = 13;
  "  Keyword", -- = 14;
  "  Snippet", -- = 15;
  "  Color", -- = 16;
  "  File", -- = 17;
  "  Reference", -- = 18;
  "  Folder", -- = 19;
  "  EnumMember", -- = 20;
  "  Constant", -- = 21;
  "  Struct", -- = 22;
  "  Event", -- = 23;
  "  Operator", -- = 24;
  "  TypeParameter", -- = 25;
}

-- lsp-install
local function setup_servers()
  require("lspinstall").setup()

  -- get all installed servers
  local servers = require("lspinstall").installed_servers()
  -- ... and add manually installed servers
  -- table.insert(servers, "sourcekit")

  for _, server in pairs(servers) do
    local config = make_config()

    -- language specific config
    if server == "lua" then
      config = require("lua-dev").setup({
        lspconfig = config,
      })
    end
    nvim_lsp[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>`
-- Means we don't have to restart neovim
require("lspinstall").post_install_hook = function()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- TODO: remove when #107 gets merged
vim.cmd([[command! LspPrintInstalled :echo lspinstall#installed_servers()]])
