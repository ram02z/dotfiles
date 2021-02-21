#
# Global Variables
#
set -gx fish_greeting ""
set -gx VISUAL "nvim"
set -gx TERMINAL "x-terminal-emulator"
set -gx DISPLAY :0

# WSL2 only settings
if string match -rq "(?i)(?=.*microsoft)^(?:[5-9])" (uname -r)
    set -gx DISPLAY (awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
    set -gx LIBGL_ALWAYS_INDIRECT 1
end

# Wayland only settings
if test -n "$WAYLAND_DISPLAY"
    set -gx MOZ_ENABLE_WAYLAND 1
end

#
# PATHS
#
set -gx PATH /bin
append-to-path /usr/bin
append-to-path ~/bin
append-to-path ~/.local/bin
append-to-path /usr/local/bin
append-to-path /snap/bin

# Go PATH
append-to-path /usr/local/go/bin
append-to-path ~/go/bin

# Rust PATH
append-to-path ~/.cargo/bin 
