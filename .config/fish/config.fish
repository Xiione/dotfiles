if status is-login
    neofetch
end

fish_add_path /opt/homebrew/bin
fish_add_path /Library/TeX/texbin/latexmk

set -g theme_color_scheme nord

function brew -d "Update outdated packages after running brew commands"
    command brew $argv
    if test $argv[1] = 'upgrade'
        or test $argv[1] = 'update'
            or test $argv[1] = 'outdated'
        sketchybar --trigger brew_update
    end
end

function ll 
    ls -a $argv
end

function nv 
    nvim $argv
end

function v 
    nvim .
end

function ssh
    TERM=xterm-256color command ssh $argv
end

function pussh
    set -l pushh_server wang5660@data.cs.purdue.edu
    set -l pussh_password $(security find-generic-password -a "$USER" -s "pusshpass" -w)
    TERM=xterm-256color expect ~/.local/scripts/exp.sh $pussh_password ssh $pushh_server
end

set -gx EDITOR nvim
set -gx VISUAL nvim
