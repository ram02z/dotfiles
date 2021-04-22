-- Nvim-telescope config
local telescope = require('telescope')

tscope_config = {
    defaults = {
        layout_strategy = 'flex',
        scroll_strategy = 'cycle',
        layout_defaults = {
          horizontal = {
            mirror = false,
          },
          vertical = {
            mirror = false,
          },
        },
    },
    extensions = {
        fzf = {
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
}

telescope.setup(tscope_config)
telescope.load_extension('fzf')

local M = {}
local cwd_opt = {
  cwd = vim.fn.expand("%:p:h"),
}

M.project_files = function()
    local ok = pcall(require'telescope.builtin'.git_files, cwd_opt)
    if not ok then 
        require'telescope.builtin'.find_files(cwd_opt) 
    end
end

M.git_commits = function()
    pcall(require'telescope.builtin'.git_commits,cwd_opt)
end
    
M.grep_cwd = function()
    require'telescope.builtin'.live_grep(cwd_opt)
end

M.grep_buffers = function()
    require'telescope.builtin'.live_grep({
       grep_open_files = true, 
    })
end

M.fz_buffer = function()
    require'telescope.builtin'.current_buffer_fuzzy_find()
end

M.help_pages = function()
    require'telescope.builtin'.help_tags()
end

M.key_binds = function()
    require'telescope.builtin'.keymaps()
end

return M
