# Aliases
. ~/.config/fish/functions/aliases.fish


set -gx fish_greeting ""

# Global variables
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"
set -gx TERMINAL "x-terminal-emulator"

# User name in rprompt
function fish_right_prompt -d "Write out the right prompt"
    set_color -o green
    echo -n "$USER"
end

if status is-login
    . ~/.config/fish/env.fish
end

starship init fish | source
