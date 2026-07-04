return {
	"catgoose/nvim-colorizer.lua",
	ft = {
		"lua",
		"conf",
		"markdown",
		"cmp_docs",
	},
	opts = {
		lazy_load = false,
		filetypes = {
			"lua",
			"conf",
			"markdown",
			["cmp_docs"] = {
				always_update = true,
				debouce_ms = 0,
			},
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
