local M = {}

-- Dracula-esque colors
M.colors = {
  bg = "#21222C",
  fg = "#F8F8F2",
  gray = "#3A3C4E",
  light_gray = "#8791A5",
  purple = "#BD93F9",
  cyan = "#62D6E8",
  green = "#50FA8B",
  orange = "#FFB86C",
  red = "#FF5555",
  magenta = "#EA51B2",
  pink = "#FF79C6",
  yellow = "#F1FA8C",
}

-- This table is equal to the default vi_mode_colors table
M.vi_mode_colors = {
  NORMAL = "purple",
  OP = "purple",
  INSERT = "green",
  VISUAL = "yellow",
  LINES = "yellow",
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

return M
