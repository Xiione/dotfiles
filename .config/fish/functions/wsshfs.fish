function wsshfs --description 'Mount, connect to, and unmount a remote SSHFS directory'
    if test (count $argv) -lt 3; or test (count $argv) -gt 4
        echo 'Usage: wsshfs remote remote_path mount_point [port]' >&2
        return 2
    end

    checkidentities; or return 1

    set -l remote $argv[1]
    set -l remote_path $argv[2]
    set -l mount_point $argv[3]
    set -l port 22
    test (count $argv) -eq 4; and set port $argv[4]

    sshfsum "$mount_point"
    sshfs -o noapplexattr,noappledouble "$remote:$remote_path" "$mount_point" -p "$port"
    and echo "Successfully mounted $remote at $mount_point"
    and ssh -p "$port" "$remote"
    and sshfsum "$mount_point"
    or begin
        echo 'SSHFS workflow failed' >&2
        return 1
    end
end
