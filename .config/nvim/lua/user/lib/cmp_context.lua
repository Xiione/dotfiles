local M = {}

local expressions = {
	lua = { dot_index_expression = true, method_index_expression = true },
	javascript = { member_expression = true },
	typescript = { member_expression = true },
	tsx = { member_expression = true },
	python = { attribute = true },
	c = { field_expression = true },
	cpp = { field_expression = true, qualified_identifier = true },
}

function M.is_member_access()
	local ok, parser = pcall(vim.treesitter.get_parser)
	if not ok or not parser then
		return false
	end
	parser:parse()
	local ok_node, node = pcall(vim.treesitter.get_node)
	if not ok_node or not node then
		return false
	end
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local language = parser:language_for_range({ row - 1, col, row - 1, col }):lang()
	local kinds = expressions[language]
	if not kinds then
		return false
	end
	while node do
		local kind = node:type()
		if kind:find("comment") or kind:find("string") then
			return false
		end
		if kinds[kind] then
			return true
		end
		node = node:parent()
	end
	return false
end

return M
