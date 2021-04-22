# TODO: make this file a template
set APT apt

# Ubuntu
if type -q $APT
    alias aup "sudo $APT update && $APT list --upgradable"
    alias aguu "sudo $APT update && sudo $APT upgrade"
    alias allpkgs 'dpkg --get-selections | grep -v deinstall'
    alias agud "sudo $APT update && sudo $APT dist-upgrade"
    # Batcat
    alias bat "batcat"
end

# Git Aliases from https://bitsofco.de/git-aliases-for-lazy-developers/
if type -q git
    alias gs "git status"
    alias gd "git diff"
    alias gaa "git add -A"
    alias gacm "git add . && git commit -m"
    alias gcam "git commit -am"
    alias gca "git commit -a"
    alias gcaa "git commit -a --amend"
    alias gi "git init"
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
end
# C utils
if type -q valgrind
    alias vgmc "valgrind --tool=memcheck --leak-check=yes --show-reachable=yes"
end

# Fish
alias fishconf "editor ~/.config/fish/config.fish"
alias src "source ~/.config/fish/config.fish"

# Directory
alias ... "cd ../.."
alias .... "cd ../../.."
