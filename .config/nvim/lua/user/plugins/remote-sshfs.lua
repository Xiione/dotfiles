return {
	"nosduco/remote-sshfs.nvim",
	cmd = {
		"RemoteSSHFSConnect",
		"RemoteSSHFSDisconnect",
		"RemoteSSHFSEdit",
		"RemoteSSHFSFindFiles",
		"RemoteSSHFSLiveGrep",
	},
	dependencies = { "nvim-telescope/telescope.nvim" },
	opts = {
		ui = {
			picker = "telescope",
		},
	},
}
