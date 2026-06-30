return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		if #vim.api.nvim_list_uis() > 0 then
			vim.defer_fn(function()
				require("nvim-treesitter").install(require("user.cfg.tooling").treesitter_parsers)
			end, 1000)
		end
	end,
}
