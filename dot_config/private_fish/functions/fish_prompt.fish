# TODO: Async load the project lanuage icon and version
# TODO: Add jobs to (right) prompt

# State used for memoization and async calls.
set -g __prompt_cmd_id 0
set -g __prompt_git_state_cmd_id -1
set -g __prompt_git_static ""
set -g __prompt_dirty ""
set -g __prompt_behind ""
set -q prompt_git_repo || set -g prompt_git_repo ""


# Increment a counter each time a prompt is about to be displayed.
# Enables us to distingish between redraw requests and new prompts.
function __prompt_increment_cmd_id --on-event fish_prompt
    set __prompt_cmd_id (math $__prompt_cmd_id + 1)
end

# Abort an in-flight dirty check, if any.
function __prompt_abort_check
    if set -q __prompt_check_dirty_pid
        set -l pid $__prompt_check_dirty_pid
        functions -e __prompt_on_finish_$pid
        command kill $pid >/dev/null 2>&1
        set -e __prompt_check_dirty_pid
    end
    if set -q __prompt_check_behind_pid
        set -l pid $__prompt_check_behind_pid
        functions -e __prompt_on_finish_$pid
        command kill $pid >/dev/null 2>&1
        set -e __prompt_check_behind_pid
    end
end

function __prompt_git_status
    # Reset state if this call is *not* due to a redraw request
    set -l prev_dirty $__prompt_dirty
    set -l prev_behind $__prompt_behind
    if test $__prompt_cmd_id -ne $__prompt_git_state_cmd_id
        __prompt_abort_check

        set __prompt_git_state_cmd_id $__prompt_cmd_id
        set __prompt_git_static ""
        set __prompt_dirty ""
        set __prompt_behind ""
    end

    # Fetch git position & action synchronously.
    # Memoize results to avoid recomputation on subsequent redraws.
    if test -z $__prompt_git_static
        # Determine git working directory
        set -l git_dir (command git --no-optional-locks rev-parse --absolute-git-dir 2>/dev/null)
        if test $status -ne 0
            return 1
        end

        set -l position (command git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
        if test $status -ne 0
            # Denote detached HEAD state with short commit hash
            set position (command git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
            if test $status -eq 0
                set position "@$position"
            end
        end

        # TODO: add bisect
        set -l action ""
        if test -f "$git_dir/MERGE_HEAD"
            set action "merge"
        else if test -d "$git_dir/rebase-merge"
            set branch "rebase"
        else if test -d "$git_dir/rebase-apply"
            set branch "rebase"
        end

        set -l state $position
        if test -n $action
            set state "$state <$action>"
        end
        set -g __prompt_git_static $state

    end

    # Fetch git commit ahead/behind synchronously
    if test -z $__prompt_behind
        if ! set -q __prompt_check_behind_pid
            # Compose shell command to run in background
            set -l check_cmd "command git rev-list $__prompt_git_static..origin/$__prompt_git_static --ignore-submodules 2>/dev/null | count"

            # Run git fetch in background
            # Ignores ssh git repos unless ssh key is active
            # Avoids fetching if already behind
            if test "$prompt_bg_fetch" = "true"
                set -a check_cmd " ||
                GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND='ssh -o BatchMode=yes' git fetch --quiet --no-tags --recurse-submodules=no origin $__prompt_git_static 2>/dev/null
                "
            end
            set -l cmd "exit ($check_cmd)"

            begin
                # Defer execution of event handlers by fish for the remainder of lexical scope.
                # This is to prevent a race between the child process exiting before we can get set up.
                block -l

                set -g __prompt_check_behind_pid 0
                command fish --private --command "$cmd" >/dev/null 2>&1 &
                set -l pid (jobs --last --pid)

                set -g __prompt_check_behind_pid $pid

                # Use exit code to convey dirty status to parent process.
                # Limited to 255
                function __prompt_on_finish_$pid --inherit-variable pid --on-process-exit $pid
                    functions -e __prompt_on_finish_$pid

                    if set -q __prompt_check_behind_pid
                        if test $pid -eq $__prompt_check_behind_pid
                            switch $argv[3]
                                case 0
                                    set -g __prompt_behind_state 0
                                    if status is-interactive
                                        commandline -f repaint
                                    end
                                case '*'
                                    set -g __prompt_behind_state $argv[3]
                                    if status is-interactive
                                        commandline -f repaint
                                    end
                            end
                        end
                    end
                end
            end
        end

        if set -q __prompt_behind_state
            switch $__prompt_behind_state
                case 0
                    set -g __prompt_behind (string pad -w (string length $__prompt_behind) "")
                case '*'
                    set -g __prompt_behind $__prompt_behind_state$prompt_behind_symbol
            end

            set -e __prompt_check_behind_pid
            set -e __prompt_behind_state
        end

    end

    # Fetch dirty status asynchronously.
    if test -z $__prompt_dirty
        if ! set -q __prompt_check_dirty_pid
            # Compose shell command to run in background
            set -l check_cmd "git --no-optional-locks status -unormal --porcelain --ignore-submodules 2>/dev/null | head -n1 | count"
            set -l cmd "if test ($check_cmd) != "0"; exit 1; else; exit 0; end"

            begin
                # Defer execution of event handlers by fish for the remainder of lexical scope.
                # This is to prevent a race between the child process exiting before we can get set up.
                block -l

                set -g __prompt_check_dirty_pid 0
                command fish --private --command "$cmd" >/dev/null 2>&1 &
                set -l pid (jobs --last --pid)

                set -g __prompt_check_dirty_pid $pid

                # Use exit code to convey dirty status to parent process.
                function __prompt_on_finish_$pid --inherit-variable pid --on-process-exit $pid
                    functions -e __prompt_on_finish_$pid

                    if set -q __prompt_check_dirty_pid
                        if test $pid -eq $__prompt_check_dirty_pid
                            switch $argv[3]
                                case 0
                                    set -g __prompt_dirty_state 0
                                    if status is-interactive
                                        commandline -f repaint
                                    end
                                case 1
                                    set -g __prompt_dirty_state 1
                                    if status is-interactive
                                        commandline -f repaint
                                    end
                                case '*'
                                    set -g __prompt_dirty_state 2
                                    if status is-interactive
                                        commandline -f repaint
                                    end
                            end
                        end
                    end
                end
            end
        end

        if set -q __prompt_dirty_state
            switch $__prompt_dirty_state
                case 0
                    set -g __prompt_dirty " "
                case 1
                    set -g __prompt_dirty $prompt_dirty_indicator
                case 2
                    set -g __prompt_dirty "<err>"
            end

            set -e __prompt_check_dirty_pid
            set -e __prompt_dirty_state
        end
    end

    # Render git status. When in-progress, use previous state to reduce flicker.
    set_color --bold $prompt_git_color
    echo -n "$prompt_branch_symbol $__prompt_git_static"

    set_color red
    if ! test -z $__prompt_dirty
        echo -n $__prompt_dirty
    else if ! test -z $prev_dirty
        set_color --dim red
        echo -n $prev_dirty
        set_color normal
    else
        echo -n " "
    end

    set_color brblue
    if ! test -z $__prompt_behind
        echo -n $__prompt_behind
    else if ! test -z $prev_behind
        set_color --dim brblue
        echo -n $prev_behind
        set_color normal
    end

    set_color normal
end

function __prompt_vi_indicator
    if [ $fish_key_bindings = "fish_vi_key_bindings" ]
        switch $fish_bind_mode
            case "insert"
                return 1
            case "default"
                return 2
            case "visual"
                return 3
            case "replace"
                return 4
        end
    end
    return 0
end

# Suppress default mode prompt
function fish_mode_prompt
end

function __prompt_pwd --on-variable PWD
    set -g prompt_git_repo (command git rev-parse --show-toplevel 2>/dev/null)
    set -q __prompt_pwd || set -g __prompt_pwd

    if test -z "$prompt_git_repo"
        set -l realhome ~
        set  __prompt_pwd (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)
    else
        set -l vcs_root (string replace --all --regex "^.*/" "" $prompt_git_repo)
        set __prompt_pwd (string replace $prompt_git_repo $vcs_root $PWD)
    end

    if test "$prompt_dir_depth" -ne 0
        set -l folders (string split -n / $__prompt_pwd)
        if test (count $folders) -gt "$prompt_dir_depth"
            if test -z "$vcs_root"
                set vcs_root $folders[1]
            end
            set __prompt_pwd (
            string replace -- "$vcs_root" /:/ $__prompt_pwd |
            string replace --regex --all -- "(\.?[^/]{1})[^/]*/" \$1/ |
            string replace -- /:/ "$vcs_root"
            )
        end
    end
end

function fish_prompt
    set -l last_pipestatus $pipestatus
    set --query __prompt_pwd || __prompt_pwd

    set_color --bold $prompt_cwd_color
    echo -sn $__prompt_pwd

    # Check if current directory is writeable
    ! test -w $PWD && set_color brred && echo -sn " $prompt_lock_dir_symbol "
    set_color normal

    if test -n "$prompt_git_repo"
        set -l git_state (__prompt_git_status)
        if test $status -eq 0
            echo -sn " on $git_state"
        end
    end

    # Newline
    echo ''

    set -l symbol "$prompt_vi_symbol"
    set -l symbol_color "$prompt_symbol_color"

    for code in $last_pipestatus
        if test $code -ne 0
            set_color "$prompt_error_color"
            set symbol_color "$prompt_error_color"
            echo -n [(string join "|" $last_pipestatus)]
            break
        end
    end

    __prompt_vi_indicator
    switch $status
    case 0 1
        set symbol "$prompt_symbol"
    case 2
        set symbol_color brblue
    case 3
        set symbol_color bryellow
    case 4
        set symbol_color brmagenta
    end

    set_color "$symbol_color"
    echo -n "$symbol "
    set_color normal

    # line cursor
    echo -en '\e[6 q'
end
