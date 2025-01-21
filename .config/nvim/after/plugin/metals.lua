local status_ok, metals = pcall(require, "metals")
if not status_ok then
	return
end

local keymaps = require("user.cfg.keymaps")

local metals_config = metals.bare_config()

local local_projs = vim.fn.expand("~/code/cs352/projs")

metals_config.settings = {
	showImplicitArguments = true,
    scalafmtConfigPath = local_projs .. "/.scalafmt.conf",
}

metals_config.init_options.statusBarProvider = "off"
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- stop detecting root so sshfs doesnt lag out
metals_config.root_patterns = {}

metals_config.on_attach = function(client, bufnr)
	metals.setup_dap()
	keymaps.lsp_keymaps(bufnr, client)
end

-- disable for now, the stuff it does with the mounted fs is annoyingly laggy
-- local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "scala", "sbt" },
-- 	callback = function()
-- 		metals.initialize_or_attach(metals_config)
-- 	end,
-- 	group = nvim_metals_group,
-- })
