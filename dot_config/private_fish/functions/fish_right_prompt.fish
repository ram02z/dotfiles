function fish_right_prompt
    test -n "$USER" && set --local user $USER || set --local user (whoami)
    set_color -o brgreen
    echo -sn $user
    set_color normal
end
