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
		markdown = function(bufnr)
			local formatter = conform.get_formatter_info("prettierd", bufnr).available and "prettierd" or "prettier"
			return { formatter, "trim_inline_math_inner" }
		end,
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
		trim_inline_math_inner = {
			format = function(_, _, lines, callback)
				local result = {}
				for _, line in ipairs(lines) do
					local trimmed = line:gsub("(%$+)([^$]-)(%$+)", function(opening, expression, closing)
						if opening == "$" and closing == "$" then
							return "$" .. vim.trim(expression) .. "$"
						end
						return opening .. expression .. closing
					end)
					table.insert(result, trimmed)
				end
				callback(nil, result)
			end,
		},
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
