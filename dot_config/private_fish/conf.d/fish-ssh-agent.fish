# Copied from @dlukes config
# Used to preload ssh keys
if test -d ~/.ssh
    set -l ssh_agent_env /tmp/ssh-agent.fishenv.(id -u)

    if not set -q SSH_AUTH_SOCK
        test -r $ssh_agent_env && source $ssh_agent_env

        if not ps -U $LOGNAME -o pid,ucomm | grep -q -- "$SSH_AGENT_PID ssh-agent"
            # use the -t switch (e.g. -t 10m) to add a timeout on the auth
            eval (ssh-agent -c | sed '/^echo /d' | tee $ssh_agent_env)
        end
    end

    if ssh-add -l 2>&1 | grep -q 'This agent has no identities'
        ssh-add ~/.ssh/id_ed25519 2>/dev/null
    end
end
