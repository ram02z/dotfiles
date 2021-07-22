-- Compe setup
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

-- Limit menu items to 5
vim.o.pumheight = 5

local compe = require("compe")

local compe_conf = {
	enabled = true,
	autocomplete = false,
	documentation = true,

	source = {
		path = {
			kind = "",
		},
		buffer = {
			kind = "",
			ignored_filetypes = { "lua", "c", "cpp" },
		},
		nvim_lsp = true,
		luasnip = {
			menu = " Snippet",
		},
	},
}

-- init compe
compe.setup(compe_conf)

-- Maps
vim.keymap.inoremap({ "<CR>", "compe#confirm('<CR>')", silent = true, expr = true })
vim.keymap.inoremap({ "<C-Space>", "pumvisible() ? compe#close() : compe#complete()", silent = true, expr = true })

vim.keymap.imap({ "<TAB>", [[luaeval('require("modules.compe.functions").next_complete()')]], silent = true, expr = true })
vim.keymap.snoremap({
	"<TAB>",
	[[luaeval('require("modules.compe.functions").next_complete()')]],
	silent = true,
	expr = true,
})

vim.keymap.imap({
	"<S-TAB>",
	[[luaeval('require("modules.compe.functions").prev_complete()')]],
	silent = true,
	expr = true,
})
vim.keymap.snoremap({
	"<S-TAB>",
	[[luaeval('require("modules.compe.functions").prev_complete()')]],
	silent = true,
	expr = true,
})
