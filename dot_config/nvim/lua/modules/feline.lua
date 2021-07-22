local lsp = require("feline.providers.lsp")
local vi_mode_utils = require("feline.providers.vi_mode")

local properties = {
	force_inactive = {
		filetypes = {},
		buftypes = {},
		bufnames = {},
	},
}

local components = {
	left = {
		active = {},
		inactive = {},
	},
	mid = {
		active = {},
		inactive = {},
	},
	right = {
		active = {},
		inactive = {},
	},
}

-- FIXME: packer/nnn/telescope dont work
-- qf works after switching window
properties.force_inactive.filetypes = {
	"packer",
	"undotree",
	"Outline",
	"help",
	"nnn",
	"toggleterm",
	"TelescopePrompt",
	"TelescopeResults",
	"tsplayground",
	"fzf",
	"qf",
}

properties.force_inactive.buftypes = {
	"terminal",
	"prompt",
	"nofile",
	"nowrite",
}

--
-- Helper functions
--

-- Returns true if 1/2 window width is greater than cols
local has_width_gt = function(cols, winid)
	winid = winid or 0
	return vim.api.nvim_win_get_width(winid) / 2 > cols
end

-- Returns number of buffers
local no_buffers = function()
	return #vim.fn.getbufinfo({ buflisted = 1 })
end

local get_git_dir = function(path)
	local Job = require("plenary.job")
	local baseName = require("utils.misc").baseName
	local logError = require("utils.misc").error

	-- If path nil or '.' get the absolute path to current directory
	if not path or path == "." then
		path = vim.loop.cwd()
	end

	local find_toplevel_job = Job:new({
		"git",
		"rev-parse",
		"--show-toplevel",
		cwd = path,
	})

	local stdout, code = find_toplevel_job:sync()
	if code ~= 0 then
		logError("Couldn't determine the git toplevel")
		return ""
	end

	stdout = table.concat(stdout, "")
	return baseName(stdout)
end

-- Dracula-esque colors
local colors = {
	black = "#21222C",
	gray = "#3A3C4E",
	light_gray = "#8791A5",
	purple = "#BD93F9",
	cyan = "#62D6E8",
	green = "#50FA8B",
	orange = "#FFB86C",
	red = "#FF5555",
	magenta = "#EA51B2",
	pink = "#FF79C6",
	white = "#F8F8F2",
	yellow = "#F1FA8C",
}

-- This table is equal to the default vi_mode_colors table
local vi_mode_colors = {
	NORMAL = "purple",
	OP = "purple",
	INSERT = "green",
	VISUAL = "yellow",
	BLOCK = "cyan",
	REPLACE = "red",
	["V-REPLACE"] = "red",
	ENTER = "cyan",
	MORE = "cyan",
	SELECT = "magenta",
	COMMAND = "orange",
	SHELL = "orange",
	TERM = "orange",
	NONE = "purple",
}

-- HACK: figure out which components are most important on smaller windows
-- Possibly create a system that prioritises based on the enabled components
-- and screen size

--
-- Left active components
--
table.insert(components.left.active, {
	provider = function()
		local mode = vi_mode_utils.get_vim_mode()
		if #mode > 1 then
			return " " .. mode:sub(1, 1) .. " "
		end
		return " // "
	end,
	hl = function()
		local val = {}

		val.name = vi_mode_utils.get_mode_highlight_name()
		val.bg = vi_mode_utils.get_mode_color()
		val.fg = colors.black

		return val
	end,
	right_sep = " ",
	icon = "",
})

table.insert(components.left.active, {
	provider = "",
	hl = { fg = "red" },
	right_sep = " ",
	enabled = function()
		return vim.bo.readonly
	end,
})

table.insert(components.left.active, {
	provider = function()
		local file_name = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
		if #file_name > 30 and not has_width_gt(60) then
			file_name = vim.fn.expand("%:t")
		end

		if file_name == "" then
			file_name = "[unnamed]"
		end

		return file_name
	end,
	enabled = function()
		-- Nvim-bufferline shows them instead
		return no_buffers() == 1
	end,
	right_sep = function()
		local val = {}
		if vim.bo.modified then
			val.hl = { fg = "red" }
			val.str = "* "
		else
			val.str = "  "
		end

		return val
	end,
})

table.insert(components.left.active, {
	provider = "file_type",
	hl = { fg = "light_gray" },
	enabled = function()
		return vim.bo.buftype == "" and has_width_gt(25)
	end,
	right_sep = " ",
})

