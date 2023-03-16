return {
	cmd = {
		"clangd",
		"--background-index",
		"--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
		"--clang-tidy",
		"--clang-tidy-checks=*",
		"--cross-file-rename",
		"--completion-style=detailed",
		"--header-insertion=never",
		"--pch-storage=memory",
	},
}
