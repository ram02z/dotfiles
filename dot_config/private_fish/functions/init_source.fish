function init_source -d "Initalizes scripts"
    if begin; test (count $argv) -gt 0; and test -d $argv[1]; end
        for cmd in $argv
            if type -q $cmd
                $cmd init fish | source
            end
        end
    end
end
