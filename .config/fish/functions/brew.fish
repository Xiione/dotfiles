function brew --wraps=brew --description 'Run Homebrew and refresh its SketchyBar status'
    command brew $argv
    set -l brew_status $status

    if test $brew_status -eq 0
        and test (count $argv) -gt 0
        and contains -- $argv[1] upgrade update outdated
        and command -q sketchybar
        sketchybar --trigger brew_update
    end

    return $brew_status
end
