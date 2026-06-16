local async_input = require("user.lib.async_input")

local M = {}

local function run(callback)
	async_input.with_ui_input(callback)
end

function M.new()
	run(function()
		require("worktrees").new_worktree()
	end)
end

function M.new_existing()
	run(function()
		require("worktrees").new_worktree(true)
	end)
end

function M.switch()
	run(function()
		require("worktrees").switch_worktree()
	end)
end

function M.remove()
	run(function()
		require("worktrees").remove_worktree()
	end)
end

return M
