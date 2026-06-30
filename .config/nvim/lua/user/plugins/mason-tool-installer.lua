return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		run_on_start = false,
		ensure_installed = require("user.cfg.tooling").mason_packages,
	},
}
