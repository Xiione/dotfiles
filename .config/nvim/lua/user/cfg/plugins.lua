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
	-- Extract username/repo format, lower and strip .nvim suffix
	local name = repo:match(".+/(.+)")
	if not name then
		return { repo } -- fallback to only repo if format is incorrect
	end
    -- only strip dot nvim cuz it looks odd with the .lua extension and likely interferes with require() call
	name = name:gsub("%.nvim$", "")

	-- Try to load config file
	local opts_ok, opts = pcall(require, "user.plugins." .. name)
	if not opts_ok then
		vim.notify("spec: No config found for plugin " .. name .. " (" .. repo .. ")", vim.log.levels.WARN)
		opts = {}
	end

	-- Return full plugin spec with config
	return vim.tbl_extend("force", {
		repo,
		opts = opts,
	}, extras or {})
end

require("lazy").setup({
	{ "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
	{"windwp/nvim-autopairs"}, -- Autopairs, integrates with both cmp and treesitter
	{ "numToStr/Comment.nvim" },
	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	{ "nvim-tree/nvim-web-devicons" },
	-- { "nvim-tree/nvim-tree.lua", version = "1.2" },
	{ "nvim-tree/nvim-tree.lua" },
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
	{ "nvimtools/none-ls.nvim" }, -- for formatters and linters
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
		commit = "4438411",
	},
	{ "mfussenegger/nvim-jdtls" },
	{ "lukas-reineke/virt-column.nvim" },
	{ "mbbill/undotree" },
	{ "norcalli/nvim-colorizer.lua" },
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
	},

	{ "eandrju/cellular-automaton.nvim" },
	{ "lervag/vimtex" },
	{
		"Xiione/luasnip-latex-snippets.nvim",
		dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
	},

	{ "folke/neodev.nvim" },
	-- { "gen740/SmoothCursor.nvim" },
	{
		"adonespitogo/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{ "tpope/vim-abolish" },
	{ "echasnovski/mini.surround", version = "*" },
	{ "airblade/vim-matchquote" },
	-- { "hedyhli/outline.nvim" },
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
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
	},
	{ "luukvbaal/statuscol.nvim" },
	{
		"luckasRanarison/tailwind-tools.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
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
	{
		"nosduco/remote-sshfs.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			provider = "copilot",
			copilot = {
				endpoint = "https://api.githubcopilot.com",
				model = "claude-3.7-sonnet",
				proxy = nil, -- [protocol://]host[:port] Use this proxy
				allow_insecure = false, -- Allow insecure server connections
				timeout = 30000, -- Timeout in milliseconds
				temperature = 0.75,
				max_tokens = 20480,
			},
			auto_suggestions_provider = nil,
			cursor_applying_provider = "copilot",
			memory_summary_provider = "copilot",
			web_search_engine = {
				provider = "google", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
				proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
			},
			behaviour = {
				auto_focus_sidebar = true,
				auto_suggestions = false, -- Experimental stage
				auto_suggestions_respect_ignore = false,
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = true,
				jump_result_buffer_on_finish = false,
				support_paste_from_clipboard = false,
				minimize_diff = true,
				enable_token_counting = true,
				use_cwd_as_project_root = false,
				auto_focus_on_diff_view = false,
			},
		},
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
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}, {})
