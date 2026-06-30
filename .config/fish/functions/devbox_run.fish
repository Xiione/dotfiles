function devbox_run --description 'Start the legacy backend devbox'
    set -l backend_dir "$HOME/co/backend"
    if not test -d "$backend_dir"
        echo "$backend_dir is not available on this machine" >&2
        return 1
    end

    cd "$backend_dir"; or return 1

    if command -q direnv
        direnv reload; or return 1
    end

    bin/taskrunner devbox/run
end
