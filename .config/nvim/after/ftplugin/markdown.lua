vim.opt_local.wrap = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

local function cycle_heading(buf, first_line, last_line)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, last_line, false)
	local selected_lines = {}
	local fence_char, fence_size

	for index = 1, last_line do
		local line = lines[index]
		local fence = line:match("^ ? ? ?(`+)") or line:match("^ ? ? ?(~+)")
		local closing_fence = line:match("^ ? ? ?(`+)%s*$") or line:match("^ ? ? ?(~+)%s*$")
		local in_fence = fence_char ~= nil
		local is_fence_line = fence ~= nil and #fence >= 3

		if is_fence_line then
			local char = fence:sub(1, 1)
			if not in_fence then
				fence_char, fence_size = char, #fence
			elseif closing_fence and char == fence_char and #fence >= fence_size then
				fence_char, fence_size = nil, nil
			end
		end

		if index >= first_line then
			selected_lines[index - first_line + 1] = line
		end

		if index >= first_line and not in_fence and not is_fence_line and line:match("%S") then
			local indent, hashes, tail = line:match("^( ? ? ?)(#+)(.*)$")
			local is_heading = hashes and #hashes <= 6 and (tail == "" or tail:match("^%s"))
			if is_heading then
				local content = tail:gsub("^%s+", "")
				local suffix = content:gsub("%s+#+%s*$", "")
				if #hashes == 6 then
					selected_lines[index - first_line + 1] = indent .. suffix
				else
					selected_lines[index - first_line + 1] = indent .. string.rep("#", #hashes + 1) .. " " .. suffix
				end
			else
				local indent, content = line:match("^( ? ? ?)(.*)$")
				selected_lines[index - first_line + 1] = indent .. "# " .. content
			end
		end
	end

	vim.api.nvim_buf_set_lines(buf, first_line - 1, last_line, false, selected_lines)
end

local buf = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<leader>h", function()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	cycle_heading(buf, line, line)
end, { buffer = buf, desc = "Cycle Markdown heading" })
vim.keymap.set("x", "<leader>h", function()
	local first_line = math.min(vim.fn.line("v"), vim.fn.line("."))
	local last_line = math.max(vim.fn.line("v"), vim.fn.line("."))
	cycle_heading(buf, first_line, last_line)
end, { buffer = buf, desc = "Cycle Markdown headings in selection" })

local undo_ftplugin = vim.b.undo_ftplugin
local undo_heading_maps = "silent! nunmap <buffer> <leader>h | silent! xunmap <buffer> <leader>h"
vim.b.undo_ftplugin = undo_ftplugin and (undo_ftplugin .. " | " .. undo_heading_maps) or undo_heading_maps
