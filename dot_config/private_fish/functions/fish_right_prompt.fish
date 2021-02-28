# user name in right prompt
function fish_right_prompt -d "Username in green"
    set_color -o green
    echo -n (whoami)
end
