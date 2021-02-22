if test -d ~/.ssh
    if test -z "$SSH_ENV"
        set -xg SSH_ENV $HOME/.ssh/environment
    end

    if not __ssh_agent_is_started
        pkill ssh-agent
        __ssh_agent_start
    end
end
