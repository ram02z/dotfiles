status is-interactive || exit

# Git Aliases from https://bitsofco.de/git-aliases-for-lazy-developers/
if type -q git
    abbr --add gs "git status"
    abbr --add gf "git fetch"
    abbr --add gd "git diff"
    abbr --add gaa "git add -A"
    abbr --add gacm "git add . && git commit -m"
    abbr --add gcam "git commit -am"
    abbr --add gca "git commit -a"
    abbr --add gcaa "git commit -a --amend"
    abbr --add gp "git push"
    abbr --add gl "git pull"
    # Pushing/pulling to origin remote
    abbr --add gpo "git push origin" # + branch name
    abbr --add glo "git pull origin" # + branch name
    # Pushing/pulling to origin remote, master branch
    abbr --add gpom "git push origin master"
    abbr --add glom "git pull origin master"
    abbr --add gb "git branch" # + branch name
    abbr --add gc "git checkout" # + branch name
    abbr --add gcb "git checkout -b" # + branch name
end

# C utils
if type -q valgrind
    abbr --add vgmc "valgrind --tool=memcheck --leak-check=yes --show-reachable=yes"
end

# Chezmoi
if type -q chezmoi
    abbr --add czm "chezmoi"
end
