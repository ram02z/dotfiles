# user name in right prompt
# TODO: Make this display git status async unless starship gets async 
function fish_right_prompt -d "Username in green"
    set_color -o green
    echo -n (whoami)
end
