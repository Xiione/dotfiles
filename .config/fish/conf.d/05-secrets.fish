set -l secrets_file "$__fish_config_dir/secrets.fish"
test -r "$secrets_file"; and source "$secrets_file"
