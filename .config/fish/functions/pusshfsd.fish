function pusshfsd --description 'Mount a selected directory from the personal data host'
    if test (count $argv) -ne 1
        echo 'Usage: pusshfsd remote_path' >&2
        return 2
    end

    if not set -q pusshfs_mp
        echo 'pusshfs_mp is not configured in secrets.fish' >&2
        return 1
    end

    checkidentities; or return 1
    pfsum

    set -l remote_path $argv[1]
    sshfs -o noapplexattr,noappledouble "data:$remote_path" "$pusshfs_mp"
    and echo "Successfully mounted $remote_path at $pusshfs_mp"
    and pussh
    and pfsum
    or begin
        echo 'SSHFS workflow failed' >&2
        return 1
    end
end
