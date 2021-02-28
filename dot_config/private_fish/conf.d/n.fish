# NNN Variables
set NNN_PLUG_UTIL 's:suedit;u:upgrade;x:togglex;f:fzcd;k:pskill'
set NNN_PLUG_STD 'a:chezmoi-add;r:chezmoi-remove;`:preview-tui'
set -x NNN_PLUG "$NNN_PLUG_UTIL;$NNN_PLUG_STD"
set -x NNN_COLORS '#b7d49f2e;5555'
set -x NNN_FCOLORS 'c1e2b72e006033f7c6d6abc4'
set -x NNN_TRASH 2
set -x NNN_OPTS "dcHxr"
set -x NNN_FIFO '/tmp/nnn.fifo'
set -x NNN_OPENER "$HOME/.config/nnn/plugins/nuke"
set -x GUI 1

function n --wraps nnn --description 'support nnn quit and change directory'
    # Block nesting of nnn in subshells
    if test -n "$NNNLVL"
        if [ (expr $NNNLVL + 0) -ge 1 ]
            echo "nnn is already running"
            return
        end
    end

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "-x" as in:
    #    set NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    if test -n "$XDG_CONFIG_HOME"
        set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
    else
        set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
    end

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn $argv

    if test -e $NNN_TMPFILE
        source $NNN_TMPFILE
        rm $NNN_TMPFILE
    end
end

