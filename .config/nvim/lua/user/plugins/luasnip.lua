return {
	"L3MON4D3/LuaSnip",
	version = "2.*",
	event = "InsertEnter",
	build = "make install_jsregexp",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = { vim.fs.joinpath(vim.fn.stdpath("config"), "snippets") },
		})
		require("luasnip.config").setup({ enable_autosnippets = true })
	end,
}
