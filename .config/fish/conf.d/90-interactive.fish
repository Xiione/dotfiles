status is-interactive; or return

if command -q direnv
    direnv hook fish | source
end

if command -q pyenv
    pyenv init - fish | source
end

if command -q omniwmctl
    omniwmctl completion fish | source
end

if command -q zoxide
    zoxide init fish | source
end

if command -q fzf; and fzf --fish >/dev/null 2>&1
    fzf --fish | source
end
