local vimp = require'vimp'
local opts = {'silent', 'override'}

vimp.nmap(opts, "<C-_>", "<Plug>kommentary_line_default")
vimp.imap(opts, "<C-_>", "<esc><Plug>kommentary_line_default gi")
vimp.vmap(opts, "<C-_>", "<Plug>kommentary_visual_default")

