if test (uname -s) != Darwin
    # Coder is dedicated to the Figma checkout. Preserve its Linux MISE_ENV and
    # keep the repository runtime settings available from every shell location.
    set -gx NODE_OPTIONS --max-old-space-size=8192
    set -gx RACK_ENV development

    set -l aws_config "$HOME/figma/figma/config/aws/sso_config"
    test -f "$aws_config"; and set -gx AWS_CONFIG_FILE "$aws_config"
    return
end

set -g __figma_pkg_config_paths \
    /opt/homebrew/opt/zlib/lib/pkgconfig \
    /usr/local/opt/zlib/lib/pkgconfig \
    /opt/homebrew/opt/openssl@3/lib/pkgconfig \
    /usr/local/opt/openssl@3/lib/pkgconfig

set -g __figma_tool_paths \
    "$HOME/.opengrep/cli/latest" \
    "$HOME/go/bin" \
    "$HOME/.local/share/mise/shims" \
    "$HOME/.rbenv/shims"

set -g __base_path
for executable_path in $PATH
    if not contains -- "$executable_path" $__figma_tool_paths
        and not contains -- "$executable_path" $__base_path
        set -a __base_path "$executable_path"
    end
end

set -g __base_pkg_config_path
for pkg_config_path in $PKG_CONFIG_PATH
    if test -n "$pkg_config_path"; and not contains -- "$pkg_config_path" $__figma_pkg_config_paths
        set -a __base_pkg_config_path "$pkg_config_path"
    end
end

function __is_figma_path --argument-names path
    string match -q -- "$HOME/figma" "$path"
    or string match -q -- "$HOME/figma/*" "$path"
end

function __update_figma_environment --on-variable PWD
    if not __is_figma_path "$PWD"
        set -gx PATH $__base_path
        set -e MISE_ENV
        set -e NODE_OPTIONS
        set -e RACK_ENV
        set -e AWS_CONFIG_FILE

        if test (count $__base_pkg_config_path) -gt 0
            set -gx PKG_CONFIG_PATH $__base_pkg_config_path
        else
            set -e PKG_CONFIG_PATH
        end

        return
    end

    set -gx PATH $__figma_tool_paths $__base_path
    set -gx MISE_ENV macos
    set -gx NODE_OPTIONS --max-old-space-size=8192
    set -gx RACK_ENV development

    set -l aws_config "$HOME/figma/figma/config/aws/sso_config"
    if test -f "$aws_config"
        set -gx AWS_CONFIG_FILE "$aws_config"
    else
        set -e AWS_CONFIG_FILE
    end

    set -l pkg_config_paths
    for pkg_config_path in $__figma_pkg_config_paths
        test -d "$pkg_config_path"; and set -a pkg_config_paths "$pkg_config_path"
    end
    set -gx PKG_CONFIG_PATH $pkg_config_paths $__base_pkg_config_path
end

__update_figma_environment
