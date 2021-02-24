# User name in rprompt
function fish_right_prompt -d "Username in green"
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

# Init starship and emplace
init_source starship emplace
