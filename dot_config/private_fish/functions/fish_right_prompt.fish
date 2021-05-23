if ! set -q prompt_dur_color
    set -g prompt_dur_color bryellow
end

if ! set -q __prompt_cmd_duration
    set -g __prompt_cmd_duration (set_color --bold $prompt_dur_color)"0ms"(set_color normal)
end

function __prompt_postexec --on-event fish_postexec
    test "$CMD_DURATION" -lt 0 && set --global __prompt_cmd_duration && return

    if test $CMD_DURATION -lt 1000
        set --local out $CMD_DURATION"ms"
    else
        set --local secs (math --scale=1 $CMD_DURATION/1000 % 60)
        set --local mins (math --scale=0 $CMD_DURATION/60000 % 60)
        set --local hours (math --scale=0 $CMD_DURATION/3600000)

        test $hours -gt 0 && set --local --append out $hours"h"
        test $mins -gt 0 && set --local --append out $mins"m" && set --local secs (string split . $secs)[1]
        test $secs -gt 0 && set --local --append out $secs"s"
    end

    set --global __prompt_cmd_duration (set_color --bold $prompt_dur_color)"$out"(set_color normal)
end

function fish_right_prompt
    test -n "$USER" && set --local user $USER || set --local user (whoami)
    set_color -o brgreen
    echo -sn $user
    set_color normal

    if test -n "$__prompt_cmd_duration"
        echo -sn " took $__prompt_cmd_duration"
    end

end
