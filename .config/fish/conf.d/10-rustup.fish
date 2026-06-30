set -l rustup_environment "$HOME/.cargo/env.fish"
test -r "$rustup_environment"; and source "$rustup_environment"
