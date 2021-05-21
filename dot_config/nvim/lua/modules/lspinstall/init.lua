local on_attach = function(client, buffnr)
  require'illuminate'.on_attach(client)
end

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

-- Requires codicons font
require'vim.lsp.protocol'.CompletionItemKind = {
  '  Text';          -- = 1
  '  Function';      -- = 2;
  '  Method';        -- = 3;
  '  Constructor';   -- = 4;
  '  Field';         -- = 5;
  '  Variable';      -- = 6;
  '  Class';         -- = 7;
  '  Interface';     -- = 8;
  '  Module';        -- = 9;
  '  Property';      -- = 10;
  '  Unit';          -- = 11;
  '  Value';         -- = 12;
  '  Enum';          -- = 13;
  '  Keyword';       -- = 14;
  '  Snippet';       -- = 15;
  '  Color';         -- = 16;
  '  File';          -- = 17;
  '  Reference';     -- = 18;
  '  Folder';        -- = 19;
  '  EnumMember';    -- = 20;
  '  Constant';      -- = 21;
  '  Struct';        -- = 22;
  '  Event';         -- = 23;
  '  Operator';      -- = 24;
  '  TypeParameter'; -- = 25;
}

-- lsp-install
local function setup_servers()
  require'lspinstall'.setup()

  -- get all installed servers
  local servers = require'lspinstall'.installed_servers()
  -- ... and add manually installed servers
  -- table.insert(servers, "sourcekit")

  for _, server in pairs(servers) do
    local config = make_config()

    -- language specific config
    if server == "lua" then
      config = require'lua-dev'.setup({
        library = {
          plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
        },
      })
    end
    require'lspconfig'[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
