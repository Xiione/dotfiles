local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
	return
end

conform.setup({
	formatters_by_ft = {
		asm = { "asmfmt" },
		c = { "clang_format" },
		cmake = { "cmake_format" },
		cpp = { "clang_format" },
		css = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		java = { "google_java_format" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		jsonc = { "prettierd", "prettier", stop_after_first = true },
		kotlin = { "ktlint" },
		lua = { "stylua" },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		python = { "black" },
		ruby = { "rubocop" },
		scss = { "prettierd", "prettier", stop_after_first = true },
		sh = { "shfmt" },
		svelte = { "prettierd", "prettier", stop_after_first = true },
		toml = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "fallback",
	},
	formatters = {
		black = {
			prepend_args = { "--fast" },
		},
		rubocop = {
			command = "bundle",
			args = {
				"exec",
				"rubocop",
				"-a",
				"--force-exclusion",
				"-f",
				"quiet",
				"--stderr",
				"--stdin",
				"$FILENAME",
			},
			stdin = true,
			exit_codes = { 0, 1 },
		},
	},
})
