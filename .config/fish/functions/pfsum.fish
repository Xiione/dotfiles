function pfsum --description 'Unmount the personal SSHFS mount point'
    if not set -q pusshfs_mp
        echo 'pusshfs_mp is not configured in secrets.fish' >&2
        return 1
    end

    sshfsum "$pusshfs_mp"
end
