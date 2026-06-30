function sshfsum --description 'Force-unmount an SSHFS mount point'
    if test (count $argv) -ne 1
        echo 'Usage: sshfsum mount_point' >&2
        return 2
    end

    echo "Trying to unmount $argv[1]"
    sudo diskutil unmount force "$argv[1]"
end
