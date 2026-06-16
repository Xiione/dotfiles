return {
	"scalameta/nvim-metals",
	dependencies = { "nvim-lua/plenary.nvim" },
	ft = { "scala", "sbt", "java" },
	config = function()
		local metals = require("metals")
		local keymaps = require("user.cfg.keymaps")
		local metals_config = metals.bare_config()
		local local_projs = vim.fn.expand("~/code/cs352/projs")

		metals_config.settings = {
			showImplicitArguments = true,
			scalafmtConfigPath = local_projs .. "/.scalafmt.conf",
		}
		metals_config.init_options.statusBarProvider = "off"
		metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
		metals_config.root_patterns = {}
		metals_config.on_attach = function(client, bufnr)
			metals.setup_dap()
			keymaps.lsp_keymaps(bufnr, client)
		end
	end,
}
