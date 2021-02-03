set -gx PATH /bin
append-to-path /usr/bin
append-to-path ~/bin
append-to-path ~/.local/bin
append-to-path /usr/local/bin

# Go PATH
if type -q go
    append-to-path /usr/local/go/bin
    append-to-path ~/go/bin
end

# Rust PATH
if type -q cargo
    append-to-path ~/.cargo/bin 
end
