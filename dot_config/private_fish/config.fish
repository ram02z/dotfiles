# Aliases
. ~/.config/fish/functions/aliases.fish


set -gx fish_greeting ""

# Global variables
set -gx VISUAL "nvim"
set -gx EDITOR "$VISUAL"
set -gx TERMINAL "x-terminal-emulator"

# Key bindings for bang bang
bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# WSL2 only settings
if string match -q -- "5.*" (uname -r) 
    set -gx DISPLAY (awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
    set LIBGL_ALWAYS_INDIRECT 1
end

# Key bindings for bang bang
bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# User name in rprompt
function fish_right_prompt -d "Write out the right prompt"
    set_color -o green
    echo -n "$USER"
end

if status is-login
    . ~/.config/fish/env.fish
end

# Starship Prompt
if type -q starship
    starship init fish | source
end

# Emplace package sync
if type -q emplace
    emplace init fish | source
end
