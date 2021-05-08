# Superseded by fish_add_path
function append-to-path -d 'Adds the given directory to the end of path'
    set -l dir ''
    if test (count $argv) -ne 0
        set dir $argv[1]
    end

    if test -d $dir
        set dir (abspath $dir)
        if not contains $dir $PATH
            set PATH $PATH $dir
        end
    end
end
