local utils = require("user.lib.utils")
local servers = {
	"lua_ls",
	"cssls",
	"html",
	"ts_ls",
	"pyright",
	"bashls",
	"jsonls",
	"yamlls",
	"jdtls",
	"clangd",
	"texlab",
	"asm_lsp",
	"marksman",
	"cmake",
	"svelte",
	"semgrep",
	"sourcekit",
    "glsl_analyzer",
    "tailwindcss",
    "denols",
    -- "shellcheck"
    "gopls",
    "protols",
}
local settings = {
	ui = {
		border = "solid",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
-- require("mason-lspconfig").setup({
--     ensure_installed = servers,
--     automatic_installation = true,
-- })

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	if server ~= "jdtls" and server ~= "semgrep" then
		lspconfig[server].setup(opts)
	end
end
