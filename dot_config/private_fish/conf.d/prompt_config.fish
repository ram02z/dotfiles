# Default appearance options. Override in config.fish if you want.
if ! set -q prompt_dirty_indicator
    set -g prompt_dirty_indicator "•"
end

if ! set -q prompt_symbol
    set -g prompt_symbol "❯"
end

if ! set -q prompt_symbol_error
    set -g prompt_symbol_error "❯"
end

# This should be set to be at least as long as prompt_dirty_indicator, due to a fish bug
if ! set -q prompt_clean_indicator
    set -g prompt_clean_indicator (string replace -r -a '.' ' ' $prompt_dirty_indicator)
end

if ! set -q prompt_lock_dir_symbol
    set -g prompt_lock_dir_symbol ""
end


if ! set -q prompt_branch_symbol
    set -g prompt_branch_symbol ""
end

if ! set -q prompt_ahead_symbol
    set -g prompt_ahead_symbol "↑"
end

if ! set -q prompt_behind_symbol
    set -g prompt_behind_symbol "↓"
end

if ! set -q prompt_symbol_color
    set -g prompt_symbol_color brgreen
end

if ! set -q prompt_symbol_error_color
    set -g prompt_symbol_error_color brred
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

