status is-interactive; or return

if test (uname -s) != Darwin
    if command -q mise
        mise activate fish | source
    end

    if command -q rbenv
        rbenv init - --no-rehash fish | source
    end
    return
end

function __activate_figma_toolchain --on-variable PWD
    set -q __is_figma_toolchain_active; and return
    __is_figma_path "$PWD"; or return

    set -g __is_figma_toolchain_active true

    if command -q mise
        mise activate fish | source
    end

    if command -q rbenv
        rbenv init - --no-rehash fish | source
    end
end

__activate_figma_toolchain
