function sway-prop -d "Returns information about focused window"
    set TMP "/tmp/swap-prop-$fish_pid.tmp"
    trap "rm $TMP" EXIT
    swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true)' > "$TMP"

    if begin; test (count $argv) -gt 0; and test -d $argv[1]; end 
        cat "$TMP"
    else
        set app_id (cat $TMP | jq '.app_id' | tr -d \")
        swaynag -l -m "$app_id" < "$TMP"
    end
end
