function tailscale --description 'Run the Tailscale app CLI'
    set -l tailscale_cli /Applications/Tailscale.app/Contents/MacOS/Tailscale
    test -x "$tailscale_cli"; or begin
        echo "Tailscale CLI not found at $tailscale_cli" >&2
        return 127
    end

    command "$tailscale_cli" $argv
end
