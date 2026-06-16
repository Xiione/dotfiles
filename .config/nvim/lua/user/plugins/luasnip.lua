return {
	"L3MON4D3/LuaSnip",
	version = "2.*",
	build = "make install_jsregexp",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
		require("luasnip.config").setup({ enable_autosnippets = true })
	end,
}
