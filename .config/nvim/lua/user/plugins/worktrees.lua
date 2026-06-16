return {
	"Juksuu/worktrees.nvim",
	opts = {
		worktree_path = "..",
	},
	config = function(_, opts)
		require("worktrees").setup(opts)

		local worktrees = require("user.lib.worktrees")
		vim.api.nvim_create_user_command("GitWorktreeCreate", worktrees.new, { force = true, nargs = 0 })
		vim.api.nvim_create_user_command(
			"GitWorktreeCreateExisting",
			worktrees.new_existing,
			{ force = true, nargs = 0 }
		)
		vim.api.nvim_create_user_command("GitWorktreeSwitch", worktrees.switch, { force = true, nargs = 0 })
		vim.api.nvim_create_user_command("GitWorktreeRemove", worktrees.remove, { force = true, nargs = 0 })
	end,
}
