local servers = {
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
	"asm_lsp",
	"marksman",
	"neocmake",
	"svelte",
	-- "semgrep",
	-- "sourcekit",
	"glsl_analyzer",
	"tailwindcss",
	-- "denols",
	-- "shellcheck"
	"gopls",
	-- "protols",
	"kotlin_lsp",
}
local nonservers = {
	"asmfmt",
	"black",
	"clang-format",
	"cmakelang",
	"codelldb",
	"cpplint",
	"delve",
	"gofumpt",
	"google-java-format",
	"java-debug-adapter",
	"java-test",
	"jdtls",
	"ktfmt",
	"ktlint",
	"latexindent",
	"lemminx",
	"prettierd",
	"rust_analyzer",
	"selene",
	"shellcheck",
	"shfmt",
	"stylua",
	"tree-sitter-cli",
	"vale",
	"vimls",
}
require("mason").setup({
	ui = {
		border = "solid",
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
	ensure_installed = vim.list_extend(nonservers, servers),
})
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities(),
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	vim.lsp.config(server, opts)
	vim.lsp.enable(server)
end
