local M = {}

local function notify_error(message)
	vim.schedule(function()
		vim.notify(message, vim.log.levels.ERROR)
	end)
end

function M.with_ui_input(callback)
	local original_input = vim.fn.input
	local input_override

	local function restore()
		if vim.fn.input == input_override then
			vim.fn.input = original_input
		end
	end

	local thread = coroutine.create(function()
		local ok, err = xpcall(callback, debug.traceback)
		restore()
		if not ok then
			notify_error(err)
		end
	end)

	input_override = function(prompt, default, completion)
		if coroutine.running() ~= thread then
			return original_input(prompt, default, completion)
		end

		local opts = {
			prompt = prompt or "",
		}
		if default ~= nil and default ~= "" then
			opts.default = tostring(default)
		end
		if completion ~= nil and completion ~= "" then
			opts.completion = completion
		end

		vim.ui.input(opts, function(value)
			vim.schedule(function()
				local ok, err = coroutine.resume(thread, value or "")
				if not ok then
					restore()
					notify_error(err)
				end
			end)
		end)

		return coroutine.yield()
	end

	vim.fn.input = input_override

	local ok, err = coroutine.resume(thread)
	if not ok then
		restore()
		error(err)
	end
end

return M
