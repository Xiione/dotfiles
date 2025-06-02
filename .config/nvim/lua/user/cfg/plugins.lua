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

local function spec(repo, extras)
	-- Extract username/repo format, lower and strip .nvim and .lua suffix
	local name = repo:match(".+/(.+)")
	if not name then
		return { repo } -- fallback to only repo if format is incorrect
	end
	-- only strip dot nvim cuz it looks odd with the .lua extension and likely interferes with require() call
	name = name:gsub("%.nvim$", ""):gsub("%.lua$", "")

	-- Try to load config file
	-- local opts_ok, opts = pcall(require, "user.plugin." .. name)
	-- if not opts_ok then
	-- 	vim.notify("spec: No config found for plugin " .. name .. " (" .. repo .. ")", vim.log.levels.WARN)
	-- 	opts = {}
	-- end
	local opts = require("user.plugin." .. name)

	-- Return full plugin spec with config
	return vim.tbl_extend("force", {
		repo,
		opts = opts,
	}, extras or {})
end

-- to be explicit use table for plugins with no config or configured the old way
require("lazy").setup({
	{ "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
	spec("windwp/nvim-autopairs"), -- Autopairs, integrates with both cmp and treesitter
	spec("numToStr/Comment.nvim"),
	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	{ "nvim-tree/nvim-web-devicons" },
	-- { "nvim-tree/nvim-tree.lua", version = "1.2" },
	spec("nvim-tree/nvim-tree.lua"),
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
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"luckasRanarison/tailwind-tools.nvim",
			"onsails/lspkind-nvim",
		},
	}, -- The completion plugin
	{ "hrsh7th/cmp-buffer" }, -- buffer completions
	{ "hrsh7th/cmp-path" }, -- path completions
	{ "saadparwaiz1/cmp_luasnip" }, -- snippet completions
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "2.*",
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},
	-- { "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use

	-- LSP
	-- use { "williamboman/nvim-lsp-installer" } -- simple to use language server installer
	{ "neovim/nvim-lspconfig" }, -- enable LSP
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "nvimtools/none-ls.nvim" }, -- for formatters and linters
	-- use { "RRethy/vim-illuminate" }

	{ "nvim-telescope/telescope.nvim" },

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},

	-- Git
	spec("lewis6991/gitsigns.nvim"),

	-- DAP
	{ "mfussenegger/nvim-dap" },
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{ "ravenxrz/DAPInstall.nvim" },

	-- mine :)
	spec("jinh0/eyeliner.nvim", { lazy = false }),
	{ "mfussenegger/nvim-jdtls" },
	spec("lukas-reineke/virt-column.nvim"),
	{ "mbbill/undotree" }, -- options supplied through globals in options.lua
	spec("norcalli/nvim-colorizer.lua"),
	spec("folke/persistence.nvim", {
		event = "BufReadPre",
		-- this will only start session saving when an actual file was opened
	}),

	{ "eandrju/cellular-automaton.nvim" },
	{ "lervag/vimtex" },
	{ "Xiione/luasnip-latex-snippets.nvim", dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" } },

	spec("folke/neodev.nvim"),
	-- { "gen740/SmoothCursor.nvim" },
	spec("adonespitogo/barbecue.nvim", {
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
	}),
	{ "tpope/vim-abolish" },
	{ "echasnovski/mini.surround", version = "*", opts = {} },
	{ "airblade/vim-matchquote" },
	-- { "hedyhli/outline.nvim" },
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
	},
	{ "nvim-neotest/nvim-nio" },
	spec("j-hui/fidget.nvim"),
	spec("m4xshen/hardtime.nvim", { dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" } }),
	spec("cbochs/grapple.nvim", {
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = { "BufReadPost", "BufNewFile" },
	}),
	{ "Weissle/persistent-breakpoints.nvim" },
	spec("windwp/nvim-ts-autotag", { event = { "BufReadPre", "BufNewFile" } }),
	spec("kevinhwang91/nvim-ufo", { dependencies = "kevinhwang91/promise-async" }),
	{ "luukvbaal/statuscol.nvim" },
	spec("luckasRanarison/tailwind-tools.nvim", {
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
	}),
	-- { "sunjon/shade.nvim" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{
		"scalameta/nvim-metals",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		ft = { "scala", "sbt", "java" },
	},
	-- { "supermaven-inc/supermaven-nvim" },
	{ "nvim-pack/nvim-spectre" },
	-- { "Xiione/vim-apm" },
	-- { dir = "~/code/me/vim-apm/" },
	-- {
	-- 	"vyfor/cord.nvim",
	-- 	build = ":Cord update",
	-- },
	{
		"dundalek/bloat.nvim",
		cmd = "Bloat",
	},
	{ "leoluz/nvim-dap-go" },
	{ "nosduco/remote-sshfs.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
	{ "nvim-treesitter/nvim-treesitter-context" },
	spec("yetone/avante.nvim", {
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			-- "stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			"HakonHarnes/img-clip.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
		},
	}),
	spec("HakonHarnes/img-clip.nvim", {
		event = "VeryLazy",
	}),
	spec("MeanderingProgrammer/render-markdown.nvim", {
        dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "markdown", "Avante" },
	}),
	spec("folke/snacks.nvim"),
	{ "stevearc/dressing.nvim", opts = {} },
    spec("zbirenbaum/copilot.lua")
}, {})
