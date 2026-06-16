return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"luckasRanarison/tailwind-tools.nvim",
		"onsails/lspkind-nvim",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"micangl/cmp-vimtex",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local sidebars = require("user.lib.sidebars")

		cmp.setup({
			enabled = true,
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping(
					cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					{ "i" }
				),
				["<C-j>"] = cmp.mapping(
					cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					{ "i" }
				),
				["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
				["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
				["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				["<C-c>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
				["<C-f>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
				["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i" }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			formatting = {
				fields = { "icon", "abbr", "menu" },
				format = lspkind.cmp_format({
					mode = "symbol",
					preset = "default",
					maxwidth = {
						menu = 50,
						abbr = 50,
					},
					ellipsis_char = "...",
					show_labelDetails = true,
					symbol_map = require("user.lib.utils").lspkind_icons,
				}),
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "vimtex" },
				{ name = "nvim_lua" },
				{ name = "luasnip" },
				{
					name = "buffer",
					option = {
						get_bufnrs = function()
							local bufs = {}
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								local bufnr = vim.api.nvim_win_get_buf(win)
								local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
								if sidebars.sidebar_types_set[ft] == nil then
									bufs[bufnr] = true
								end
							end
							return vim.tbl_keys(bufs)
						end,
					},
				},
				{ name = "path" },
			},
			confirmation = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			window = {
				completion = {
					border = "none",
					winhighlight = sidebars.sidebar_winhl({ cursorline = true }),
					side_padding = 1,
					col_offset = 1,
				},
				documentation = {
					border = "none",
					winhighlight = sidebars.sidebar_winhl({ cursorline = false })
						.. ",MarkdownError:none,luaParenError:none",
					max_width = 40,
					max_height = 15,
				},
			},
			experimental = {
				ghost_text = false,
			},
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			performance = {
				throttle = 0,
			},
		})

		cmp.setup.filetype({ "TelescopePrompt", "snacks_input" }, {
			enabled = false,
		})

		local cmdline_opts = {
			view = {
				entries = {
					name = "custom",
					selection_order = "top_down",
					follow_cursor = false,
				},
			},
			completion = {
				completeopt = "menu,menuone,noselect",
			},
			formatting = {
				fields = { "abbr", "menu" },
			},
		}

		local cmdline_mappings = {
			["<C-j>"] = { c = cmp.mapping.select_next_item() },
			["<C-k>"] = { c = cmp.mapping.select_prev_item() },
		}

		cmp.setup.cmdline(
			{ "/", "?" },
			vim.tbl_extend("force", {
				mapping = cmp.mapping.preset.cmdline(cmdline_mappings),
				sources = {
					{ name = "buffer" },
				},
			}, cmdline_opts)
		)

		cmp.setup.cmdline(
			":",
			vim.tbl_extend("force", {
				mapping = cmp.mapping.preset.cmdline(cmdline_mappings),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			}, cmdline_opts)
		)
	end,
}
