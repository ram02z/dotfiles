# Remove vi mode indicator
function fish_mode_prompt; end
# fish_vi_key_bindings default

# Visual line
bind -m visual V beginning-of-line begin-selection end-of-line force-repaint

# Source init scripts
init_source zoxide
