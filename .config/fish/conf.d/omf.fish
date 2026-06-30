status is-interactive; or return

# Path to Oh My Fish install.
set -q XDG_DATA_HOME
and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration when it is installed.
test -r "$OMF_PATH/init.fish"; and source "$OMF_PATH/init.fish"
