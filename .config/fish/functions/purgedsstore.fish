function purgedsstore --description 'Move nested .DS_Store files to Trash'
    command -q trash; or begin
        echo 'trash is required to remove .DS_Store files safely' >&2
        return 127
    end

    find . -name .DS_Store -type f -print -exec trash {} +
end
