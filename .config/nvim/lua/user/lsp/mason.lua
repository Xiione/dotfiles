local servers = require("user.cfg.tooling").lsp_servers
require("mason").setup({
	ui = {
		border = "solid",
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
})
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

-- do not ensure installed but do config
local servers_bundled = {
	"ruby_lsp",
	"sorbet",
}
vim.list_extend(servers_bundled, servers)

local opts = {}

for _, server in pairs(servers_bundled) do
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
