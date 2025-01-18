local status_ok, metals = pcall(require, "metals")
if not status_ok then
	return
end

local keymaps = require("user.cfg.keymaps")

local metals_config = metals.bare_config()

metals_config.settings = {
	showImplicitArguments = true,
}

metals_config.init_options.statusBarProvider = "off"
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

metals_config.on_attach = function(client, bufnr)
	metals.setup_dap()
	keymaps.lsp_keymaps(bufnr, client)
end

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "scala", "sbt", "java" },
	callback = function()
		metals.initialize_or_attach(metals_config)
	end,
	group = nvim_metals_group,
})
