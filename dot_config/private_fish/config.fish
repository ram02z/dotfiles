# Aliases
. ~/.config/fish/functions/aliases.fish

# Enviroment variables
. ~/.config/fish/env.fish

# Key bindings for bang bang
bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# User name in rprompt
function fish_right_prompt -d "Write out the right prompt"
    set_color -o green
    echo -n "$USER"
end

# Logout function
function on_exit --on-event fish_exit
   if test -n "$SSH_AGENT_PID"
       ssh-add -D
       pkill ssh-agent
       unset SSH_AGENT_PID
       unset SSH_AUTH_SOCK
    end
end

# Starship Prompt
if type -q starship
    starship init fish | source
end

# Emplace package sync
if type -q emplace
    emplace init fish | source
end
