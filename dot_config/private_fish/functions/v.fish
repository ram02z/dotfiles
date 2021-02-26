function v -d "Toggles between vi mode"
    switch "$fish_key_bindings"
        case fish_vi_key_bindings
            printf "Switched to default key binds\n"
            fish_default_key_bindings
        case '*'
            printf "Switched to vi key binds\n"
            # Starts in insert mode until it gets fixed
            # https://github.com/fish-shell/fish-shell/issues/6046
            fish_vi_key_bindings default
    end
end
