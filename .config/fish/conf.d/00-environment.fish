set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -gx PYENV_ROOT "$HOME/.pyenv"

set -l host_os (uname -s)
if test "$host_os" = Darwin
    set -gx PNPM_HOME "$HOME/Library/pnpm"

    if test -d /opt/homebrew
        set -gx HOMEBREW_PREFIX /opt/homebrew
    else if test -d /usr/local/Homebrew
        set -gx HOMEBREW_PREFIX /usr/local
    end
end

begin
    set -l configured_paths \
        "$HOME/.local/bin" \
        "$HOME/.fzf/bin" \
        "$PNPM_HOME" \
        "$HOME/.cargo/bin" \
        "$HOME/go/bin" \
        "$HOME/.local/share/mise/shims" \
        "$HOME/.rbenv/shims" \
        "$PYENV_ROOT/shims" \
        "$PYENV_ROOT/bin"

    if test "$host_os" = Darwin
        if set -q HOMEBREW_PREFIX
            set -a configured_paths "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
        end

        set -a configured_paths \
            /opt/homebrew/bin \
            /opt/homebrew/sbin \
            /usr/local/bin \
            /opt/homebrew/opt/openssl/bin \
            /usr/local/opt/openssl/bin \
            /opt/homebrew/opt/llvm/bin \
            /usr/local/opt/llvm/bin \
            /Library/TeX/texbin \
            "$HOME/Library/Python/3.11/bin"
    end

    fish_add_path --move --path $configured_paths
end
