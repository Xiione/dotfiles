local M = {}

local function open_fallback(args)
	local path = args.args
	if path ~= "" then
		vim.cmd.cd(vim.fn.fnameescape(path))
	end

	vim.cmd.enew()
	vim.bo.buflisted = false
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.api.nvim_buf_set_name(0, "worktree://" .. vim.fn.getcwd())
end

vim.api.nvim_create_user_command("WorktreeFallback", open_fallback, {
	bar = true,
	complete = "dir",
	nargs = "?",
})

M.__spec = true

M.opts = {
	worktree_path = "..",
	switch_file_command = "WorktreeFallback",
}

local function setup_commands()
	local user_worktrees = require("user.lib.worktrees")

	vim.api.nvim_create_user_command("GitWorktreeCreate", user_worktrees.new, { force = true, nargs = 0 })
	vim.api.nvim_create_user_command("GitWorktreeCreateExisting", user_worktrees.new_existing, { force = true, nargs = 0 })
	vim.api.nvim_create_user_command("GitWorktreeSwitch", user_worktrees.switch, { force = true, nargs = 0 })
	vim.api.nvim_create_user_command("GitWorktreeRemove", user_worktrees.remove, { force = true, nargs = 0 })
end

function M.config(_, opts)
	require("worktrees").setup(opts)
	setup_commands()
end


return M
