local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

local lspkind = require("lspkind")
local sidebars = require("user.lib.sidebars")

cmp.setup({
	enabled = true,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-c>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
		["<C-f>"] = cmp.mapping.confirm({ select = true }),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
				-- elseif check_backspace() then
				-- 	fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	}),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		-- format = function(entry, vim_item)
		-- 	vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
		-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
		-- 	vim_item.menu = ({
		-- 		nvim_lsp = " ",
		-- 		luasnip = "  ",
		-- 		buffer = "󰉿 ",
		-- 		path = "  ",
		-- 	})[entry.source.name]
		-- 	return vim_item
		-- end,
		-- })
		format = lspkind.cmp_format({
			mode = "symbol",
			preset = "default",
			maxwidth = 40,
			ellipsis_char = "...",
			show_labelDetails = true,
			before = require("tailwind-tools.cmp").lspkind_format,
			symbol_map = require("user.lib.utils").lspkind_icons,
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "supermaven" },
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
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = true,
	},
	window = {
		completion = {
			winhighlight = "Normal:NormalSidebar,CursorLine:CursorLineSidebar",
			side_padding = 1,
			col_offset = 1,
			max_width = 40,
			max_height = 10,
		},
		documentation = {
			winhighlight = "Normal:NormalSidebar,MarkdownError:none,luaParenError:none",
			max_width = 40,
			max_height = 10,
		},
	},
	experimental = {
		ghost_text = false,
	},
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
})

cmp.setup.filetype({ "TelescopePrompt" }, {
	sources = {},
})
