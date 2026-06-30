local query_drivers = vim.fn.has("mac") == 1
		and "/opt/homebrew/opt/llvm/bin/clang,/opt/homebrew/opt/llvm/bin/clang++"
	or "/usr/bin/clang*,/usr/bin/clang++*,/usr/bin/gcc*,/usr/bin/g++*"

return {
    filetypes = {
        "c", "cpp", "cuda"
    },
	cmd = {
		"clangd",
        "--enable-config",
		"--background-index",
		"--query-driver=" .. query_drivers,
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
