function sway-kill -d "Forcefully kills focused application"
    set PID (swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true).pid')
    
    if test -n "$PID" 
        kill $PID
    else
        swaynag -m (status basename)": No PID was obtained"
    end
end
