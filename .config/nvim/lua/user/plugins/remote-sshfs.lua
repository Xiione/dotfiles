return {
	"nosduco/remote-sshfs.nvim",
	enabled = false,
	keys = {
		{
			"<leader>rc",
			function()
				require("remote-sshfs.api").connect()
			end,
			desc = "Connect remote SSHFS",
		},
		{
			"<leader>rd",
			function()
				require("remote-sshfs.api").disconnect()
			end,
			desc = "Disconnect remote SSHFS",
		},
		{
			"<leader>re",
			function()
				require("remote-sshfs.api").edit()
			end,
			desc = "Edit remote SSHFS connections",
		},
	},
	cmd = {
		"RemoteSSHFSConnect",
		"RemoteSSHFSDisconnect",
		"RemoteSSHFSEdit",
		"RemoteSSHFSFindFiles",
		"RemoteSSHFSLiveGrep",
	},
	dependencies = { "folke/snacks.nvim" },
	opts = {
		ui = {
			picker = "snacks",
		},
	},
}
