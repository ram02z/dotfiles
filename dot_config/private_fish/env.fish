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
