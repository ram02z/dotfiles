function swy --wraps sway --description "Exports wayland variables and executes sway"
    set TTY1 (tty)
    if test -z "$DISPLAY"; and test $TTY1 = "/dev/tty1"
        set -x MOZ_ENABLE_WAYLAND 1
        set -x GDK_BACKEND wayland
        set -x QT_QPA_PLATFORM wayland-egl
        set -x XDG_CURRENT_DESKTOP sway
        exec dbus-run-session sway
    end
end
