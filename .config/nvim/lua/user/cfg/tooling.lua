local M = {}

local is_devcontainer = vim.env.DEVCONTAINER == "1"
local minimum_treesitter_version = { 0, 26, 1 }

local function verify_treesitter_cli()
	local tree_sitter_path = vim.fn.exepath("tree-sitter")
	if tree_sitter_path == "" then
		error("tree-sitter-cli is unavailable")
	end
	if is_devcontainer then
		local expected_path = vim.fs.normalize(vim.fn.expand("~/.local/bin/tree-sitter"))
		if vim.uv.fs_realpath(tree_sitter_path) ~= vim.uv.fs_realpath(expected_path) then
			error(
				string.format(
					"expected the devcontainer Tree-sitter CLI at %s; found %s",
					expected_path,
					tree_sitter_path
				)
			)
		end
	end

	local version_result = vim.system({ tree_sitter_path, "--version" }, { text = true }):wait(10000)
	if version_result.code ~= 0 then
		local failure_message = vim.trim(version_result.stderr or "")
		if failure_message == "" then
			failure_message = vim.trim(version_result.stdout or "")
		end
		if failure_message == "" then
			failure_message = string.format("exit code %s", version_result.code)
		end
		error(string.format("%s could not start: %s", tree_sitter_path, failure_message))
	end

	local version_output = vim.trim(string.format("%s\n%s", version_result.stdout or "", version_result.stderr or ""))
	local installed_version = vim.version.parse(version_output)
	if not installed_version or not vim.version.ge(installed_version, minimum_treesitter_version) then
		error(
			string.format(
				"tree-sitter-cli >= %s is required; found %s",
				table.concat(minimum_treesitter_version, "."),
				version_output
			)
		)
	end
end

local function run_or_quit(step, callback)
	local ok, err = pcall(callback)
	if ok then
		return
	end

	vim.api.nvim_err_writeln(string.format("%s failed: %s", step, err))
	vim.cmd("cquit")
end

M.lsp_servers = {
	"lua_ls",
	"cssls",
	"html",
	"ts_ls",
	"pyright",
	"bashls",
	"jsonls",
	"yamlls",
	"clangd",
	"texlab",
	"marksman",
	"neocmake",
	"svelte",
	"glsl_analyzer",
	"tailwindcss",
	"kotlin_lsp",
	"copilot",
	"buf_ls",
}

M.mason_packages = {
	"asmfmt",
	"bash-language-server",
	"black",
	"buf",
	"clang-format",
	"clangd",
	"cmakelang",
	"codelldb",
	"copilot-language-server",
	"cpplint",
	"css-lsp",
	"debugpy",
	"delve",
	"glsl_analyzer",
	"gofumpt",
	"google-java-format",
	"html-lsp",
	"java-debug-adapter",
	"java-test",
	"jdtls",
	"json-lsp",
	"kotlin-lsp",
	"ktfmt",
	"ktlint",
	"latexindent",
	"lemminx",
	"lua-language-server",
	"marksman",
	"neocmakelsp",
	"prettierd",
	"pyright",
	"rust-analyzer",
	"selene",
	"shellcheck",
	"shfmt",
	"stylua",
	"svelte-language-server",
	"tailwindcss-language-server",
	"texlab",
	"typescript-language-server",
	"vale",
	"vim-language-server",
	"yaml-language-server",
}

if not is_devcontainer then
	table.insert(M.mason_packages, "tree-sitter-cli")
	table.sort(M.mason_packages)
end

M.treesitter_parsers = {
	"asm",
	"bash",
	"bibtex",
	"c",
	"cmake",
	"cpp",
	"css",
	"csv",
	"d",
	"diff",
	"dockerfile",
	"editorconfig",
	"faust",
	"fish",
	"git_config",
	"gitcommit",
	"gitignore",
	"glsl",
	"go",
	"gomod",
	"html",
	"ini",
	"java",
	"javascript",
	"json",
	"kotlin",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"matlab",
	"objc",
	"perl",
	"python",
	"ql",
	"query",
	"r",
	"rescript",
	"ruby",
	"rust",
	"scala",
	"sql",
	"ssh_config",
	"starlark",
	"strace",
	"svelte",
	"swift",
	"tcl",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

M.sync_treesitter = function()
	run_or_quit("Tree-sitter bootstrap", function()
		verify_treesitter_cli()

		local treesitter = require("nvim-treesitter")
		local installed = treesitter.install(M.treesitter_parsers, { summary = true }):wait(900000)
		if not installed then
			error("one or more parsers failed to install")
		end

		local updated = treesitter.update(M.treesitter_parsers, { summary = true }):wait(900000)
		if not updated then
			error("one or more parsers failed to update")
		end

		local parser_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "parser")
		local missing = {}
		for _, language in ipairs(M.treesitter_parsers) do
			local parser = vim.fs.joinpath(parser_dir, language .. ".so")
			if not vim.uv.fs_stat(parser) then
				table.insert(missing, language)
			end
		end

		if #missing > 0 then
			error("missing parsers: " .. table.concat(missing, ", "))
		end
	end)
end

M.verify_lazy = function()
	run_or_quit("Lazy restore", function()
		local lazy_plugin = require("lazy.core.plugin")
		local missing = {}
		local failed = {}
		for name, plugin in pairs(require("lazy.core.config").plugins) do
			if plugin.dir and not vim.uv.fs_stat(plugin.dir) then
				table.insert(missing, name)
			end
			if lazy_plugin.has_errors(plugin) then
				table.insert(failed, name)
			end
		end

		if #missing > 0 then
			table.sort(missing)
			error("missing plugins: " .. table.concat(missing, ", "))
		end
		if #failed > 0 then
			table.sort(failed)
			error("plugins with failed tasks: " .. table.concat(failed, ", "))
		end
	end)
end

M.verify_mason = function()
	run_or_quit("Mason bootstrap", function()
		local registry = require("mason-registry")
		local missing = {}
		for _, name in ipairs(M.mason_packages) do
			if not registry.get_package(name):is_installed() then
				table.insert(missing, name)
			end
		end

		if #missing > 0 then
			error("missing packages: " .. table.concat(missing, ", "))
		end
	end)
end

M.verify_treesitter = function()
	run_or_quit("Tree-sitter verification", function()
		verify_treesitter_cli()

		local parser_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "parser")
		local missing = {}
		for _, language in ipairs(M.treesitter_parsers) do
			local parser = vim.fs.joinpath(parser_dir, language .. ".so")
			if not vim.uv.fs_stat(parser) then
				table.insert(missing, language)
			end
		end

		if #missing > 0 then
			error("missing parsers: " .. table.concat(missing, ", "))
		end
	end)
end

M.verify_provisioning = function()
	M.verify_lazy()
	M.verify_mason()
	M.verify_treesitter()
end

return M
