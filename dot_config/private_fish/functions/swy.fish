function swy --wraps sway --description "Exports wayland variables and executes sway"
    set TTY1 (tty)
    if test -z "$DISPLAY"; and test $TTY1 = "/dev/tty1"
        set -x MOZ_ENABLE_WAYLAND 1
        set -x GDK_BACKEND wayland
        set -x QT_QPA_PLATFORM wayland
        set -x XDG_CURRENT_DESKTOP sway
        mkdir -p /tmp/{$USER}-runtime && chmod -R 0700 /tmp/{$USER}-runtime
        set -x XDG_RUNTIME_DIR /tmp/{$USER}-runtime
        # exec dbus-run-session sway
        exec sway
    end
end
