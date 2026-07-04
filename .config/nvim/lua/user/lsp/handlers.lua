local utils = require("user.lib.utils")
local keymaps = require("user.lsp.keymaps")
local icons = require("user.cfg.icons")
local M = {}

local caps_initialized = false
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

M.capabilities = function()
	if not caps_initialized then
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
		caps_initialized = true
	end
	return capabilities
end

-- ufo
-- M.capabilities.textDocument.foldingRange = {
-- 	dynamicRegistration = false,
-- 	lineFoldingOnly = true,
-- }

M.setup = function()
	local config = {
		virtual_text = false, -- enable virtual text
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = icons.diagnostic.error,
				[vim.diagnostic.severity.WARN] = icons.diagnostic.warn,
				[vim.diagnostic.severity.INFO] = icons.diagnostic.info,
				[vim.diagnostic.severity.HINT] = icons.diagnostic.hint,
			},
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = utils.window_border,
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)
	vim.lsp.document_color.enable(true, nil, {
		style = "󰝤 ",
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
		callback = function(ctx)
			local client = vim.lsp.get_client_by_id(ctx.data.client_id)
			if client == nil then
				return
			end

			keymaps.setup(ctx.buf, client)
		end,
	})
end

M.on_attach = function(client, bufnr)
	if client.name == "typescript-language-server" or client.name == "ts_ls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "lua-language-server" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "clangd" then
		client.server_capabilities.documentFormattingProvider = false
	end
end

return M
