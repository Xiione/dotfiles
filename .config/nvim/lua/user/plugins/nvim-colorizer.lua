return {
	"catgoose/nvim-colorizer.lua",
	ft = {
		"lua",
		"conf",
		"markdown",
	},
	opts = {
		lazy_load = false,
		filetypes = {
			"lua",
			"conf",
			"markdown",
		},
		options = {
			parsers = {
				names = {
					enable = false,
				},
			},
		},
	},
}
