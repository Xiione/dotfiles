local utils = require("user.lib.utils")
local map = utils.map
local M = {}
local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local signs = {

		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false, -- enable virtual text
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "solid",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "solid",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "solid",
	})
end

local function lsp_keymaps(bufnr, client)
	local opts = { noremap = true, silent = true }
	map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts, bufnr)
	map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts, bufnr)
	map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts, bufnr)
	map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts, bufnr)
	map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts, bufnr)
	map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts, bufnr)

	if client.name ~= "texlab" then
		map("n", "<leader>li", "<cmd>LspInfo<cr>", opts, bufnr)
		-- map("n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts, bufnr)
		map("n", "<leader>lI", "<cmd>Mason<cr>", opts, bufnr)
		map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts, bufnr)
		map("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts, bufnr)
		map("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts, bufnr)
		map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts, bufnr)
		map("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, bufnr)
		map("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts, bufnr)
	end
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "clangd" then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_keymaps(bufnr, client)
end

return M
