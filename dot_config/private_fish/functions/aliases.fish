# System
alias upgrades "sudo apt update && apt list --upgradable"

# Git Aliases from https://bitsofco.de/git-aliases-for-lazy-developers/
alias gac "git add . && git commit -m"
alias gi "git init && gac 'Initial commit'"
alias gp "git push"
alias gl "git pull"
# Pushing/pulling to origin remote
alias gpo "git push origin" # + branch name
alias glo "git pull origin" # + branch name
# Pushing/pulling to origin remote, master branch
alias gpom "git push origin master"
alias glom "git pull origin master"
alias gb "git branch" # + branch name
alias gc "git checkout" # + branch name
alias gcb "git checkout -b" # + branch name

# C utils
alias gcc "gcc -Wall -ansi -pedantic-errors"
alias vgmc "valgrind --tool=memcheck --leak-check=yes --show-reachable=yes"

alias ccat "batcat"

# Fish
alias fishconfig "editor ~/.config/fish/config.fish"
alias src "source ~/.config/fish/config.fish"
