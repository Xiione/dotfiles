if status is-login
    neofetch
end

fish_add_path /opt/homebrew/bin
fish_add_path /Library/TeX/texbin/latexmk
fish_add_path ~/.cargo/bin
fish_add_path ~/Library/Python/3.11/bin

fish_add_path /opt/homebrew/opt/llvm/bin

set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

set -g theme_color_scheme nord
set -gx EDITOR nvim
set -gx VISUAL nvim

source ~/.config/fish/ssh_vars.fish

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

function ssh
    TERM=xterm-256color command ssh $argv
end


function pussh
    if test "$(ssh-add -l)" = "The agent has no identities."
        echo "The SSH agent has no identities. Aborting..."
        return
    end
    # set -l pussh_password $(security find-generic-password -a "$USER" -s "pusshpass" -w)
    # TERM=xterm-256color expect ~/.local/scripts/exp.sh $pussh_password ssh $pussh_server
    TERM=xterm-256color ssh $pussh_server
end

function pfsum
    echo "Trying unmount"
    sudo diskutil umount force $pusshfs_mp
end

function pusshfs
    if test "$(ssh-add -l)" = "The agent has no identities."
        echo "The SSH agent has no identities. Aborting..."
        return
    end
    pfsum
    # set -l pussh_password $(security find-generic-password -a "$USER" -s "pusshpass" -w)
    # echo $pussh_password | sshfs "$pussh_server:$pusshfs_home" $pusshfs_mp -o password_stdin && 
    #     echo "Successfully mounted $pussh_server:$pusshfs_home at $pusshfs_mp" &&
    #     pussh &&
    #     pfsum ||
    #     echo "Mount failed"
    sshfs "$pussh_server:$pusshfs_home" $pusshfs_mp && 
        echo "Successfully mounted $pussh_server:$pusshfs_home at $pusshfs_mp" &&
        pussh &&
        pfsum ||
        echo "Unmount failed"
end

function irssh
    if test "$(ssh-add -l)" = "The agent has no identities."
        echo "The SSH agent has no identities. Aborting..."
        return
    end
    TERM=xterm-256color ssh $irssh_server
end

function ifsum
    echo "Trying unmount"
    sudo diskutil umount force $irsshfs_mp
end

function irsshfs
    if test "$(ssh-add -l)" = "The agent has no identities."
        echo "The SSH agent has no identities. Aborting..."
        return
    end
    pfsum
    sshfs "$irssh_server:$irsshfs_home" $irsshfs_mp && 
        echo "Successfully mounted $irssh_server:$irsshfs_home at $irsshfs_mp" &&
        irssh &&
        pfsum ||
        echo "Unmount failed"
end

function purgedsstore
    find . -name ".DS_Store" -type f -print -delete
end

function hydrus
    sh ~/code/hydrus/hydrus_client.command
end
