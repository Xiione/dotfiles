function pusshfs --description 'Mount, use, and unmount the personal SSHFS directory'
    if not set -q pusshfs_home; or not set -q pusshfs_mp
        echo 'pusshfs_home and pusshfs_mp must be configured in secrets.fish' >&2
        return 1
    end

    checkidentities; or return 1
    pfsum

    sshfs -o noapplexattr,noappledouble "data:$pusshfs_home" "$pusshfs_mp"
    and echo "Successfully mounted $pusshfs_home at $pusshfs_mp"
    and pussh
    and pfsum
    or begin
        echo 'SSHFS workflow failed' >&2
        return 1
    end
end
