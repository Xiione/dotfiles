local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
	{ "windwp/nvim-autopairs" }, -- Autopairs, integrates with both cmp and treesitter
	{ "numToStr/Comment.nvim" },
	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "nvim-tree/nvim-tree.lua", version = "1.2" },
	-- use { "nvim-neo-tree/neo-tree.nvim" } }
	-- { "akinsho/bufferline.nvim", tag = "v3.1.0" },
	{ "moll/vim-bbye" },
	{ "nvim-lualine/lualine.nvim" },
	{ "akinsho/toggleterm.nvim" },
	-- { "ahmedkhalf/project.nvim" },
	-- { "lewis6991/impatient.nvim" },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl" },
	{ "goolord/alpha-nvim" },

	-- Colorschemes
	{ "Xiione/nord.nvim" },

	-- cmp plugins
	{ "hrsh7th/nvim-cmp" }, -- The completion plugin
	{ "hrsh7th/cmp-buffer" }, -- buffer completions
	{ "hrsh7th/cmp-path" }, -- path completions
	{ "saadparwaiz1/cmp_luasnip" }, -- snippet completions
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	}, --snippet engine
	-- { "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use

	-- LSP
	-- use { "williamboman/nvim-lsp-installer" } -- simple to use language server installer
	{ "neovim/nvim-lspconfig" }, -- enable LSP
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
	-- use { "RRethy/vim-illuminate" }

	-- Telescope
	{ "nvim-telescope/telescope.nvim" },

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},

	-- Git
	{ "lewis6991/gitsigns.nvim" },

	-- DAP
	{ "mfussenegger/nvim-dap" },
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{ "ravenxrz/DAPInstall.nvim" },

	-- mine :)
	{
		"jinh0/eyeliner.nvim",
		lazy = false,
	},
	{ "mfussenegger/nvim-jdtls" },
	{ "lukas-reineke/virt-column.nvim" },
	{ "mbbill/undotree" },
	{ "norcalli/nvim-colorizer.lua" },
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
	},

	-- { "eandrju/cellular-automaton.nvim" },
	{ "lervag/vimtex" },
	{
		"Xiione/luasnip-latex-snippets.nvim",
		dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
	},

	{ "folke/neodev.nvim" },
	-- { "gen740/SmoothCursor.nvim" },
	-- {
	-- 	"utilyre/barbecue.nvim",
	-- 	name = "barbecue",
	-- 	version = "*",
	-- 	dependencies = {
	-- 		"SmiteshP/nvim-navic",
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- },
	{ "tpope/vim-abolish" },
	{ "echasnovski/mini.surround", version = "*" },
	{ "airblade/vim-matchquote" },
	{ "simrat39/symbols-outline.nvim" },

	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
	},
	{ "nvim-neotest/nvim-nio" },
	{ "j-hui/fidget.nvim" },
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"cbochs/grapple.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		event = { "BufReadPost", "BufNewFile" },
	},
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "Weissle/persistent-breakpoints.nvim" },
	{ "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" } },
	{ "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },
    { "luukvbaal/statuscol.nvim" }
}, {})
