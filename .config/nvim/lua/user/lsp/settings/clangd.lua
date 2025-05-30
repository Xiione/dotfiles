return {
    filetypes = {
        "c", "cpp", "cuda"
    },
	cmd = {
		"clangd",
        "--enable-config",
		"--background-index",
		"--query-driver=/opt/homebrew/opt/llvm/bin/clang,/opt/homebrew/opt/llvm/bin/clang++",
		-- "--query-driver=/opt/homebrew/bin/gcc-14,/opt/homebrew/bin/g++-14,/opt/homebrew/opt/llvm/bin/clang,/opt/homebrew/opt/llvm/bin/clang++",
        -- "--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
		"--clang-tidy",
		"--clang-tidy-checks=*",
		"--cross-file-rename",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
        "--header-insertion-decorators",
		"--pch-storage=memory",
        "--rename-file-limit=50"
	},
}
