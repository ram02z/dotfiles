# NOTE: Old config when my main shell was zsh
# NNN Variables
NNN_PLUG_UTIL='s:suedit;u:upgrade;x:togglex;f:fzcd;k:pskill'
NNN_PLUG_STD='e:_editor /home/omar/.config/nnn/config.zsh &;`:preview-tui'
export NNN_PLUG="$NNN_PLUG_UTIL;$NNN_PLUG_STD"
export NNN_COLORS='#b7d49f2e;5555'
export NNN_FCOLORS='c1e2b72e006033f7c6d6abc4'
export NNN_TRASH=2
export NNN_OPTS="dcHxr"
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_OPENER=/home/omar/.config/nnn/plugins/nuke
export GUI=1
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi


    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # Run nnn
    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

