function checkidentities --description 'Ensure the SSH agent has an identity loaded'
    ssh-add -l >/dev/null 2>&1; and return 0

    echo 'Press Enter to open KeePassXC, or any other key to cancel.'
    read --nchars=1 key
    test -z "$key"; or return 1

    open /Applications/KeePassXC.app
    echo 'Load an SSH identity, then press any key to continue.'
    read --nchars=1

    ssh-add -l >/dev/null 2>&1
end