table.insert(components.left.active, {
	provider = "file_size",
	hl = { fg = "light_gray" },
	enabled = function()
		return vim.bo.buftype == "" and vim.bo.filetype ~= "" and has_width_gt(30)
	end,
	-- right_sep = ' '
})

table.insert(components.left.active, {
	provider = "diagnostic_errors",
	enabled = function()
		return lsp.diagnostics_exist("Error") and has_width_gt(40)
	end,
	hl = { fg = "red" },
})

table.insert(components.left.active, {
	provider = "diagnostic_warnings",
	enabled = function()
		return lsp.diagnostics_exist("Warning") and has_width_gt(40)
	end,
	hl = { fg = "orange" },
})

table.insert(components.left.active, {
	provider = "diagnostic_hints",
	enabled = function()
		return lsp.diagnostics_exist("Hint") and has_width_gt(40)
	end,
	hl = { fg = "cyan" },
})

table.insert(components.left.active, {
	provider = "diagnostic_info",
	enabled = function()
		return lsp.diagnostics_exist("Information") and has_width_gt(40)
	end,
	hl = { fg = "cyan" },
})

--
-- Right active components
--
table.insert(components.right.active, {
	provider = "git_diff_added",
	enabled = function()
		return has_width_gt(30)
	end,
	hl = {
		fg = "green",
	},
	icon = " +",
})

table.insert(components.right.active, {
	provider = "git_diff_changed",
	enabled = function()
		return has_width_gt(30)
	end,
	hl = {
		fg = "orange",
	},
	icon = " ~",
})

table.insert(components.right.active, {
	provider = "git_diff_removed",
	enabled = function()
		return has_width_gt(30)
	end,
	hl = {
		fg = "red",
	},
	icon = " -",
	right_sep = function()
		local val = {}
		if vim.b.gitsigns_status_dict then
			val.str = " "
		else
			val.str = ""
		end

		return val
	end,
})

table.insert(components.right.active, {
	provider = "git_branch",
	hl = {
		fg = "pink",
	},
	icon = "  ",
})

-- Minimises calls to get_git_dir fn
table.insert(components.right.active, {
	provider = function()
		local cwd = vim.loop.cwd()

		if Cached_git_dirs == nil then
			Cached_git_dirs = {}
		end

		if not vim.tbl_isempty(Cached_git_dirs) then
			local keys = vim.tbl_keys(Cached_git_dirs)
			for i = 1, #keys do
				if Cached_git_dirs[keys[i]] == cwd then
					return keys[i]
				end
			end
		end

		local git_dir = get_git_dir(cwd)
		if not git_dir then
			return ""
		end

		Cached_git_dirs[git_dir] = cwd

		return git_dir
	end,
	enabled = function()
		if vim.b.gitsigns_status_dict and has_width_gt(50) then
			return true
		end
	end,
	hl = {
		fg = "cyan",
		style = "bold",
	},
	left_sep = function()
		local val = {}
		if vim.b.gitsigns_status_dict then
			val.str = " "
		else
			val.str = ""
		end

		return val
	end,
})

table.insert(components.right.active, {
	provider = "position",
	enabled = function()
		return has_width_gt(25)
	end,
	hl = {
		fg = "light_gray",
	},
	left_sep = " ",
	right_sep = " ",
})

table.insert(components.right.active, {
	provider = "scroll_bar",
	hl = {
		fg = "light_gray",
	},
	left_sep = function()
		local val = {}
		if has_width_gt(25) then
			val.str = ""
		else
			val.str = " "
		end

		return val
	end,
})

--
-- Inactive components
--
table.insert(components.left.inactive, {
	provider = function()
		local mode = vi_mode_utils.get_vim_mode()
		if #mode > 1 then
			return " " .. mode:sub(1, 1) .. " "
		end
		return " \\ "
	end,
	hl = function()
		local val = {}

		val.name = vi_mode_utils.get_mode_highlight_name()
		val.bg = vi_mode_utils.get_mode_color()
		val.fg = colors.black

		return val
	end,
	right_sep = " ",
	icon = "",
})

table.insert(components.left.inactive, {
	-- FIXME: floating windows don't omit filetype
	provider = "file_type",
	hl = { fg = "light_gray" },
})

require("feline").setup({
	default_bg = colors.black,
	default_fg = colors.white,
	colors = colors,
	components = components,
	properties = properties,
	vi_mode_colors = vi_mode_colors,
})
