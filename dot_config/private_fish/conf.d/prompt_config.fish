# Default appearance options. Override in config.fish if you want.
if ! set -q prompt_dirty_indicator
    set -g prompt_dirty_indicator "*"
end

if ! set -q prompt_symbol
    set -g prompt_symbol "❯"
end

if ! set -q prompt_vi_symbol
    set -g prompt_vi_symbol "❮"
end


if ! set -q prompt_lock_dir_symbol
    set -g prompt_lock_dir_symbol ""
end


if ! set -q prompt_branch_symbol
    set -g prompt_branch_symbol ""
end

if ! set -q prompt_behind_symbol
    set -g prompt_behind_symbol "↓"
end

if ! set -q prompt_symbol_color
    set -g prompt_symbol_color brgreen
end

if ! set -q prompt_error_color
    set -g prompt_error_color brred
end

if ! set -q prompt_cwd_color
    set -g prompt_cwd_color brcyan
end

if ! set -q prompt_git_color
    set -g prompt_git_color brmagenta
end

if ! set -q prompt_dir_depth
    set -g prompt_dir_depth 4
end

if ! set -q prompt_bg_fetch
    set -g prompt_bg_fetch true
end
