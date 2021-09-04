# Remove vi mode indicator
function fish_mode_prompt; end
# fish_vi_key_bindings default

# TODO: bind Y, utilising osc52 script

# Install fisher
if not functions -q fisher
    curl -sL git.io/fisher | source
end

# Disable question mark glob
set -U fish_features qmark-noglob

# Source init scripts
# init_source zoxide
