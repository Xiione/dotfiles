set -l uv_environment "$HOME/.local/bin/env.fish"
test -r "$uv_environment"; and source "$uv_environment"
