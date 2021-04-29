local lspinstall = require'lspinstall'

local setup_servers = function()
    lspinstall.setup()
    local servers = lspinstall.installed_servers()
    for _, server in pairs(servers) do
      lspinstall[server].setup{}
    end
end

setup_servers()

lspinstall.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
