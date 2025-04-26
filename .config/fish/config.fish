# if status is-login
#     neofetch
# end

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

# aliases
alias nv="nvim" 
alias lzg="lazygit"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

function ssh
    TERM=xterm-256color command ssh $argv
end

function checkidentities
    test "$(ssh-add -l)" != "The agent has no identities."
    and return 0
    # echo "The SSH agent has no identities. Aborting..."

    # hit enter to switch spaces to 4, 
    echo "Hit enter to switch to space 4 for keepass, any other key to cancel..."
    read -n1 key

    # enter gives empty
    test -z key
    and return 1
    
    yabai -m space --focus 4

    echo "Hit any key to proceed..."
    read -n1 key

    return 0
end

function pussh
    checkidentities 
    or return 1
    # set -l pussh_password $(security find-generic-password -a "$USER" -s "pusshpass" -w)
    # TERM=xterm-256color expect ~/.local/scripts/exp.sh $pussh_password ssh $pussh_server
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
    # set -l pussh_password $(security find-generic-password -a "$USER" -s "pusshpass" -w)
    # echo $pussh_password | sshfs "$pussh_server:$pusshfs_home" $pusshfs_mp -o password_stdin && 
    #     echo "Successfully mounted $pussh_server:$pusshfs_home at $pusshfs_mp" &&
    #     pussh &&
    #     pfsum ||
    #     echo "Mount failed"
    sshfs -o noapplexattr,noappledouble "data:$pusshfs_home" $pusshfs_mp && 
        echo "Successfully mounted $pusshfs_home at $pusshfs_mp" &&
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

    ln "$__fish_config_dir/newcpprob.makefile" "$probpath/Makefile"
    or begin
        echo "Failed to symlink Makefile"
        return 1
    end
    ln "$__fish_config_dir/cpprob.yaml" "$probpath/.clangd"
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

    # if not set -q _flag_x
    #     cd $probpath
    #     nvim "./$probsrc"
    # end
    cd "$probpath"
    or begin
        echo "Failed to change directory to $probpath"
        return 1
    end
end

function rehash_yabai
    echo "$(whoami) ALL=(root) NOPASSWD:SETENV: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
end

zoxide init fish | source
fzf --fish | source

# pnpm
set -gx PNPM_HOME "/Users/hamilton/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
