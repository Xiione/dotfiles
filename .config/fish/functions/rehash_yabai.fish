function rehash_yabai --description 'Update the sudoers hash for yabai scripting addition'
    command -q trash; or begin
        echo 'trash is required for temporary-file cleanup' >&2
        return 127
    end

    set -l yabai_path (command -s yabai)
    if test -z "$yabai_path"
        echo 'yabai is not installed' >&2
        return 127
    end

    set -l yabai_hash (shasum -a 256 "$yabai_path" | string split ' ')[1]
    set -l sudoers_file (mktemp -t yabai-sudoers); or return 1
    printf '%s ALL=(root) NOPASSWD:SETENV: sha256:%s %s --load-sa\n' \
        (whoami) "$yabai_hash" "$yabai_path" >"$sudoers_file"

    sudo /usr/sbin/visudo -cf "$sudoers_file"
    or begin
        trash "$sudoers_file"
        return 1
    end

    sudo install -o root -g wheel -m 0440 "$sudoers_file" /private/etc/sudoers.d/yabai
    set -l install_status $status
    trash "$sudoers_file"
    return $install_status
end
