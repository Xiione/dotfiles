local utils = require("user.lib.utils")
local map = utils.map

local M = {}

local function diagnostic_jump(is_next, severity)
	return function()
		vim.diagnostic.jump({
			count = (is_next and 1 or -1) * vim.v.count1,
			severity = vim.diagnostic.severity[severity],
			float = true,
		})
	end
end

local function restart_clients(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		return
	end

	local names = {}
	for _, client in ipairs(clients) do
		local name = client.config and client.config.name or client.name
		if name then
			names[name] = true
		end
		vim.lsp.stop_client(client.id)
	end

	vim.defer_fn(function()
		for name in pairs(names) do
			vim.lsp.enable(name, false)
			vim.lsp.enable(name, true)
		end
	end, 100)
end

local function toggle_virtual_lines()
	local config = vim.diagnostic.config()
	vim.diagnostic.config({
		virtual_lines = not config.virtual_lines,
	})
end

function M.setup(bufnr, client)
	local opts = { noremap = true, silent = true }
	map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts, bufnr)
	map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts, bufnr)
	map("n", "gl", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts, bufnr)

	if client.name ~= "texlab" then
		map("n", "<leader>li", "<Cmd>LspInfo<CR>", opts, bufnr)
		map("n", "<leader>lI", "<Cmd>Mason<CR>", opts, bufnr)
		map("n", "]e", diagnostic_jump(true, "ERROR"), opts, bufnr)
		map("n", "[e", diagnostic_jump(false, "ERROR"), opts, bufnr)
		map("n", "]w", diagnostic_jump(true, "WARN"), opts, bufnr)
		map("n", "[w", diagnostic_jump(false, "WARN"), opts, bufnr)
		map("n", "<leader>ls", function()
			vim.lsp.buf.signature_help({ border = utils.window_border })
		end, opts, bufnr)
		map("n", "<leader>lq", "<Cmd>lua vim.diagnostic.setloclist()<CR>", opts, bufnr)
		map("n", "<leader>lv", toggle_virtual_lines, opts, bufnr)
		map("n", "<leader>lR", function()
			restart_clients(bufnr)
		end, opts, bufnr)
	end

	if client.name == "tailwindcss" then
		map("n", "<leader>tf", "<Cmd>TailwindSort<CR>", opts, bufnr)
		map("n", "<leader>tt", "<Cmd>TailwindConcealToggle<CR>", opts, bufnr)
		map("n", "<leader>tc", "<Cmd>TailwindConcealEnable<CR>", opts, bufnr)
		map("n", "<leader>to", "<Cmd>TailwindConcealDisable<CR>", opts, bufnr)
	end

	if client.name == "metals" then
		map("n", "<leader>fc", "<Cmd>lua require('telescope').extensions.metals.commands()<CR>", opts, bufnr)
	end

	if client.name == "rust-analyzer" then
		map({ "n", "x" }, "gra", function()
			vim.cmd.RustLsp("codeAction")
		end, opts, bufnr)
		map("n", "K", function()
			vim.cmd.RustLsp({ "hover", "actions" })
		end, opts, bufnr)
	end

	if client.name == "gopls" then
		map("n", "<F6>", function()
			require("dap-go").debug_test()
		end, { noremap = true, silent = true, desc = "Debug nearest test (Go)" }, bufnr)
		map("n", "<F7>", function()
			require("dap-go").debug_last_test()
		end, { noremap = true, silent = true, desc = "Debug last test (Go)" }, bufnr)
	end
end

return M
