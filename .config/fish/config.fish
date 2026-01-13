if status is-login
    fish_add_path /usr/local/bin
    fish_add_path /opt/homebrew/bin
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.local/bin

    fish_add_path /Library/TeX/texbin
    fish_add_path ~/Library/Python/3.11/bin
    fish_add_path ~/.pyenv/shims
    fish_add_path /usr/local/opt/llvm/bin

    set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"
    set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

    set -gx EDITOR nvim
    set -gx VISUAL nvim


    # aliases
    alias nv="nvim" 
    alias lzg="lazygit"
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

    function brew -d "Update outdated packages after running brew commands"
        command brew $argv
        if test $argv[1] = 'upgrade'
            or test $argv[1] = 'update'
                or test $argv[1] = 'outdated'
            sketchybar --trigger brew_update
        end
    end
end

source "$__fish_config_dir/secrets.fish"

# rest is just for terminal use
if not status is-interactive
    return
end

set -g theme_color_scheme nord
set -g theme_vcs_ignore_paths "$HOME/co/backend"


function ll 
    ls -a $argv
end


function ssh
    TERM=xterm-256color command ssh $argv
end

function checkidentities
    test "$(ssh-add -l)" != "The agent has no identities."
    and return 0
    # echo "The SSH agent has no identities. Aborting..."

    echo "Hit enter to switch keepass, any other key to cancel..."
    read -n1 key

    # enter gives empty
    test -z key
    and return 1
    
    open /Applications/KeePassXC.app

    echo "Hit any key to proceed..."
    read -n1 key

    return 0
end

function pussh
    checkidentities 
    or return 1
    ssh data
end

function pfsum
    echo "Trying unmount"
    sudo diskutil umount force $pusshfs_mp
end

function pusshfs
    checkidentities 
    or return 1
    pfsum
    sshfs -o noapplexattr,noappledouble "data:$pusshfs_home" $pusshfs_mp && 
        echo "Successfully mounted $pusshfs_home at $pusshfs_mp" &&
        pussh &&
        pfsum ||
        echo "Unmount failed"
end

function pusshfsd
    checkidentities 
    or return 1

    if test (count $argv) -eq 0
        echo "Usage: pusshfsd remote_path"
        return 1
    end
    

    pfsum

    set -l rmountpoint $argv[1]
    sshfs -o noapplexattr,noappledouble "data:$rmountpoint" $pusshfs_mp && 
        echo "Successfully mounted $rmountpoint at $pusshfs_mp" &&
        pussh &&
        pfsum ||
        echo "Unmount failed"
end

function purgedsstore
    find . -name ".DS_Store" -type f -print -delete
end

function newcpprob
    argparse 'X' -- $argv
    or begin
        echo "Usage: newcpprob problem_name [-X] "
        return 1
    end

    if test (count $argv) -eq 0
        echo "Usage: newcpprob problem_name [-X] "
        return 1
    end

    set -l probname $argv[1]
    set -l probpath "./$probname"

    if test -e ./$probpath && test -d ./$probpath
        echo "Directory $probpath exists"
        return 1
    end

    mkdir $probpath
    or begin
        echo "Failed to create directory $probpath"
        return 1
    end

    ln -sfn "$__fish_config_dir/newcpprob.makefile" "$probpath/Makefile"
    or begin
        echo "Failed to symlink Makefile"
        return 1
    end
    ln -sfn "$__fish_config_dir/cpprob.yaml" "$probpath/.clangd"
    or begin
        echo "Failed to symlink clangd config"
        return 1
    end

    set -l probsrc "$probname.cpp"

    touch "$probpath/$probsrc"
    or begin
        echo "Failed to create $probsrc"
        return 1
    end

    cd "$probpath"
    or begin
        echo "Failed to change directory to $probpath"
        return 1
    end
end

function rehash_yabai
    echo "$(whoami) ALL=(root) NOPASSWD:SETENV: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
end

function gamemode
    $__fish_config_dir/functions/gamemode.sh
end

function devbox_run
    cd ~/co/backend/; and direnv reload; and bin/taskrunner devbox/run
end

# assumes each app has 1 window
function arrange_windows
    yabai -m query --windows | jq -r '.[] | [.id, (.app | gsub("[^a-zA-Z0-9_]"; ""))] | @tsv' | while read -l id app
        set -g $app $id
        yabai -m window $id --space 5
    end

    set -l s1 Neogurt
    set -l s2 Arc
    set -l s3 KeePassXC Calendar Reminders Messages Obsidian
    set -l s4 Nicotine Feishin Discord

    set -l spaces s1 s2 s3 s4
    for s in (seq (count $spaces))
        set -g previd 0
        for app in $$spaces[$s]
            if test $previd -eq 0
                # echo "app: $app"
                # echo "yabai -m window $$app --space $s"
                yabai -m window $$app --space $s
                set -g previd $$app
                continue
            end

            # echo "yabai -m window $$app --space $s"
            yabai -m window $$app --space $s
            # echo "yabai -m window $$app --stack $previd"
            yabai -m window $previd --stack $$app  
            set -g previd $$app
        end
    end
    sketchybar --trigger windows_on_spaces
end

docker completion fish > ~/.config/fish/completions/docker.fish
zoxide init fish | source
fzf --fish | source

# pnpm
set -gx PNPM_HOME "/Users/hamilton/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

direnv hook fish | source
