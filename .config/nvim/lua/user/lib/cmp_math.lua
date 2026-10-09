local M = {}

local math_environments = {
	align = true,
	alignat = true,
	equation = true,
	gather = true,
	math = true,
	multline = true,
	flalign = true,
	displaymath = true,
}

local function is_escaped(text, index)
	local count = 0
	for cursor = index - 1, 1, -1 do
		if text:sub(cursor, cursor) ~= "\\" then
			break
		end
		count = count + 1
	end
	return count % 2 == 1
end

local function environment_command(text, index, command)
	local prefix = "\\" .. command
	if text:sub(index, index + #prefix - 1) ~= prefix then
		return nil
	end
	local suffix = text:sub(index + #prefix)
	local spaces = suffix:match("^(%s*)") or ""
	local name = suffix:sub(#spaces + 1):match("^{([%w*]+)}")
	if not name then
		return nil
	end
	return name, #prefix + #spaces + #name + 2
end

local function find_group_end(text, start)
	local depth = 1
	for cursor = start + 1, #text do
		local char = text:sub(cursor, cursor)
		if (char == "{" or char == "}") and not is_escaped(text, cursor) then
			depth = depth + (char == "{" and 1 or -1)
			if depth == 0 then
				return cursor
			end
		end
	end
	return #text
end

local function read_atom(text, start)
	local cursor = start
	local char = text:sub(cursor, cursor)
	if char == "\\" then
		cursor = cursor + 1
		if text:sub(cursor, cursor):match("[%a@]") then
			while text:sub(cursor, cursor):match("[%a@]") do
				cursor = cursor + 1
			end
		elseif cursor <= #text then
			cursor = cursor + 1
		end
	elseif char:match("[%a%d]") then
		while text:sub(cursor, cursor):match("[%w]") do
			cursor = cursor + 1
		end
	else
		return start
	end

	while text:sub(cursor, cursor) == "{" do
		cursor = find_group_end(text, cursor) + 1
	end
	while text:sub(cursor, cursor) == "^" or text:sub(cursor, cursor) == "_" do
		cursor = cursor + 1
		if text:sub(cursor, cursor) == "{" then
			cursor = find_group_end(text, cursor) + 1
		elseif text:sub(cursor, cursor) == "\\" or text:sub(cursor, cursor):match("[%w]") then
			cursor = read_atom(text, cursor)
		end
	end
	while text:sub(cursor, cursor) == "'" do
		cursor = cursor + 1
	end
	return cursor
end

local function parse_ranges(text, filetype)
	local ranges = {}
	local cursor, mode, range_start = 1, nil, nil
	local environments, fence, code_ticks = {}, nil, nil

	while cursor <= #text do
		local at_line_start = cursor == 1 or text:sub(cursor - 1, cursor - 1) == "\n"
		local skipped_line = false
		if filetype == "markdown" and at_line_start and not mode and #environments == 0 then
			local line_end = text:find("\n", cursor, true) or (#text + 1)
			local line = text:sub(cursor, line_end - 1)
			local marker = line:match("^%s*(```+)") or line:match("^%s*(~~~+)")
			if fence then
				local closing = line:match("^%s*(```+)%s*$") or line:match("^%s*(~~~+)%s*$")
				if closing and closing:sub(1, 1) == fence:sub(1, 1) and #closing >= #fence then
					fence = nil
				end
				cursor = line_end + 1
				skipped_line = true
			elseif marker then
				fence = marker
				cursor = line_end + 1
				skipped_line = true
			end
		end

		if skipped_line then
			-- Resume parsing at the start of the next line.
		elseif filetype == "markdown" and not mode and text:sub(cursor, cursor) == "`" then
			local run = text:match("^`+", cursor)
			if code_ticks == #run then
				code_ticks = nil
			else
				code_ticks = code_ticks or #run
			end
			cursor = cursor + #run
		elseif code_ticks then
			cursor = cursor + 1
		elseif filetype == "tex" and text:sub(cursor, cursor) == "%" and not is_escaped(text, cursor) then
			cursor = (text:find("\n", cursor, true) or (#text + 1))
		elseif mode then
			local closer = ({ ["$"] = "$", ["$$"] = "$$", ["\\("] = "\\)", ["\\["] = "\\]" })[mode]
			if text:sub(cursor, cursor + #closer - 1) == closer and not is_escaped(text, cursor) then
				ranges[#ranges + 1] = { range_start, cursor - 1 }
				mode = nil
				cursor = cursor + #closer
			else
				cursor = cursor + 1
			end
		elseif #environments > 0 then
			local name, length = environment_command(text, cursor, "begin")
			if name then
				environments[#environments + 1] = name
				cursor = cursor + length
			else
				name, length = environment_command(text, cursor, "end")
				if name == environments[#environments] then
					environments[#environments] = nil
					if #environments == 0 then
						ranges[#ranges + 1] = { range_start, cursor - 1 }
					end
					cursor = cursor + length
				else
					cursor = cursor + 1
				end
			end
		else
			local char = text:sub(cursor, cursor)
			local delimiter
			if char == "$" and not is_escaped(text, cursor) then
				delimiter = text:sub(cursor, cursor + 1) == "$$" and "$$" or "$"
			elseif text:sub(cursor, cursor + 1) == "\\(" or text:sub(cursor, cursor + 1) == "\\[" then
				delimiter = text:sub(cursor, cursor + 1)
			end
			if delimiter then
				mode, range_start = delimiter, cursor + #delimiter
				cursor = cursor + #delimiter
			else
				local name, length = environment_command(text, cursor, "begin")
				if name and math_environments[name:gsub("%*$", "")] then
					environments, range_start = { name }, cursor + length
					cursor = cursor + length
				else
					cursor = cursor + 1
				end
			end
		end
	end

	if mode or #environments > 0 then
		ranges[#ranges + 1] = { range_start, #text }
	end
	return ranges
end

local function cursor_offset(bufnr)
	local cursor = vim.api.nvim_win_get_cursor(0)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, cursor[1] - 1, false)
	local offset = cursor[2]
	for _, line in ipairs(lines) do
		offset = offset + #line + 1
	end
	return offset
end

local function current_term(text, offset)
	local start = offset
	while start > 0 and text:sub(start, start):match("[%w\\{}_^'*+,-]") do
		start = start - 1
	end
	return text:sub(start + 1, offset)
end

function M.new()
	local source = {}

	function source:is_available()
		return vim.bo.filetype == "tex" or vim.bo.filetype == "markdown"
	end

	function source:get_keyword_pattern()
		return [[[A-Za-z0-9\\{}_^'*+,-]\+]]
	end

	function source:get_trigger_characters()
		return { "\\", "^", "_", "{" }
	end

	function source:complete(params, callback)
		local bufnr = params.context.bufnr
		local filetype = vim.bo[bufnr].filetype
		local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
		local offset = cursor_offset(bufnr)
		local ranges = parse_ranges(text, filetype)
		local in_math = vim.iter(ranges):any(function(range)
			return offset >= range[1] - 1 and offset <= range[2]
		end)
		if not in_math then
			callback({ items = {}, isIncomplete = false })
			return
		end

		local query = current_term(text, offset)
		local line_number = vim.api.nvim_win_get_cursor(0)[1]
		local candidates, seen = {}, {}
		for _, range in ipairs(ranges) do
			local cursor = range[1]
			while cursor <= range[2] do
				local next_cursor = read_atom(text, cursor)
				if next_cursor > cursor then
					local term = text:sub(cursor, next_cursor - 1)
					if #term > 1 and term ~= query then
						local line = select(2, text:sub(1, cursor):gsub("\n", "")) + 1
						local distance = math.abs(line - line_number)
						local item = seen[term]
						if item then
							local best_distance = tonumber(item.sortText:match("^(%d+):"))
							if distance < best_distance then
								item.sortText = string.format("%08d:%s", distance, term)
							end
						else
							item = {
								label = term,
								insertText = term,
								filterText = term,
								sortText = string.format("%08d:%s", distance, term),
								kind = vim.lsp.protocol.CompletionItemKind.Text,
							}
							seen[term] = item
							candidates[#candidates + 1] = item
						end
					end
					cursor = next_cursor
				else
					cursor = cursor + 1
				end
			end
		end
		callback({ items = candidates, isIncomplete = false })
	end

	return source
end

return M
