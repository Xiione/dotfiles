if status is-login
    neofetch
end

fish_add_path /opt/homebrew/bin
fish_add_path /Library/TeX/texbin/latexmk
fish_add_path ~/.cargo/bin/

set -g theme_color_scheme nord
set -gx EDITOR nvim
set -gx VISUAL nvim

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


set -g pusshfs_mp ~/code/pussh
set -g pussh_server wang5660@data.cs.purdue.edu
# set -g pussh_server wang5660@borg01.cs.purdue.edu
set -g pusshfs_home /homes/wang5660/
set -g pusshfs_mp ~/code/pussh

function pussh
    set -l pussh_password $(security find-generic-password -a "$USER" -s "pusshpass" -w)
    TERM=xterm-256color expect ~/.local/scripts/exp.sh $pussh_password ssh $pussh_server
end

function pfsum
    echo "Trying unmount"
    diskutil umount force $pusshfs_mp
end

function pusshfs
    pfsum
    set -l pussh_password $(security find-generic-password -a "$USER" -s "pusshpass" -w)
    echo $pussh_password | sshfs "$pussh_server:$pusshfs_home" $pusshfs_mp -o password_stdin && 
        echo "Successfully mounted $pussh_server:$pusshfs_home at $pusshfs_mp" &&
        pussh &&
        pfsum ||
        echo "Mount failed"
end

function purgedsstore
    find . -name ".DS_Store" -type f -print -delete
end

