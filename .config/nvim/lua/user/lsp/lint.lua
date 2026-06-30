local lint_ok, lint = pcall(require, "lint")
if not lint_ok then
	return
end

local M = {}

local figma_root = vim.fs.joinpath(vim.env.HOME, "figma", "figma")
local figma_web_root = figma_root .. "/web"
local figma_viewer_root = figma_root .. "/viewer"

local function severity(value)
	if value == 2 or value == "error" or value == "fatal" then
		return vim.diagnostic.severity.ERROR
	end
	if value == 1 or value == "warning" or value == "warn" or value == "convention" or value == "refactor" then
		return vim.diagnostic.severity.WARN
	end
	if value == "info" then
		return vim.diagnostic.severity.INFO
	end
	return vim.diagnostic.severity.HINT
end

local function decode_json(output)
	if output == nil or output == "" then
		return nil
	end

	local ok, decoded = pcall(vim.json.decode, output)
	if not ok then
		return nil
	end
	return decoded
end

local function with_source(message, source)
	if source == nil or source == "" then
		return message
	end
	return string.format("%s [%s]", message, source)
end

local function parse_eslint(output)
	local decoded = decode_json(output)
	if decoded == nil then
		return {}
	end

	local diagnostics = {}
	for _, file in ipairs(decoded) do
		for _, item in ipairs(file.messages or {}) do
			table.insert(diagnostics, {
				lnum = math.max((item.line or 1) - 1, 0),
				col = math.max((item.column or 1) - 1, 0),
				end_lnum = item.endLine and math.max(item.endLine - 1, 0) or nil,
				end_col = item.endColumn and math.max(item.endColumn - 1, 0) or nil,
				severity = severity(item.severity),
				message = with_source(item.message or "", item.ruleId),
				source = "eslint",
			})
		end
	end
	return diagnostics
end

local function parse_oxlint(output)
	local decoded = decode_json(output)
	if decoded == nil then
		return {}
	end

	local items = decoded.diagnostics or decoded
	local diagnostics = {}
	for _, item in ipairs(items) do
		local label = item.labels and item.labels[1] or {}
		local span = item.span or label.span or {}
		local line = item.line or span.line or 1
		local column = item.column or span.column or 1

		table.insert(diagnostics, {
			lnum = math.max(line - 1, 0),
			col = math.max(column - 1, 0),
			end_lnum = item.end_line and math.max(item.end_line - 1, 0) or nil,
			end_col = item.end_column and math.max(item.end_column - 1, 0) or nil,
			severity = severity(item.severity),
			message = with_source(item.message or "", item.code or item.rule_id),
			source = "oxlint",
		})
	end
	return diagnostics
end

local function parse_rubocop(output)
	local decoded = decode_json(output)
	if decoded == nil then
		return {}
	end

	local diagnostics = {}
	for _, file in ipairs(decoded.files or {}) do
		for _, offense in ipairs(file.offenses or {}) do
			local location = offense.location or {}
			table.insert(diagnostics, {
				lnum = math.max((location.start_line or location.line or 1) - 1, 0),
				col = math.max((location.start_column or location.column or 1) - 1, 0),
				end_lnum = location.last_line and math.max(location.last_line - 1, 0) or nil,
				end_col = location.last_column and math.max(location.last_column - 1, 0) or nil,
				severity = severity(offense.severity),
				message = with_source(offense.message or "", offense.cop_name),
				source = "rubocop",
			})
		end
	end
	return diagnostics
end

local function relative_to(path, root)
	local relative = vim.fs.relpath(root, path)
	if relative == nil then
		return path
	end
	return relative
end

local function current_filename()
	return vim.api.nvim_buf_get_name(0)
end

local function is_in_dir(path, root)
	return vim.fs.relpath(root, path) ~= nil
end

local function has_executable(path)
	return vim.fn.executable(path) == 1
end

local function node_supports_ts_oxlint_config()
	local node_version = vim.fn.systemlist({ "node", "--version" })[1] or ""
	local major, minor = node_version:match("^v(%d+)%.(%d+)")
	major = tonumber(major)
	minor = tonumber(minor)
	if major == nil or minor == nil then
		return false
	end

	return (major == 20 and minor >= 19) or (major > 22) or (major == 22 and minor >= 18)
end

lint.linters.rubocop = {
	cmd = "bundle",
	stdin = true,
	args = {
		"exec",
		"rubocop",
		"-f",
		"json",
		"--force-exclusion",
		"--display-only-fail-level-offenses",
		"--stdin",
		function()
			return current_filename()
		end,
	},
	ignore_exitcode = true,
	parser = parse_rubocop,
}

lint.linters.figma_web_eslint_fast = {
	cmd = figma_web_root .. "/node_modules/.bin/eslint",
	cwd = figma_web_root,
	stdin = true,
	args = {
		"--format",
		"json",
		"--config",
		"eslint.config.fast.mjs",
		"--report-unused-disable-directives",
		"--stdin",
		"--stdin-filename",
		function()
			return relative_to(current_filename(), figma_web_root)
		end,
	},
	ignore_exitcode = true,
	parser = parse_eslint,
}

lint.linters.figma_web_oxlint = {
	cmd = figma_web_root .. "/node_modules/.bin/oxlint",
	cwd = figma_web_root,
	stdin = false,
	append_fname = false,
	args = {
		"--format",
		"json",
		"--config",
		"oxlint.config.ts",
		"--report-unused-disable-directives",
		function()
			return relative_to(current_filename(), figma_web_root)
		end,
	},
	ignore_exitcode = true,
	parser = parse_oxlint,
}

lint.linters.figma_viewer_eslint = {
	cmd = figma_viewer_root .. "/node_modules/.bin/eslint",
	cwd = figma_viewer_root,
	stdin = true,
	args = {
		"--format",
		"json",
		"--cache",
		"--stdin",
		"--stdin-filename",
		function()
			return relative_to(current_filename(), figma_viewer_root)
		end,
	},
	ignore_exitcode = true,
	parser = parse_eslint,
}

lint.linters_by_ft = {
	ruby = { "rubocop" },
}

local function linters_for_buffer(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local filetype = vim.bo[bufnr].filetype
	local linters = vim.list_slice(lint.linters_by_ft[filetype] or {})

	if filename:match("%.jsx?$") or filename:match("%.tsx?$") then
		if is_in_dir(filename, figma_web_root .. "/js") and has_executable(lint.linters.figma_web_eslint_fast.cmd) then
			table.insert(linters, "figma_web_eslint_fast")
			if has_executable(lint.linters.figma_web_oxlint.cmd) and node_supports_ts_oxlint_config() then
				table.insert(linters, "figma_web_oxlint")
			end
		elseif
			is_in_dir(filename, figma_viewer_root .. "/ts") and has_executable(lint.linters.figma_viewer_eslint.cmd)
		then
			table.insert(linters, "figma_viewer_eslint")
		end
	end

	return linters
end

M.try_lint = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local linters = linters_for_buffer(bufnr)
	if #linters == 0 then
		return
	end

	lint.try_lint(linters)
end

M.try_all = function()
	M.try_lint()
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
	callback = function(ctx)
		M.try_lint(ctx.buf)
	end,
})

return M
