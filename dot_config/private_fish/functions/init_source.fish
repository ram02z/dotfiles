function init_source -d "Initalizes scripts"
    for cmd in $argv
        if type -q $cmd
            $cmd init fish | source
        end
    end
end
