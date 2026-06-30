function newcpprob --description 'Create a competitive-programming C++ problem directory'
    argparse X -- $argv
    or begin
        echo 'Usage: newcpprob problem_name [-X]' >&2
        return 2
    end

    if test (count $argv) -ne 1
        echo 'Usage: newcpprob problem_name [-X]' >&2
        return 2
    end

    set -l problem_name $argv[1]
    set -l problem_path "./$problem_name"
    if test -d "$problem_path"
        echo "Directory $problem_path exists" >&2
        return 1
    end

    mkdir "$problem_path"
    or begin
        echo "Failed to create directory $problem_path" >&2
        return 1
    end

    ln -sfn "$__fish_config_dir/newcpprob.makefile" "$problem_path/Makefile"
    or begin
        echo 'Failed to symlink Makefile' >&2
        return 1
    end

    ln -sfn "$__fish_config_dir/cpprob.yaml" "$problem_path/.clangd"
    or begin
        echo 'Failed to symlink clangd config' >&2
        return 1
    end

    set -l problem_source "$problem_name.cpp"
    touch "$problem_path/$problem_source"
    or begin
        echo "Failed to create $problem_source" >&2
        return 1
    end

    cd "$problem_path"
end
